import 'dart:io';

import 'package:feature_core/feature_core.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late String projectRoot;
  late FeatureGenerator generator;

  setUp(() {
    projectRoot = Directory.systemTemp.createTempSync('ffk_add_').path;
    final features = Directory(p.join(projectRoot, 'lib', 'features', 'auth'));
    features.createSync(recursive: true);
    File(p.join(features.path, '.keep')).writeAsStringSync('');

    final templatesRoot = p.normalize(
      p.join(
        Directory.current.path,
        'packages',
        'feature_templates',
        'templates',
      ),
    );

    generator = FeatureGenerator(
      templateRegistry: TemplateRegistry(builtinTemplatesRoot: templatesRoot),
    );

    ConfigLoader(projectRoot: projectRoot).write(
      const FeatureKitConfig(
        architecture: 'clean',
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

  test('addArtifact creates screen under clean architecture paths', () {
    final config = ConfigLoader(projectRoot: projectRoot).load();
    final result = generator.addArtifact(
      AddArtifactContext(
        projectRoot: projectRoot,
        config: config,
        featureName: 'auth',
        artifactName: 'login',
        kind: FeatureArtifactKind.screen,
        packageName: 'demo',
      ),
    );

    expect(result.createdCount, greaterThan(0));
    expect(
      File(
        p.join(
          projectRoot,
          'lib/features/auth/presentation/screens/login_screen.dart',
        ),
      ).existsSync(),
      isTrue,
    );
  });
}
