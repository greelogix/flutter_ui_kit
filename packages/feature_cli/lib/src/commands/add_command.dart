import 'package:args/command_runner.dart';

import '../console/logger.dart';
import '../services/feature_kit_services.dart';

class AddCommand extends Command<int> {
  AddCommand({required FeatureKitServices services}) : _services = services {
    addSubcommand(_AddArtifactCommand(
      services: services,
      artifact: 'screen',
      description: 'Add a screen to an existing feature.',
    ));
    addSubcommand(_AddArtifactCommand(
      services: services,
      artifact: 'model',
      description: 'Add a model to an existing feature.',
    ));
    addSubcommand(_AddArtifactCommand(
      services: services,
      artifact: 'repository',
      description: 'Add a repository to an existing feature.',
    ));
    addSubcommand(_AddArtifactCommand(
      services: services,
      artifact: 'usecase',
      description: 'Add a use case to an existing feature.',
    ));
  }

  final FeatureKitServices _services;

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
    required this.artifact,
    required this.description,
  }) : _services = services;

  final FeatureKitServices _services;
  final String artifact;

  @override
  String get name => artifact;

  @override
  String get description => description;

  @override
  Future<int> run() async {
    Logger.warn(
      '`feature add $artifact` is planned for v0.2. '
      'Use `feature create` for full feature scaffolding in v0.1.',
    );
    return 0;
  }
}
