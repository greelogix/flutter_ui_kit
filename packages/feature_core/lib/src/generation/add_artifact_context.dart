import '../config/feature_kit_config.dart';
import '../template/artifact_definition.dart';

/// Context for adding a single artifact to an existing feature.
class AddArtifactContext {
  const AddArtifactContext({
    required this.projectRoot,
    required this.config,
    required this.featureName,
    required this.artifactName,
    required this.kind,
    required this.packageName,
  });

  final String projectRoot;
  final FeatureKitConfig config;

  /// Existing feature folder name (snake_case).
  final String featureName;

  /// New artifact name (e.g. `user` for `user_screen.dart`).
  final String artifactName;

  final FeatureArtifactKind kind;
  final String packageName;
}
