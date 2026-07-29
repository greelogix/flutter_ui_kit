import 'package:args/command_runner.dart';

import '../console/logger.dart';
import '../services/feature_kit_services.dart';

class GenerateCommand extends Command<int> {
  GenerateCommand({required FeatureKitServices services})
    : _services = services {
    addSubcommand(_GenerateExportsCommand(services: services));
  }

  final FeatureKitServices _services;

  @override
  String get name => 'generate';

  @override
  String get description => 'Run code generators (exports, routes).';

  @override
  Future<int> run() async {
    Logger.hint(usage);
    return 64;
  }
}

class _GenerateExportsCommand extends Command<int> {
  _GenerateExportsCommand({required FeatureKitServices services})
    : _services = services;

  final FeatureKitServices _services;

  @override
  String get name => 'exports';

  @override
  String get description => 'Regenerate feature barrel export files.';

  @override
  Future<int> run() async {
    Logger.warn(
      '`feature generate exports` is planned for v0.3. '
      'Barrel files are created automatically when `generation.exports` is enabled.',
    );
    return 0;
  }
}
