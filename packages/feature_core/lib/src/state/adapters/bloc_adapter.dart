import '../../template/architecture_template.dart';
import '../state_management_adapter.dart';

class BlocAdapter implements StateManagementAdapter {
  const BlocAdapter();

  @override
  String get name => 'bloc';

  @override
  List<String> presentationSubfolders() => const ['presentation/bloc'];

  @override
  List<TemplateFileEntry> additionalFiles() => const [
        TemplateFileEntry(
          relativePath: 'presentation/bloc/{{feature_snake}}_cubit.dart',
          templateName: 'bloc_cubit.dart.template',
        ),
      ];

  @override
  List<GeneratedTestFile> testTemplates(Map<String, String> variables) {
    final snake = variables['feature_snake']!;
    return [
      GeneratedTestFile(
        fileName: '${snake}_cubit_test.dart',
        content: '''
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('${snake}Cubit', () {
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
