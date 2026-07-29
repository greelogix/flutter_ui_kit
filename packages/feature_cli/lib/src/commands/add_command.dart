import 'package:args/command_runner.dart';
import 'package:feature_core/feature_core.dart';

import '../console/logger.dart';
import '../services/feature_kit_services.dart';

/// Adds screens, models, repositories, or use cases to existing features.
class AddCommand extends Command<int> {
  AddCommand({required FeatureKitServices services}) {
    addSubcommand(
      _AddArtifactCommand(
        services: services,
        kind: FeatureArtifactKind.screen,
        helpText: 'Add a screen to an existing feature.',
      ),
    );
    addSubcommand(
      _AddArtifactCommand(
        services: services,
        kind: FeatureArtifactKind.model,
        helpText: 'Add a model to an existing feature.',
      ),
    );
    addSubcommand(
      _AddArtifactCommand(
        services: services,
        kind: FeatureArtifactKind.repository,
        helpText: 'Add a repository to an existing feature.',
      ),
    );
    addSubcommand(
      _AddArtifactCommand(
        services: services,
        kind: FeatureArtifactKind.usecase,
        helpText: 'Add a use case to an existing feature.',
      ),
    );
  }

  @override
  String get name => 'add';

  @override
  String get description => 'Add artifacts to an existing feature.';

  @override
  Future<int> run() async {
    Logger.hint(usage);
    return 64;
  }
}

class _AddArtifactCommand extends Command<int> {
  _AddArtifactCommand({
    required FeatureKitServices services,
    required this.kind,
    required this.helpText,
  }) : _services = services {
    argParser.addOption(
      'feature',
      abbr: 'f',
      help: 'Target feature name (snake_case folder under paths.features).',
      mandatory: true,
    );
  }

  final FeatureKitServices _services;
  final FeatureArtifactKind kind;
  final String helpText;

  @override
  String get name => kind.name;

  @override
  String get description => helpText;

  @override
  String get invocation => '${super.invocation} <name>';

  @override
  Future<int> run() async {
    final args = argResults!.rest;
    if (args.isEmpty) {
      throw UsageException('Missing ${kind.name} name.', usage);
    }
    if (args.length > 1) {
      throw UsageException('Only one name is supported.', usage);
    }

    final featureName = argResults!.option('feature')!;
    final artifactName = args.first;

    Logger.title(
      'Adding ${kind.name} $artifactName to feature $featureName...',
    );
    Logger.step('Reading configuration');

    final config = _services.configLoader.loadOrDefaults();
    final packageName = _services.detector.readPackageName() ?? 'app';

    Logger.step('Generating files');
    try {
      final result = _services.generator.addArtifact(
        AddArtifactContext(
          projectRoot: _services.projectRoot,
          config: config,
          featureName: featureName,
          artifactName: artifactName,
          kind: kind,
          packageName: packageName,
        ),
      );

      Logger.step('Created ${result.createdCount} file(s)');
      for (final warning in result.warnings) {
        Logger.warn(warning);
      }
      Logger.done();
      return 0;
    } on FeatureKitException catch (e) {
      Logger.error(e.message);
      return 1;
    }
  }
}
