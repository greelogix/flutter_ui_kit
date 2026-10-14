import 'dart:io';

import 'package:flutter_feature_kit_cli/src/command_runner.dart';

Future<void> main(List<String> args) async {
  final runner = FeatureCommandRunner();
  exitCode = await runner.run(args);
}
