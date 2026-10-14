/// Example: resolve bundled template path (used by the CLI).
import 'package:flutter_feature_kit_templates/flutter_feature_kit_templates.dart';

void main() {
  final root = TemplatePaths().builtinTemplatesRoot;
  // ignore: avoid_print
  print('Templates: $root');
}
