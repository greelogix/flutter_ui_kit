import '../../template/architecture_template.dart';
import '../state_management_adapter.dart';

/// Bloc/Cubit-specific presentation folders and cubit files.
class BlocAdapter extends StateManagementAdapter {
  BlocAdapter();

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
        content:
            '''
import 'package:flutter_test/flutter_test.dart';

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
