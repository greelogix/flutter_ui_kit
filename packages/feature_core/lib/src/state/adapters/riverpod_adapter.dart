import '../../template/architecture_template.dart';
import '../state_management_adapter.dart';

class RiverpodAdapter implements StateManagementAdapter {
  const RiverpodAdapter();

  @override
  String get name => 'riverpod';

  @override
  List<String> presentationSubfolders() => const ['presentation/providers'];

  @override
  List<TemplateFileEntry> additionalFiles() => const [
        TemplateFileEntry(
          relativePath: 'presentation/providers/{{feature_snake}}_provider.dart',
          templateName: 'riverpod_provider.dart.template',
        ),
      ];

  @override
  List<GeneratedTestFile> testTemplates(Map<String, String> variables) {
    final snake = variables['feature_snake']!;
    return [
      GeneratedTestFile(
        fileName: '${snake}_provider_test.dart',
        content: '''
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('${snake} provider placeholder', () {
    expect(true, isTrue);
  });
}
''',
      ),
    ];
  }
}
