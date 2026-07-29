/// Parsed `featurekit.yaml` configuration.
class FeatureKitConfig {
  const FeatureKitConfig({
    required this.architecture,
    required this.stateManagement,
    required this.navigation,
    required this.dependencyInjection,
    required this.featuresPath,
    required this.generateTests,
    required this.generateExports,
    required this.generateDocumentation,
    this.customTemplatePath,
  });

  factory FeatureKitConfig.defaults() {
    return const FeatureKitConfig(
      architecture: 'feature_first',
      stateManagement: 'none',
      navigation: 'manual',
      dependencyInjection: 'none',
      featuresPath: 'lib/features',
      generateTests: true,
      generateExports: true,
      generateDocumentation: true,
    );
  }

  final String architecture;
  final String stateManagement;
  final String navigation;
  final String dependencyInjection;
  final String featuresPath;
  final bool generateTests;
  final bool generateExports;
  final bool generateDocumentation;

  /// Path to optional `featurekit_template.yaml` for custom architecture.
  final String? customTemplatePath;

  FeatureKitConfig copyWith({
    String? architecture,
    String? stateManagement,
    String? navigation,
    String? dependencyInjection,
    String? featuresPath,
    bool? generateTests,
    bool? generateExports,
    bool? generateDocumentation,
    String? customTemplatePath,
  }) {
    return FeatureKitConfig(
      architecture: architecture ?? this.architecture,
      stateManagement: stateManagement ?? this.stateManagement,
      navigation: navigation ?? this.navigation,
      dependencyInjection: dependencyInjection ?? this.dependencyInjection,
      featuresPath: featuresPath ?? this.featuresPath,
      generateTests: generateTests ?? this.generateTests,
      generateExports: generateExports ?? this.generateExports,
      generateDocumentation:
          generateDocumentation ?? this.generateDocumentation,
      customTemplatePath: customTemplatePath ?? this.customTemplatePath,
    );
  }
}
