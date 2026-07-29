import 'dart:io';

import 'package:path/path.dart' as p;

/// Locates bundled architecture templates on disk.
class TemplatePaths {
  TemplatePaths({String? root}) : _root = root ?? _defaultRoot();

  final String _root;

  String get builtinTemplatesRoot => _root;

  static String _defaultRoot() {
    final fromEnv = Platform.environment['FEATURE_KIT_TEMPLATES_ROOT'];
    if (fromEnv != null && fromEnv.isNotEmpty) {
      return fromEnv;
    }

    final packageConfig = File(
      p.join(Directory.current.path, '.dart_tool', 'package_config.json'),
    );
    if (packageConfig.existsSync()) {
      final resolved = _resolveFromPackageConfig(packageConfig.path);
      if (resolved != null) {
        return resolved;
      }
    }

    // Running from monorepo source (tests / development).
    final candidates = [
      p.normalize(
        p.join(Directory.current.path, 'packages', 'feature_templates', 'templates'),
      ),
      p.normalize(
        p.join(
          _findMonorepoRoot(Directory.current.path),
          'packages',
          'feature_templates',
          'templates',
        ),
      ),
    ];
    for (final candidate in candidates) {
      if (Directory(candidate).existsSync()) {
        return candidate;
      }
    }

    throw StateError(
      'Could not locate feature_templates bundle. '
      'Set FEATURE_KIT_TEMPLATES_ROOT or run from a project with feature_templates resolved.',
    );
  }

  static String? _resolveFromPackageConfig(String configPath) {
    final contents = File(configPath).readAsStringSync();
    final nameMarker = '"name": "feature_templates"';
    final index = contents.indexOf(nameMarker);
    if (index < 0) {
      return null;
    }
    final rootUriMarker = '"rootUri":';
    final rootStart = contents.indexOf(rootUriMarker, index);
    if (rootStart < 0) {
      return null;
    }
    final quoteStart = contents.indexOf('"', rootStart + rootUriMarker.length);
    final quoteEnd = contents.indexOf('"', quoteStart + 1);
    if (quoteStart < 0 || quoteEnd < 0) {
      return null;
    }
    final rootUri = contents.substring(quoteStart + 1, quoteEnd);
    final packageRoot = p.normalize(
      p.join(p.dirname(configPath), rootUri),
    );
    final templates = p.join(packageRoot, 'templates');
    if (Directory(templates).existsSync()) {
      return templates;
    }
    return null;
  }

  static String _findMonorepoRoot(String start) {
    var current = Directory(start);
    while (true) {
      final marker = File(p.join(current.path, 'pubspec.yaml'));
      if (marker.existsSync()) {
        final content = marker.readAsStringSync();
        if (content.contains('flutter_feature_kit_workspace') ||
            content.contains('workspace:')) {
          return current.path;
        }
      }
      final parent = current.parent;
      if (parent.path == current.path) {
        return start;
      }
      current = parent;
    }
  }
}
