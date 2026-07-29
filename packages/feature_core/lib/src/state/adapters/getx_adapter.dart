import '../../template/architecture_template.dart';
import '../state_management_adapter.dart';

class GetXAdapter extends StateManagementAdapter {
  GetXAdapter();

  @override
  String get name => 'getx';

  @override
  List<String> presentationSubfolders() => const ['presentation/controllers'];

  @override
  List<TemplateFileEntry> additionalFiles() => const [
    TemplateFileEntry(
      relativePath:
          'presentation/controllers/{{feature_snake}}_controller.dart',
      templateName: 'getx_controller.dart.template',
    ),
  ];

  @override
  List<GeneratedTestFile> testTemplates(Map<String, String> variables) {
    final snake = variables['feature_snake']!;
    return [
      GeneratedTestFile(
        fileName: '${snake}_controller_test.dart',
        content:
            '''
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('$snake GetX controller placeholder', () {
    expect(true, isTrue);
  });
}
''',
      ),
    ];
  }
}
