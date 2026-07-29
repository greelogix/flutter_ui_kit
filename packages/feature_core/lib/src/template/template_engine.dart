import '../naming/name_converter.dart';

/// Simple mustache-style `{{key}}` substitution for templates.
class TemplateEngine {
  const TemplateEngine();

  String render(String template, Map<String, String> variables) {
    var result = template;
    for (final entry in variables.entries) {
      result = result.replaceAll('{{${entry.key}}}', entry.value);
    }
    if (result.contains(RegExp(r'\{\{[a-zA-Z0-9_]+\}\}'))) {
      final missing = RegExp(r'\{\{([a-zA-Z0-9_]+)\}\}')
          .allMatches(result)
          .map((m) => m.group(1))
          .toSet();
      throw TemplateRenderException(
        'Unresolved template variables: ${missing.join(', ')}',
      );
    }
    return result;
  }

  Map<String, String> featureVariables({
    required String featureName,
    String? packageName,
  }) {
    final snake = NameConverter.toSnakeCase(featureName);
    final pascal = NameConverter.toPascalCase(snake);
    final camel = NameConverter.toCamelCase(snake);
    return {
      'feature': snake,
      'feature_snake': snake,
      'feature_pascal': pascal,
      'feature_camel': camel,
      'Feature': pascal,
      'package_name': packageName ?? 'app',
    };
  }
}

class TemplateRenderException implements Exception {
  TemplateRenderException(this.message);

  final String message;

  @override
  String toString() => 'TemplateRenderException: $message';
}
