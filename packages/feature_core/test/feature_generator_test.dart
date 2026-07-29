import 'dart:io';

import 'package:feature_core/feature_core.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late String projectRoot;
  late TemplateRegistry registry;
  late FeatureGenerator generator;

  setUp(() {
    projectRoot = Directory.systemTemp.createTempSync('ffk_test_').path;
    Directory(
      p.join(projectRoot, 'lib', 'features'),
    ).createSync(recursive: true);

    final templatesRoot = p.normalize(
      p.join(
        Directory.current.path,
        'packages',
        'feature_templates',
        'templates',
      ),
    );

    registry = TemplateRegistry(builtinTemplatesRoot: templatesRoot);
    generator = FeatureGenerator(templateRegistry: registry);

    ConfigLoader(projectRoot: projectRoot).write(
      const FeatureKitConfig(
        architecture: 'feature_first',
        stateManagement: 'none',
        navigation: 'manual',
        dependencyInjection: 'none',
        featuresPath: 'lib/features',
        generateTests: true,
        generateExports: true,
        generateDocumentation: false,
      ),
    );
  });

  tearDown(() {
    Directory(projectRoot).deleteSync(recursive: true);
  });

  test('creates feature_first structure', () {
    final config = ConfigLoader(projectRoot: projectRoot).load();
    final result = generator.createFeature(
      GenerationContext(
        projectRoot: projectRoot,
        config: config,
        featureName: 'profile',
        packageName: 'demo',
      ),
    );

    expect(result.createdCount, greaterThan(3));
    expect(
      File(
        p.join(projectRoot, 'lib/features/profile/screens/profile_screen.dart'),
      ).existsSync(),
      isTrue,
    );
  });
}
