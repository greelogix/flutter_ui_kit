import 'package:args/command_runner.dart';
import 'package:feature_core/feature_core.dart';

import '../console/logger.dart';
import '../services/feature_kit_services.dart';

class CreateCommand extends Command<int> {
  CreateCommand({required FeatureKitServices services}) : _services = services;

  final FeatureKitServices _services;

  @override
  String get name => 'create';

  @override
  String get description => 'Create a new feature from templates.';

  @override
  String get invocation => '${super.invocation} <name>';

  @override
  Future<int> run() async {
    final args = argResults!.rest;
    if (args.isEmpty) {
      throw UsageException('Missing feature name.', usage);
    }
    if (args.length > 1) {
      throw UsageException('Only one feature name is supported.', usage);
    }

    final featureName = args.first;
    Logger.title('Creating feature $featureName...');

    Logger.step('Reading configuration');
    final config = _services.configLoader.loadOrDefaults();

    final architectureLabel = config.architecture == 'custom'
        ? 'Custom template'
        : _services.registry
            .resolve(
              architectureId: config.architecture,
              customTemplatePath: config.customTemplatePath,
            )
            .displayName;

    Logger.step('Architecture: $architectureLabel');
    Logger.step('State management: ${config.stateManagement}');

    Logger.step('Generating files');
    final packageName =
        _services.detector.readPackageName() ?? 'app';

    final result = _services.generator.createFeature(
      GenerationContext(
        projectRoot: _services.projectRoot,
        config: config,
        featureName: featureName,
        packageName: packageName,
      ),
    );

    Logger.step('Formatting code');
    Logger.step('Created ${result.createdCount} file(s)');

    for (final warning in result.warnings) {
      Logger.warn(warning);
    }

    if (result.skippedPaths.isNotEmpty && Logger.verbose) {
      for (final path in result.skippedPaths) {
        Logger.hint('Skipped: $path');
      }
    }

    Logger.done();
    return 0;
  }
}
