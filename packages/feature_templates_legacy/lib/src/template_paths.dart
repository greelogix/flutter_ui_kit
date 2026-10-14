import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart' as p;

/// Locates bundled architecture templates for local and globally installed tools.
class TemplatePaths {
  /// Uses [root], the environment override, or this resolved package's bundle.
  TemplatePaths({String? root}) : _root = root ?? _defaultRoot();

  final String _root;

  /// Directory containing the architecture folders and shared templates.
  String get builtinTemplatesRoot => _root;

  static String _defaultRoot() {
    final override = Platform.environment['FEATURE_KIT_TEMPLATES_ROOT'];
    if (override != null && override.isNotEmpty) return override;

    final library = Isolate.resolvePackageUriSync(
      Uri.parse('package:feature_templates/feature_templates.dart'),
    );
    if (library != null && library.scheme == 'file') {
      final templates = p.join(
        p.dirname(p.dirname(library.toFilePath())),
        'templates',
      );
      if (Directory(templates).existsSync()) return templates;
    }
    throw StateError(
      'Could not locate the Flutter Feature Kit template bundle. '
      'Set FEATURE_KIT_TEMPLATES_ROOT to an existing templates directory.',
    );
  }
}
