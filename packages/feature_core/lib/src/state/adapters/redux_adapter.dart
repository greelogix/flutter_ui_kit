import '../../template/architecture_template.dart';
import '../state_management_adapter.dart';

/// Redux store scaffolding under `presentation/store`.
class ReduxAdapter extends StateManagementAdapter {
  ReduxAdapter();

  @override
  String get name => 'redux';

  @override
  List<String> presentationSubfolders() => const ['presentation/store'];

  @override
  List<TemplateFileEntry> additionalFiles() => const [
    TemplateFileEntry(
      relativePath: 'presentation/store/{{feature_snake}}_reducer.dart',
      templateName: 'redux_reducer.dart.template',
    ),
  ];

  @override
  List<GeneratedTestFile> testTemplates(Map<String, String> variables) {
    final snake = variables['feature_snake']!;
    return [
      GeneratedTestFile(
        fileName: '${snake}_reducer_test.dart',
        content:
            '''
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('$snake reducer placeholder', () {
    expect(true, isTrue);
  });
}
''',
      ),
    ];
  }
}
