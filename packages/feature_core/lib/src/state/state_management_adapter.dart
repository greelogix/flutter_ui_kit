import '../template/architecture_template.dart';
import '../template/artifact_definition.dart';

/// Pluggable state-management code generation (Phase 2+).
abstract class StateManagementAdapter {
  String get name;

  /// Extra folders under the feature root (e.g. `presentation/providers`).
  List<String> presentationSubfolders();

  /// Optional extra files merged into architecture template.
  List<TemplateFileEntry> additionalFiles();

  /// Adjust architecture template folders/files for this state solution.
  ArchitectureTemplate mergeArchitectureTemplate(ArchitectureTemplate base) {
    return ArchitectureTemplate(
      id: base.id,
      displayName: base.displayName,
      folders: base.folders,
      extraFolders: [...base.extraFolders, ...presentationSubfolders()],
      files: [...base.files, ...additionalFiles()],
    );
  }

  String renderFileContent({
    required String templateName,
    required String content,
    required Map<String, String> variables,
    FeatureArtifactKind? kind,
  }) {
    return content;
  }

  List<GeneratedTestFile> testTemplates(Map<String, String> variables);
}

class GeneratedTestFile {
  const GeneratedTestFile({required this.fileName, required this.content});

  final String fileName;
  final String content;
}
