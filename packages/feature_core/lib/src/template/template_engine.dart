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
      final missing = RegExp(
        r'\{\{([a-zA-Z0-9_]+)\}\}',
      ).allMatches(result).map((m) => m.group(1)).toSet();
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
      'artifact': snake,
      'artifact_snake': snake,
      'artifact_pascal': pascal,
      'artifact_camel': camel,
      'Artifact': pascal,
      'package_name': packageName ?? 'app',
    };
  }

  /// Variables for `feature add` templates (includes feature + artifact names).
  Map<String, String> artifactVariables({
    required String featureName,
    required String artifactName,
    String? packageName,
  }) {
    final base = featureVariables(
      featureName: featureName,
      packageName: packageName,
    );
    final artifactSnake = NameConverter.toSnakeCase(artifactName);
    final artifactPascal = NameConverter.toPascalCase(artifactSnake);
    return {
      ...base,
      'artifact': artifactSnake,
      'artifact_snake': artifactSnake,
      'artifact_pascal': artifactPascal,
      'artifact_camel': NameConverter.toCamelCase(artifactSnake),
      'Artifact': artifactPascal,
    };
  }
}

class TemplateRenderException implements Exception {
  TemplateRenderException(this.message);

  final String message;

  @override
  String toString() => 'TemplateRenderException: $message';
}
