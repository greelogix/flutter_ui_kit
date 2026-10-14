import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_feature_kit_core/feature_core.dart';

import '../console/logger.dart';
import '../services/feature_kit_services.dart';

class DoctorCommand extends Command<int> {
  DoctorCommand({required this._services});

  final FeatureKitServices _services;

  @override
  String get name => 'doctor';

  @override
  String get description => 'Validate Feature Kit setup in this project.';

  @override
  Future<int> run() async {
    Logger.title('Flutter Feature Kit Doctor');

    var ok = true;

    final pubspec = File('${_services.projectRoot}/pubspec.yaml');
    if (pubspec.existsSync()) {
      Logger.step('pubspec.yaml found');
    } else {
      ok = false;
      Logger.error('pubspec.yaml not found in ${_services.projectRoot}');
    }

    final config = _services.configLoader.configFile;
    if (config.existsSync()) {
      Logger.step('${ConfigLoader.configFileName} found');
      try {
        _services.configLoader.load();
      } on FeatureKitException catch (e) {
        ok = false;
        Logger.error(e.message);
      }
    } else {
      ok = false;
      Logger.warn(
        '${ConfigLoader.configFileName} missing — run `feature init`',
      );
    }

    final templatesRoot = _services.templatePaths.builtinTemplatesRoot;
    if (Directory(templatesRoot).existsSync()) {
      Logger.step('Templates bundle: $templatesRoot');
    } else {
      ok = false;
      Logger.error('Templates bundle not found');
    }

    final architectures = _services.registry.listBuiltinIds();
    Logger.step('Built-in architectures: ${architectures.join(', ')}');

    if (ok) {
      Logger.done();
      return 0;
    }
    return 1;
  }
}
