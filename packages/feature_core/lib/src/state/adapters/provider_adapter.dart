import '../../template/architecture_template.dart';
import '../state_management_adapter.dart';

class ProviderAdapter extends StateManagementAdapter {
  ProviderAdapter();

  @override
  String get name => 'provider';

  @override
  List<String> presentationSubfolders() => const ['presentation/providers'];

  @override
  List<TemplateFileEntry> additionalFiles() => const [
    TemplateFileEntry(
      relativePath: 'presentation/providers/{{feature_snake}}_controller.dart',
      templateName: 'provider_controller.dart.template',
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
  test('$snake controller placeholder', () {
    expect(true, isTrue);
  });
}
''',
      ),
    ];
  }
}
