import 'dart:io';

import 'package:flutter_feature_kit_cli/flutter_feature_kit_cli.dart';
import 'package:flutter_feature_kit_templates/flutter_feature_kit_templates.dart';
import 'package:test/test.dart';

void main() {
  late Directory project;
  late FeatureCommandRunner runner;
  setUp(() {
    project = Directory.systemTemp.createTempSync('ffk_cli_');
    File('${project.path}/pubspec.yaml').writeAsStringSync('name: demo\n');
    runner = FeatureCommandRunner(
      services: FeatureKitServices(
        projectRoot: project.path,
        templatePaths: TemplatePaths(),
      ),
    );
  });
  tearDown(() => project.deleteSync(recursive: true));

  test('init, create, add, and doctor operate on a project', () async {
    expect(await runner.run(['init']), 0);
    expect(await runner.run(['create', 'profile']), 0);
    expect(
      await runner.run(['add', 'model', 'account', '--feature', 'profile']),
      0,
    );
    expect(await runner.run(['doctor']), 0);
    expect(
      File(
        '${project.path}/lib/features/profile/screens/profile_screen.dart',
      ).existsSync(),
      isTrue,
    );
    expect(
      File(
        '${project.path}/lib/features/profile/models/account_model.dart',
      ).existsSync(),
      isTrue,
    );
    final barrel = File(
      '${project.path}/lib/features/profile/profile_feature.dart',
    ).readAsStringSync();
    expect(barrel, isNot(contains("export 'profile_feature.dart'")));
  });
  test(
    'rejects duplicates, invalid names, missing features, and malformed config',
    () async {
      expect(await runner.run(['create', 'profile']), 0);
      expect(await runner.run(['create', 'profile']), 1);
      expect(await runner.run(['create', '2bad']), 1);
      expect(
        await runner.run(['add', 'model', 'account', '--feature', 'missing']),
        1,
      );
      File('${project.path}/featurekit.yaml').writeAsStringSync('project: [');
      expect(await runner.run(['create', 'settings']), 1);
      expect(await runner.run(['doctor']), 1);
    },
  );
  test('returns usage status for missing arguments', () async {
    expect(await runner.run(['create']), 64);
    expect(await runner.run(['add', 'model', 'account']), 64);
  });
  test('planned commands report unavailability instead of success', () async {
    expect(await runner.run(['analyze']), 69);
    expect(await runner.run(['docs', 'profile']), 69);
    expect(await runner.run(['generate', 'exports']), 69);
  });
}
