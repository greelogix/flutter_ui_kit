import 'package:feature_templates/feature_templates.dart';
import 'package:test/test.dart';

void main() {
  test('resolves bundled templates directory', () {
    final paths = TemplatePaths();
    expect(paths.builtinTemplatesRoot.endsWith('templates'), isTrue);
  });
}
