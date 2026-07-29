/// Converts feature and file names between common Dart conventions.
class NameConverter {
  const NameConverter._();

  /// `profile` or `user_profile` → `profile` / `user_profile`
  static String toSnakeCase(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return trimmed;
    }
    final buffer = StringBuffer();
    for (var i = 0; i < trimmed.length; i++) {
      final char = trimmed[i];
      if (char == '-' || char == ' ') {
        buffer.write('_');
        continue;
      }
      if (char == '_') {
        buffer.write('_');
        continue;
      }
      final isUpper = char.toUpperCase() == char && char.toLowerCase() != char;
      if (isUpper && i > 0) {
        final prev = trimmed[i - 1];
        if (prev != '_' && prev.toLowerCase() == prev) {
          buffer.write('_');
        }
      }
      buffer.write(char.toLowerCase());
    }
    return buffer.toString().replaceAll(RegExp('_+'), '_');
  }

  /// `user_profile` → `UserProfile`
  static String toPascalCase(String snake) {
    return snake
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase())
        .join();
  }

  /// `user_profile` → `userProfile`
  static String toCamelCase(String snake) {
    final pascal = toPascalCase(snake);
    if (pascal.isEmpty) {
      return pascal;
    }
    return pascal[0].toLowerCase() + pascal.substring(1);
  }

  static bool isValidFeatureName(String name) {
    final snake = toSnakeCase(name);
    if (snake.isEmpty) {
      return false;
    }
    return RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(snake);
  }
}
