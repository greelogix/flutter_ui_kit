import 'package:args/command_runner.dart';
import 'package:feature_core/feature_core.dart';

import '../console/logger.dart';
import '../services/feature_kit_services.dart';

class InitCommand extends Command<int> {
  InitCommand({required FeatureKitServices services}) : _services = services {
    argParser.addFlag(
      'force',
      help: 'Overwrite existing featurekit.yaml',
      negatable: false,
    );
  }

  final FeatureKitServices _services;

  @override
  String get name => 'init';

  @override
  String get description =>
      'Analyze the project and generate featurekit.yaml configuration.';

  @override
  Future<int> run() async {
    final loader = _services.configLoader;
    if (loader.configFile.existsSync() && !argResults!.flag('force')) {
      Logger.warn(
        '${ConfigLoader.configFileName} already exists. Use --force to overwrite.',
      );
      return 0;
    }

    Logger.title('Initializing Flutter Feature Kit');
    Logger.step('Analyzing pubspec.yaml and folder structure');

    final detected = _services.detector.detect();
    loader.write(detected);

    Logger.step('Wrote ${ConfigLoader.configFileName}');
    Logger.step('Architecture: ${detected.architecture}');
    Logger.step('State management: ${detected.stateManagement}');
    Logger.step('Features path: ${detected.featuresPath}');

    if (!_services.detector.isFlutterProject()) {
      Logger.warn('No Flutter SDK dependency detected in pubspec.yaml.');
    }

    Logger.done();
    return 0;
  }
}
