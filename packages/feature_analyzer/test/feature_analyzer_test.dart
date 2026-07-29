import 'package:feature_analyzer/feature_analyzer.dart';
import 'package:test/test.dart';

void main() {
  test('analyzer placeholder is not implemented yet', () {
    const analyzer = FeatureAnalyzer();
    expect(analyzer.isImplemented, isFalse);
  });
}
