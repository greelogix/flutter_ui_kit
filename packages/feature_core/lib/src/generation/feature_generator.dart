import 'dart:io';

import 'package:path/path.dart' as p;

import '../config/feature_kit_config.dart';
import '../errors/feature_kit_exception.dart';
import '../naming/name_converter.dart';
import '../state/state_management_adapter.dart';
import '../state/state_management_registry.dart';
import '../template/artifact_definition.dart';
import '../template/architecture_template.dart';
import '../template/template_engine.dart';
import '../template/template_registry.dart';
import 'add_artifact_context.dart';
import 'dart_formatter.dart';
import 'generation_context.dart';
import 'generation_result.dart';

/// Creates feature folders and files from architecture templates.
class FeatureGenerator {
  FeatureGenerator({
    required TemplateRegistry templateRegistry,
    StateManagementRegistry? stateRegistry,
    TemplateEngine? templateEngine,
    DartSourceFormatter? formatter,
  }) : _templateRegistry = templateRegistry,
       _stateRegistry = stateRegistry ?? StateManagementRegistry(),
       _templateEngine = templateEngine ?? const TemplateEngine(),
       _formatter = formatter ?? DartSourceFormatter();

  final TemplateRegistry _templateRegistry;
  final StateManagementRegistry _stateRegistry;
  final TemplateEngine _templateEngine;
  final DartSourceFormatter _formatter;

  GenerationResult createFeature(GenerationContext context) {
    final snake = NameConverter.toSnakeCase(context.featureName);
    if (!NameConverter.isValidFeatureName(context.featureName)) {
      throw FeatureKitException(
        'Invalid feature name "$snake". Use lowercase letters, numbers, and underscores.',
      );
    }

    final architectureId = _resolveArchitectureId(context.config);
    final template = _templateRegistry.resolve(
      architectureId: architectureId,
      customTemplatePath: context.config.customTemplatePath,
    );

    final adapter = _stateRegistry.resolve(context.config.stateManagement);
    final mergedTemplate = adapter.mergeArchitectureTemplate(template);

    final featureRoot = Directory(
      p.join(context.projectRoot, context.config.featuresPath, snake),
    );

    if (featureRoot.existsSync()) {
      throw FeatureKitException(
        'Feature already exists at ${featureRoot.path}',
      );
    }

    final created = <String>[];
    final skipped = <String>[];
    final warnings = <String>[];

    final variables = _templateEngine.featureVariables(
      featureName: snake,
      packageName: context.packageName,
    );

    _createFolders(featureRoot, mergedTemplate, adapter, variables);

    for (final entry in mergedTemplate.files) {
      final relativePath = _templateEngine.render(
        entry.relativePath,
        variables,
      );
      final targetFile = File(p.join(featureRoot.path, relativePath));
      if (entry.skipIfExists && targetFile.existsSync()) {
        skipped.add(targetFile.path);
        continue;
      }
      final templatePath = _resolveTemplateFilePath(
        architectureId: architectureId,
        customTemplatePath: context.config.customTemplatePath,
        templateName: entry.templateName,
      );
      if (!File(templatePath).existsSync()) {
        warnings.add('Template missing: $templatePath');
        continue;
      }
      var content = File(templatePath).readAsStringSync();
      content = _templateEngine.render(content, variables);
      content = adapter.renderFileContent(
        templateName: entry.templateName,
        content: content,
        variables: variables,
        kind: null,
      );
      if (targetFile.path.endsWith('.dart')) {
        content = _formatter.format(content);
      }
      targetFile.parent.createSync(recursive: true);
      targetFile.writeAsStringSync(content);
      created.add(targetFile.path);
    }

    if (context.config.generateTests) {
      created.addAll(
        _generateTests(
          context: context,
          featureRoot: featureRoot,
          variables: variables,
          adapter: adapter,
        ),
      );
    }

    if (context.config.generateExports) {
      final barrel = _writeBarrelFile(featureRoot, snake, variables);
      if (barrel != null) {
        created.add(barrel);
      }
    }

    if (context.config.generateDocumentation) {
      final doc = _writeFeatureDoc(featureRoot, snake, variables);
      created.add(doc);
    }

    return GenerationResult(
      createdPaths: created,
      skippedPaths: skipped,
      warnings: warnings,
    );
  }

  /// Adds a screen, model, repository, or use case to an existing feature.
  GenerationResult addArtifact(AddArtifactContext context) {
    final featureSnake = NameConverter.toSnakeCase(context.featureName);
    final artifactSnake = NameConverter.toSnakeCase(context.artifactName);

    if (!NameConverter.isValidFeatureName(context.featureName)) {
      throw FeatureKitException('Invalid feature name "$featureSnake".');
    }
    if (!NameConverter.isValidFeatureName(context.artifactName)) {
      throw FeatureKitException('Invalid artifact name "$artifactSnake".');
    }

    final featureRoot = Directory(
      p.join(context.projectRoot, context.config.featuresPath, featureSnake),
    );
    if (!featureRoot.existsSync()) {
      throw FeatureKitException(
        'Feature "$featureSnake" not found at ${featureRoot.path}. '
        'Run `feature create $featureSnake` first.',
      );
    }

    final architectureId = _resolveArchitectureId(context.config);
    final template = _templateRegistry.resolve(
      architectureId: architectureId,
      customTemplatePath: context.config.customTemplatePath,
    );
    final definition = template.artifactFor(context.kind);
    if (definition == null) {
      throw FeatureKitException(
        'Architecture "${template.id}" does not define ${context.kind.name} artifacts.',
      );
    }

    final adapter = _stateRegistry.resolve(context.config.stateManagement);
    final variables = _templateEngine.artifactVariables(
      featureName: featureSnake,
      artifactName: artifactSnake,
      packageName: context.packageName,
    );

    final created = <String>[];
    final skipped = <String>[];
    final warnings = <String>[];

    final relativePath = _templateEngine.render(
      definition.relativePath,
      variables,
    );
    final targetFile = File(p.join(featureRoot.path, relativePath));
    if (targetFile.existsSync()) {
      throw FeatureKitException('File already exists: ${targetFile.path}');
    }

    final templatePath = _resolveTemplateFilePath(
      architectureId: architectureId,
      customTemplatePath: context.config.customTemplatePath,
      templateName: definition.templateName,
    );
    if (!File(templatePath).existsSync()) {
      throw FeatureKitException('Template not found: $templatePath');
    }

    var content = File(templatePath).readAsStringSync();
    content = _templateEngine.render(content, variables);
    content = adapter.renderFileContent(
      templateName: definition.templateName,
      content: content,
      variables: variables,
      kind: context.kind,
    );
    targetFile.parent.createSync(recursive: true);
    if (targetFile.path.endsWith('.dart')) {
      content = _formatter.format(content);
    }
    targetFile.writeAsStringSync(content);
    created.add(targetFile.path);

    if (context.config.generateTests && definition.testTemplateName != null) {
      final testPath = _writeArtifactTest(
        context: context,
        featureRoot: featureRoot,
        variables: variables,
        testTemplateName: definition.testTemplateName!,
        architectureId: architectureId,
      );
      if (testPath != null) {
        created.add(testPath);
      }
    }

    if (context.config.generateExports) {
      final barrel = refreshFeatureExports(
        featureRoot: featureRoot,
        featureSnake: featureSnake,
        variables: _templateEngine.featureVariables(
          featureName: featureSnake,
          packageName: context.packageName,
        ),
      );
      if (barrel != null) {
        created.add(barrel);
      }
    }

    return GenerationResult(
      createdPaths: created,
      skippedPaths: skipped,
      warnings: warnings,
    );
  }

  /// Regenerates `{feature}_feature.dart` barrel exports for [featureRoot].
  String? refreshFeatureExports({
    required Directory featureRoot,
    required String featureSnake,
    required Map<String, String> variables,
  }) {
    return _writeBarrelFile(featureRoot, featureSnake, variables);
  }

  String? _writeArtifactTest({
    required AddArtifactContext context,
    required Directory featureRoot,
    required Map<String, String> variables,
    required String testTemplateName,
    required String architectureId,
  }) {
    final testDir = Directory(
      p.join(
        context.projectRoot,
        'test',
        p.relative(featureRoot.path, from: context.projectRoot),
      ),
    );
    testDir.createSync(recursive: true);

    final testFileName =
        '${variables['artifact_snake']}_'
        '${context.kind == FeatureArtifactKind.screen ? 'screen' : context.kind.name}'
        '_test.dart';
    final testFile = File(p.join(testDir.path, testFileName));
    if (testFile.existsSync()) {
      return null;
    }

    final templatePath = _resolveTemplateFilePath(
      architectureId: architectureId,
      customTemplatePath: context.config.customTemplatePath,
      templateName: testTemplateName,
    );
    if (!File(templatePath).existsSync()) {
      return null;
    }

    var content = File(templatePath).readAsStringSync();
    content = _templateEngine.render(content, variables);
    if (testFile.path.endsWith('.dart')) {
      content = _formatter.format(content);
    }
    testFile.writeAsStringSync(content);
    return testFile.path;
  }

  String _resolveArchitectureId(FeatureKitConfig config) {
    if (config.architecture == 'custom') {
      return 'custom';
    }
    return config.architecture;
  }

  void _createFolders(
    Directory featureRoot,
    ArchitectureTemplate template,
    StateManagementAdapter adapter,
    Map<String, String> variables,
  ) {
    featureRoot.createSync(recursive: true);
    for (final folder in template.folders) {
      final path = _templateEngine.render(folder, variables);
      Directory(p.join(featureRoot.path, path)).createSync(recursive: true);
    }
    for (final folder in adapter.presentationSubfolders()) {
      Directory(p.join(featureRoot.path, folder)).createSync(recursive: true);
    }
    for (final folder in template.extraFolders) {
      final path = _templateEngine.render(folder, variables);
      Directory(p.join(featureRoot.path, path)).createSync(recursive: true);
    }
  }

  String _resolveTemplateFilePath({
    required String architectureId,
    required String? customTemplatePath,
    required String templateName,
  }) {
    if (architectureId == 'custom' && customTemplatePath != null) {
      final customFiles = p.join(
        p.dirname(customTemplatePath),
        'files',
        templateName,
      );
      if (File(customFiles).existsSync()) {
        return customFiles;
      }
    }
    final architectureFile = _templateRegistry.templateFilePath(
      architectureId,
      templateName,
    );
    if (File(architectureFile).existsSync()) {
      return architectureFile;
    }
    final shared = p.join(
      _templateRegistry.builtinTemplatesRoot,
      '_shared',
      'files',
      templateName,
    );
    return shared;
  }

  List<String> _generateTests({
    required GenerationContext context,
    required Directory featureRoot,
    required Map<String, String> variables,
    required StateManagementAdapter adapter,
  }) {
    final created = <String>[];
    final testDir = Directory(
      p.join(
        context.projectRoot,
        'test',
        p.relative(featureRoot.path, from: context.projectRoot),
      ),
    );
    testDir.createSync(recursive: true);

    final testFiles = adapter.testTemplates(variables);
    for (final test in testFiles) {
      final file = File(p.join(testDir.path, test.fileName));
      var content = test.content;
      if (file.path.endsWith('.dart')) {
        content = _formatter.format(content);
      }
      file.writeAsStringSync(content);
      created.add(file.path);
    }
    return created;
  }

  String? _writeBarrelFile(
    Directory featureRoot,
    String snake,
    Map<String, String> variables,
  ) {
    final dartFiles =
        featureRoot
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))
            .where((f) => !p.basename(f.path).endsWith('_test.dart'))
            .where((f) => p.basename(f.path) != '${snake}_feature.dart')
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));

    if (dartFiles.isEmpty) {
      return null;
    }

    final buffer = StringBuffer()
      ..writeln('/// ${variables['feature_pascal']} feature barrel file.')
      ..writeln('library;')
      ..writeln();

    for (final file in dartFiles) {
      final relative = p
          .relative(file.path, from: featureRoot.path)
          .replaceAll(r'\', '/');
      buffer.writeln("export '$relative';");
    }

    final barrel = File(p.join(featureRoot.path, '${snake}_feature.dart'));
    barrel.writeAsStringSync(_formatter.format(buffer.toString()));
    return barrel.path;
  }

  String _writeFeatureDoc(
    Directory featureRoot,
    String snake,
    Map<String, String> variables,
  ) {
    final doc = File(p.join(featureRoot.path, '${snake.toUpperCase()}.md'));
    doc.writeAsStringSync('''
# ${variables['feature_pascal']} Feature

## Responsibilities

- Describe what the `${variables['feature_pascal']}` feature owns.

## Dependencies

- List repositories, services, and other features this module depends on.

## Entry points

- Screens, routes, and public APIs exported from `${snake}_feature.dart`.
''');
    return doc.path;
  }
}
