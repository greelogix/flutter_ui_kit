import '../config/feature_kit_config.dart';

/// Context passed through feature generation.
class GenerationContext {
  GenerationContext({
    required this.projectRoot,
    required this.config,
    required this.featureName,
    required this.packageName,
  });

  final String projectRoot;
  final FeatureKitConfig config;
  final String featureName;
  final String packageName;
}
