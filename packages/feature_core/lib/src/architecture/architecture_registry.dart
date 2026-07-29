import '../template/architecture_template.dart';
import '../template/template_registry.dart';

/// Built-in and custom architecture discovery (template-based adapters).
class ArchitectureRegistry {
  /// Creates a registry backed by [templateRegistry].
  ArchitectureRegistry({required TemplateRegistry templateRegistry})
    : _templateRegistry = templateRegistry;

  final TemplateRegistry _templateRegistry;

  /// Resolves an architecture template by config id.
  ArchitectureTemplate resolve({
    required String architectureId,
    String? customTemplatePath,
  }) {
    return _templateRegistry.resolve(
      architectureId: architectureId,
      customTemplatePath: customTemplatePath,
    );
  }

  /// Built-in architecture ids shipped with [feature_templates].
  List<String> listBuiltInIds() => _templateRegistry.listBuiltinIds();
}
