import 'dart:io';

import 'package:flutter_feature_kit_core/feature_core.dart';
import 'package:flutter_feature_kit_templates/feature_templates.dart';

/// Wires core packages for CLI commands.
class FeatureKitServices {
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

  final String projectRoot;
  final TemplatePaths templatePaths;
  late final TemplateRegistry registry;
  late final FeatureGenerator generator;
  late final ConfigLoader configLoader;
  late final ProjectDetector detector;
}
