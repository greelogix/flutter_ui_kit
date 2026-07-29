import '../../template/architecture_template.dart';
import '../../template/artifact_definition.dart';
import '../state_management_adapter.dart';

/// Riverpod-specific folders, providers, and generation hints.
class RiverpodAdapter extends StateManagementAdapter {
  RiverpodAdapter();

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
  String renderFileContent({
    required String templateName,
    required String content,
    required Map<String, String> variables,
    FeatureArtifactKind? kind,
  }) {
    if (kind == FeatureArtifactKind.screen &&
        templateName == 'screen.dart.template') {
      return '$content\n\n// TODO: expose ${variables['artifact_pascal']} via Riverpod.\n';
    }
    return content;
  }

  @override
  List<GeneratedTestFile> testTemplates(Map<String, String> variables) {
    final snake = variables['feature_snake']!;
    return [
      GeneratedTestFile(
        fileName: '${snake}_provider_test.dart',
        content:
            '''
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('$snake provider placeholder', () {
    expect(true, isTrue);
  });
}
''',
      ),
    ];
  }
}
