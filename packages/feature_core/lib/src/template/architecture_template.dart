/// Describes folder layout and file templates for an architecture.
class ArchitectureTemplate {
  const ArchitectureTemplate({
    required this.id,
    required this.displayName,
    required this.folders,
    required this.files,
    this.extraFolders = const [],
  });

  final String id;
  final String displayName;

  /// Folder names relative to the feature root (e.g. `data`, `domain`).
  final List<String> folders;

  /// Optional nested folders under presentation (state-management adapters).
  final List<String> extraFolders;

  /// File entries: relative path pattern → template file name.
  final List<TemplateFileEntry> files;
}

/// A generated file within a feature.
class TemplateFileEntry {
  const TemplateFileEntry({
    required this.relativePath,
    required this.templateName,
    this.skipIfExists = false,
  });

  /// Path relative to feature root, may contain `{{placeholders}}`.
  final String relativePath;

  /// Name of `.dart.template` file in the template bundle.
  final String templateName;

  final bool skipIfExists;
}
