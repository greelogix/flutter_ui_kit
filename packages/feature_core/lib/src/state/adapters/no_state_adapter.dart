import '../../template/architecture_template.dart';
import '../state_management_adapter.dart';

/// No extra state-management artifacts.
class NoStateAdapter extends StateManagementAdapter {
  NoStateAdapter({String name = 'none'}) : _name = name;

  final String _name;

  @override
  String get name => _name;

  @override
  List<String> presentationSubfolders() => const [];

  @override
  List<TemplateFileEntry> additionalFiles() => const [];

  @override
  List<GeneratedTestFile> testTemplates(Map<String, String> variables) {
    final snake = variables['feature_snake']!;
    final pascal = variables['feature_pascal']!;
    return [
      GeneratedTestFile(
        fileName: '${snake}_repository_test.dart',
        content:
            '''
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$pascal repository', () {
    test('placeholder', () {
      expect(true, isTrue);
    });
  });
}
''',
      ),
    ];
  }
}
