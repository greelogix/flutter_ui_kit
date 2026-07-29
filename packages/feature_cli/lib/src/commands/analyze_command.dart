import 'package:args/command_runner.dart';

import '../console/logger.dart';
import '../services/feature_kit_services.dart';

class AnalyzeCommand extends Command<int> {
  AnalyzeCommand({required FeatureKitServices services}) : _services = services;

  final FeatureKitServices _services;

  @override
  String get name => 'analyze';

  @override
  String get description => 'Inspect features for structure issues (v0.4).';

  @override
  Future<int> run() async {
    Logger.warn(
      '`feature analyze` is planned for v0.4 (feature_analyzer package).',
    );
    return 0;
  }
}
