import 'package:args/command_runner.dart';

import '../console/logger.dart';
import '../services/feature_kit_services.dart';

class DocsCommand extends Command<int> {
  DocsCommand({required FeatureKitServices services}) : _services = services;

  final FeatureKitServices _services;

  @override
  String get name => 'docs';

  @override
  String get description => 'Generate feature documentation markdown.';

  @override
  String get invocation => '${super.invocation} <feature>';

  @override
  Future<int> run() async {
    Logger.warn(
      '`feature docs` regenerates PROFILE.md-style docs in v0.3+. '
      'New features already include a feature README when documentation generation is enabled.',
    );
    return 0;
  }
}
