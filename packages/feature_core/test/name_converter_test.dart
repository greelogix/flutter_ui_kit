import 'package:flutter_feature_kit_core/flutter_feature_kit_core.dart';
import 'package:test/test.dart';

void main() {
  group('NameConverter', () {
    test('converts to snake case', () {
      expect(NameConverter.toSnakeCase('UserProfile'), 'user_profile');
      expect(NameConverter.toSnakeCase('user-profile'), 'user_profile');
    });

    test('validates feature names', () {
      expect(NameConverter.isValidFeatureName('auth'), isTrue);
      expect(NameConverter.isValidFeatureName('2bad'), isFalse);
    });
  });

  group('TemplateEngine', () {
    const engine = TemplateEngine();

    test('renders variables', () {
      final output = engine.render(
        'class {{feature_pascal}} {}',
        engine.featureVariables(featureName: 'user_profile'),
      );
      expect(output, 'class UserProfile {}');
    });
  });
}
