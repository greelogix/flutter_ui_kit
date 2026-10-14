import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../errors/feature_kit_exception.dart';
import 'feature_kit_config.dart';

/// Loads and saves [FeatureKitConfig] from `featurekit.yaml`.
class ConfigLoader {
  ConfigLoader({String? projectRoot})
    : projectRoot = projectRoot ?? Directory.current.path;

  final String projectRoot;

  static const configFileName = 'featurekit.yaml';
  static const customTemplateFileName = 'featurekit_template.yaml';

  File get configFile => File(p.join(projectRoot, configFileName));

  File get customTemplateFile =>
      File(p.join(projectRoot, customTemplateFileName));

  /// Returns config from disk or defaults if missing.
  FeatureKitConfig loadOrDefaults() {
    if (!configFile.existsSync()) {
      return FeatureKitConfig.defaults();
    }
    return load();
  }

  FeatureKitConfig load() {
    try {
      final contents = configFile.readAsStringSync();
      final doc = loadYaml(contents);
      if (doc is! YamlMap) {
        throw FeatureKitException(
          'Invalid $configFileName: root must be a map.',
        );
      }
      return _parse(doc);
    } on FeatureKitException {
      rethrow;
    } on YamlException catch (e) {
      throw FeatureKitException('Failed to parse $configFileName', cause: e);
    } on IOException catch (e) {
      throw FeatureKitException('Failed to read $configFileName', cause: e);
    }
  }

  FeatureKitConfig _parse(YamlMap doc) {
    final project = _map(doc['project']);
    final paths = _map(doc['paths']);
    final generation = _map(doc['generation']);

    final customPath = customTemplateFile.existsSync()
        ? customTemplateFile.path
        : null;

    return FeatureKitConfig(
      architecture: _string(project['architecture'], 'feature_first'),
      stateManagement: _string(project['state_management'], 'none'),
      navigation: _string(project['navigation'], 'manual'),
      dependencyInjection: _string(project['dependency_injection'], 'none'),
      featuresPath: _string(paths['features'], 'lib/features'),
      generateTests: _bool(generation['tests'], true),
      generateExports: _bool(generation['exports'], true),
      generateDocumentation: _bool(generation['documentation'], true),
      customTemplatePath: customPath,
    );
  }

  void write(FeatureKitConfig config) {
    final buffer = StringBuffer()
      ..writeln('# Flutter Feature Kit configuration')
      ..writeln('# https://github.com/greelogix/flutter_ui_kit')
      ..writeln()
      ..writeln('project:')
      ..writeln('  architecture: ${config.architecture}')
      ..writeln('  state_management: ${config.stateManagement}')
      ..writeln('  navigation: ${config.navigation}')
      ..writeln('  dependency_injection: ${config.dependencyInjection}')
      ..writeln()
      ..writeln('paths:')
      ..writeln('  features: ${config.featuresPath}')
      ..writeln()
      ..writeln('generation:')
      ..writeln('  tests: ${config.generateTests}')
      ..writeln('  exports: ${config.generateExports}')
      ..writeln('  documentation: ${config.generateDocumentation}');

    configFile.writeAsStringSync(buffer.toString());
  }

  static YamlMap _map(Object? value) {
    if (value == null) {
      return YamlMap();
    }
    if (value is YamlMap) {
      return value;
    }
    throw FeatureKitException('Expected YAML map, got ${value.runtimeType}.');
  }

  static String _string(Object? value, String fallback) {
    if (value == null) {
      return fallback;
    }
    return value.toString();
  }

  static bool _bool(Object? value, bool fallback) {
    if (value == null) {
      return fallback;
    }
    if (value is bool) {
      return value;
    }
    return fallback;
  }
}
