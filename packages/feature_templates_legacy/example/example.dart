/// Example: resolve bundled template path (used by the CLI).
import 'package:feature_templates/feature_templates.dart';

void main() {
  final root = TemplatePaths().builtinTemplatesRoot;
  // ignore: avoid_print
  print('Templates: $root');
}
