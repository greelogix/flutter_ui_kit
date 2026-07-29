import '../../template/architecture_template.dart';
import '../state_management_adapter.dart';

class MobXAdapter implements StateManagementAdapter {
  const MobXAdapter();

  @override
  String get name => 'mobx';

  @override
  List<String> presentationSubfolders() => const ['presentation/stores'];

  @override
  List<TemplateFileEntry> additionalFiles() => const [
        TemplateFileEntry(
          relativePath: 'presentation/stores/{{feature_snake}}_store.dart',
          templateName: 'mobx_store.dart.template',
        ),
      ];

  @override
  List<GeneratedTestFile> testTemplates(Map<String, String> variables) {
    final snake = variables['feature_snake']!;
    return [
      GeneratedTestFile(
        fileName: '${snake}_store_test.dart',
        content: '''
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('${snake} store placeholder', () {
    expect(true, isTrue);
  });
}
''',
      ),
    ];
  }
}
