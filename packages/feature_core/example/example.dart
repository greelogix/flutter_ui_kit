/// Example: load config and resolve a clean architecture template.
import 'package:feature_core/feature_core.dart';
import 'package:feature_templates/feature_templates.dart';

void main() {
  final registry = TemplateRegistry(
    builtinTemplatesRoot: TemplatePaths().builtinTemplatesRoot,
  );
  final template = registry.resolve(architectureId: 'clean');
  // ignore: avoid_print
  print('Architecture: ${template.displayName}');
  // ignore: avoid_print
  print('Artifact kinds: ${template.artifacts.keys.join(', ')}');
}
