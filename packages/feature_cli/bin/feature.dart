import 'dart:io';

import 'package:feature_cli/src/command_runner.dart';

Future<void> main(List<String> args) async {
  final runner = FeatureCommandRunner();
  exitCode = await runner.run(args);
}
