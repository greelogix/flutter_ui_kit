import 'package:flutter_feature_kit_templates/flutter_feature_kit_templates.dart';
import 'dart:io';

import 'package:flutter_feature_kit_core/flutter_feature_kit_core.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late String projectRoot;
  late TemplateRegistry registry;
  late FeatureGenerator generator;

  setUp(() {
    projectRoot = Directory.systemTemp.createTempSync('ffk_test_').path;
    Directory(
      p.join(projectRoot, 'lib', 'features'),
    ).createSync(recursive: true);

    final templatesRoot = TemplatePaths().builtinTemplatesRoot;

    registry = TemplateRegistry(builtinTemplatesRoot: templatesRoot);
    generator = FeatureGenerator(templateRegistry: registry);

    ConfigLoader(projectRoot: projectRoot).write(
      const FeatureKitConfig(
        architecture: 'feature_first',
        stateManagement: 'none',
        navigation: 'manual',
        dependencyInjection: 'none',
        featuresPath: 'lib/features',
        generateTests: true,
        generateExports: true,
        generateDocumentation: false,
      ),
    );
  });

  tearDown(() {
    Directory(projectRoot).deleteSync(recursive: true);
  });

  test('creates feature_first structure', () {
    final config = ConfigLoader(projectRoot: projectRoot).load();
    final result = generator.createFeature(
      GenerationContext(
        projectRoot: projectRoot,
        config: config,
        featureName: 'profile',
        packageName: 'demo',
      ),
    );

    expect(result.createdCount, greaterThan(3));
    expect(
      File(
        p.join(projectRoot, 'lib/features/profile/screens/profile_screen.dart'),
      ).existsSync(),
      isTrue,
    );
  });
  for (final architecture in ['feature_first', 'clean', 'mvvm', 'mvc', 'mvi']) {
    for (final state in StateManagementRegistry().supportedIds()) {
      test('generates $architecture with $state without missing templates', () {
        final result = generator.createFeature(
          GenerationContext(
            projectRoot: projectRoot,
            config: FeatureKitConfig.defaults().copyWith(
              architecture: architecture,
              stateManagement: state,
            ),
            featureName: 'checkout',
            packageName: 'demo',
          ),
        );
        expect(result.warnings, isEmpty);
        expect(result.createdCount, greaterThan(3));
        final declarations = <String>{};
        for (final path in result.createdPaths) {
          expect(File(path).existsSync(), isTrue);
          if (path.endsWith('.dart')) {
            final content = File(path).readAsStringSync();
            expect(content, isNot(contains('{{')));
            if (!path.endsWith('_test.dart')) {
              for (final match in RegExp(
                r'class\s+(\w+)',
              ).allMatches(content)) {
                expect(
                  declarations.add(match.group(1)!),
                  isTrue,
                  reason: 'Duplicate exported class in $path',
                );
              }
            }
            expect(DartSourceFormatter().format(content), content);
          }
        }
      });
    }
  }
}
