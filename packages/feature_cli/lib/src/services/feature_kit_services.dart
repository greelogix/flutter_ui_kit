import 'dart:io';

import 'package:flutter_feature_kit_core/feature_core.dart';
import 'package:flutter_feature_kit_templates/feature_templates.dart';

/// Wires core packages for CLI commands.
class FeatureKitServices {
  /// Creates services for [projectRoot] using the bundled or supplied templates.
  FeatureKitServices({String? projectRoot, TemplatePaths? templatePaths})
    : projectRoot = projectRoot ?? Directory.current.path,
      templatePaths = templatePaths ?? TemplatePaths() {
    registry = TemplateRegistry(
      builtinTemplatesRoot: this.templatePaths.builtinTemplatesRoot,
    );
    generator = FeatureGenerator(templateRegistry: registry);
    configLoader = ConfigLoader(projectRoot: this.projectRoot);
    detector = ProjectDetector(projectRoot: this.projectRoot);
  }

  /// Flutter project directory where commands read and generate files.
  final String projectRoot;
  /// Location of architecture manifests and shared templates.
  final TemplatePaths templatePaths;
  /// Registry used to resolve architecture manifests.
  late final TemplateRegistry registry;
  /// Generator used to create features and add artifacts.
  late final FeatureGenerator generator;
  /// Reads and writes the project configuration.
  late final ConfigLoader configLoader;
  /// Detects project metadata and configuration defaults.
  late final ProjectDetector detector;
}
