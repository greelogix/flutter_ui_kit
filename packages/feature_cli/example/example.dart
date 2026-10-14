import 'package:flutter_feature_kit_cli/flutter_feature_kit_cli.dart';

Future<void> main() async {
  final runner = FeatureCommandRunner();
  await runner.run(['--help']);
}
