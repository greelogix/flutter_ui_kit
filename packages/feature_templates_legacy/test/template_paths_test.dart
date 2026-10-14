import 'dart:io';

import 'package:feature_templates/feature_templates.dart';
import 'package:test/test.dart';

void main() {
  test('resolves the actual bundled architecture files', () {
    final root = TemplatePaths().builtinTemplatesRoot;
    for (final architecture in [
      'clean',
      'feature_first',
      'mvc',
      'mvi',
      'mvvm',
    ]) {
      expect(
        File('$root/$architecture/architecture.yaml').existsSync(),
        isTrue,
      );
    }
    expect(
      File('$root/_shared/files/screen.dart.template').existsSync(),
      isTrue,
    );
  });
  test('resolves its bundle from an unrelated working directory', () {
    final original = Directory.current;
    final temporary = Directory.systemTemp.createTempSync('ffk_templates_');
    try {
      Directory.current = temporary;
      expect(
        Directory(TemplatePaths().builtinTemplatesRoot).existsSync(),
        isTrue,
      );
    } finally {
      Directory.current = original;
      temporary.deleteSync();
    }
  });
  test('respects an explicit root', () {
    expect(
      TemplatePaths(root: '/custom/templates').builtinTemplatesRoot,
      '/custom/templates',
    );
  });
}
