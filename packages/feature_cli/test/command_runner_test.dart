import 'package:feature_cli/src/command_runner.dart';
import 'package:test/test.dart';

void main() {
  group('FeatureCommandRunner', () {
    test('exposes create and init commands', () {
      final runner = FeatureCommandRunner();
      final names = runner.commands.keys.toSet();
      expect(names, containsAll(['init', 'create', 'doctor', 'add']));
    });
  });
}
