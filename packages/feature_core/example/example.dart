import 'package:flutter_feature_kit_core/flutter_feature_kit_core.dart';

void main() {
  const engine = TemplateEngine();
  final variables = engine.featureVariables(featureName: 'user_profile');
  print(engine.render('class {{feature_pascal}} {}', variables));
}
