import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../errors/feature_kit_exception.dart';
import 'architecture_template.dart';

/// Resolves architecture templates from built-in bundles and custom YAML.
class TemplateRegistry {
  TemplateRegistry({
    required this.builtinTemplatesRoot,
  });

  final String builtinTemplatesRoot;

  ArchitectureTemplate resolve({
    required String architectureId,
    String? customTemplatePath,
  }) {
    if (architectureId == 'custom') {
      if (customTemplatePath == null || !File(customTemplatePath).existsSync()) {
        throw FeatureKitException(
          'Custom architecture requires featurekit_template.yaml in the project root.',
        );
      }
      return _loadCustomYaml(customTemplatePath);
    }

    final builtinDir = Directory(
      p.join(builtinTemplatesRoot, architectureId),
    );
    if (!builtinDir.existsSync()) {
      throw FeatureKitException(
        'Unknown architecture "$architectureId". '
        'Use feature init or set a valid architecture in featurekit.yaml.',
      );
    }
    return _loadBuiltinYaml(p.join(builtinDir.path, 'architecture.yaml'));
  }

  List<String> listBuiltinIds() {
    final root = Directory(builtinTemplatesRoot);
    if (!root.existsSync()) {
      return [];
    }
    return root
        .listSync()
        .whereType<Directory>()
        .map((d) => p.basename(d.path))
        .where((name) => !name.startsWith('.'))
        .toList()
      ..sort();
  }

  ArchitectureTemplate _loadBuiltinYaml(String path) {
    return _parseArchitectureYaml(File(path));
  }

  ArchitectureTemplate _loadCustomYaml(String path) {
    return _parseArchitectureYaml(File(path), isCustom: true);
  }

  ArchitectureTemplate _parseArchitectureYaml(
    File file, {
    bool isCustom = false,
  }) {
    if (!file.existsSync()) {
      throw FeatureKitException('Architecture template not found: ${file.path}');
    }
    final doc = loadYaml(file.readAsStringSync());
    if (doc is! YamlMap) {
      throw FeatureKitException('Invalid architecture YAML: ${file.path}');
    }

    final id = doc['name']?.toString() ??
        (isCustom ? 'custom' : p.basename(p.dirname(file.path)));
    final displayName =
        doc['display_name']?.toString() ?? _titleCase(id.replaceAll('_', ' '));

    final folders = <String>[];
    final folderList = doc['folders'];
    if (folderList is YamlList) {
      for (final item in folderList) {
        folders.add(item.toString());
      }
    }

    final files = <TemplateFileEntry>[];
    final filesList = doc['files'];
    if (filesList is YamlList) {
      for (final item in filesList) {
        if (item is! YamlMap) {
          continue;
        }
        final pathValue = item['path']?.toString();
        final template = item['template']?.toString();
        if (pathValue == null || template == null) {
          continue;
        }
        files.add(
          TemplateFileEntry(
            relativePath: pathValue,
            templateName: template,
            skipIfExists: item['skip_if_exists'] == true,
          ),
        );
      }
    }

    final extraFolders = <String>[];
    final extra = doc['extra_folders'];
    if (extra is YamlList) {
      for (final item in extra) {
        extraFolders.add(item.toString());
      }
    }

    return ArchitectureTemplate(
      id: id,
      displayName: displayName,
      folders: folders,
      extraFolders: extraFolders,
      files: files,
    );
  }

  String templateFilePath(String architectureId, String templateName) {
    return p.join(builtinTemplatesRoot, architectureId, 'files', templateName);
  }

  String customTemplateFilePath(String architectureRoot, String templateName) {
    return p.join(p.dirname(architectureRoot), 'files', templateName);
  }

  static String _titleCase(String input) {
    return input
        .split(' ')
        .map(
          (w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1),
        )
        .join(' ');
  }
}
