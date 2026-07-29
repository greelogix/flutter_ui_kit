import '../../template/architecture_template.dart';
import '../state_management_adapter.dart';

/// [ValueNotifier] / [ChangeNotifier] style presentation helpers.
class ValueNotifierAdapter extends StateManagementAdapter {
  ValueNotifierAdapter();

  @override
  String get name => 'value_notifier';

  @override
  List<String> presentationSubfolders() => const ['presentation/notifiers'];

  @override
  List<TemplateFileEntry> additionalFiles() => const [
    TemplateFileEntry(
      relativePath: 'presentation/notifiers/{{feature_snake}}_notifier.dart',
      templateName: 'value_notifier.dart.template',
    ),
  ];

  @override
  List<GeneratedTestFile> testTemplates(Map<String, String> variables) {
    final snake = variables['feature_snake']!;
    return [
      GeneratedTestFile(
        fileName: '${snake}_notifier_test.dart',
        content:
            '''
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('$snake notifier placeholder', () {
    expect(true, isTrue);
  });
}
''',
      ),
    ];
  }
}
