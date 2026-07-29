import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../config/feature_kit_config.dart';

/// Inspects a Flutter/Dart project to suggest [FeatureKitConfig] values.
class ProjectDetector {
  ProjectDetector({String? projectRoot})
      : projectRoot = projectRoot ?? Directory.current.path;

  final String projectRoot;

  FeatureKitConfig detect() {
    final pubspec = _readPubspec();
    final deps = _dependencyNames(pubspec);

    return FeatureKitConfig(
      architecture: _detectArchitecture(),
      stateManagement: _detectStateManagement(deps),
      navigation: _detectNavigation(deps),
      dependencyInjection: _detectDi(deps),
      featuresPath: _detectFeaturesPath(),
      generateTests: true,
      generateExports: true,
      generateDocumentation: true,
    );
  }

  String? readPackageName() {
    final pubspec = _readPubspec();
    return pubspec?['name']?.toString();
  }

  bool isFlutterProject() {
    final pubspec = _readPubspec();
    if (pubspec == null) {
      return false;
    }
    final deps = _map(pubspec['dependencies']);
    return deps.containsKey('flutter');
  }

  YamlMap? _readPubspec() {
    final file = File(p.join(projectRoot, 'pubspec.yaml'));
    if (!file.existsSync()) {
      return null;
    }
    final doc = loadYaml(file.readAsStringSync());
    return doc is YamlMap ? doc : null;
  }

  Set<String> _dependencyNames(YamlMap? pubspec) {
    if (pubspec == null) {
      return {};
    }
    final names = <String>{};
    for (final key in ['dependencies', 'dev_dependencies']) {
      final section = _map(pubspec[key]);
      names.addAll(section.keys.map((k) => k.toString()));
    }
    return names;
  }

  String _detectStateManagement(Set<String> deps) {
    if (deps.contains('flutter_riverpod') || deps.contains('riverpod')) {
      return 'riverpod';
    }
    if (deps.contains('flutter_bloc') || deps.contains('bloc')) {
      return 'bloc';
    }
    if (deps.contains('provider')) {
      return 'provider';
    }
    if (deps.contains('get')) {
      return 'getx';
    }
    if (deps.contains('mobx') || deps.contains('flutter_mobx')) {
      return 'mobx';
    }
    if (deps.contains('redux') || deps.contains('flutter_redux')) {
      return 'redux';
    }
    return 'none';
  }

  String _detectNavigation(Set<String> deps) {
    if (deps.contains('go_router')) {
      return 'go_router';
    }
    if (deps.contains('auto_route')) {
      return 'auto_route';
    }
    return 'manual';
  }

  String _detectDi(Set<String> deps) {
    if (deps.contains('get_it')) {
      return 'get_it';
    }
    if (deps.contains('injectable')) {
      return 'injectable';
    }
    if (deps.contains('flutter_riverpod') || deps.contains('riverpod')) {
      return 'riverpod';
    }
    if (deps.contains('provider')) {
      return 'provider';
    }
    return 'none';
  }

  String _detectArchitecture() {
    final lib = Directory(p.join(projectRoot, 'lib'));
    if (!lib.existsSync()) {
      return 'feature_first';
    }

    final hasClean = _hasSubfolderPattern(lib, ['data', 'domain', 'presentation']);
    if (hasClean) {
      return 'clean';
    }
    final hasMvvm = _hasSubfolderPattern(lib, ['models', 'views', 'viewmodels']);
    if (hasMvvm) {
      return 'mvvm';
    }
    final featuresDir = Directory(p.join(lib.path, 'features'));
    if (featuresDir.existsSync()) {
      return 'feature_first';
    }
    return 'feature_first';
  }

  String _detectFeaturesPath() {
    final candidates = [
      'lib/features',
      'lib/src/features',
      'lib/presentation/features',
    ];
    for (final candidate in candidates) {
      if (Directory(p.join(projectRoot, candidate)).existsSync()) {
        return candidate;
      }
    }
    return 'lib/features';
  }

  bool _hasSubfolderPattern(Directory root, List<String> folders) {
    for (final entity in root.listSync(recursive: true).whereType<Directory>()) {
      final relative = p.relative(entity.path, from: root.path);
      final parts = p.split(relative);
      if (parts.length >= 3) {
        final slice = parts.sublist(parts.length - 3);
        if (_listEquals(slice, folders)) {
          return true;
        }
      }
    }
    return false;
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  YamlMap _map(Object? value) {
    if (value is YamlMap) {
      return value;
    }
    return YamlMap();
  }
}
