/// Maps an artifact type (screen, model, etc.) to a generated file.
class ArtifactDefinition {
  const ArtifactDefinition({
    required this.relativePath,
    required this.templateName,
    this.testTemplateName,
  });

  /// Path under the feature root; supports `{{artifact_snake}}` placeholders.
  final String relativePath;

  final String templateName;

  /// Optional widget/unit test template in `_shared/files`.
  final String? testTemplateName;
}

/// Supported artifact kinds for `feature add`.
enum FeatureArtifactKind { screen, model, repository, usecase }
