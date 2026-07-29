import 'artifact_definition.dart';

/// Default artifact paths when an architecture YAML omits an `artifacts` block.
class DefaultArtifactPaths {
  const DefaultArtifactPaths._();

  static Map<String, ArtifactDefinition> forArchitectureId(String id) {
    switch (id) {
      case 'clean':
        return _clean;
      case 'mvvm':
        return _mvvm;
      case 'mvc':
        return _mvc;
      case 'mvi':
        return _mvi;
      case 'feature_first':
      default:
        return _featureFirst;
    }
  }

  static const _featureFirst = {
    'screen': ArtifactDefinition(
      relativePath: 'screens/{{artifact_snake}}_screen.dart',
      templateName: 'screen.dart.template',
      testTemplateName: 'widget_test.dart.template',
    ),
    'model': ArtifactDefinition(
      relativePath: 'models/{{artifact_snake}}_model.dart',
      templateName: 'model.dart.template',
    ),
    'repository': ArtifactDefinition(
      relativePath: 'repositories/{{artifact_snake}}_repository.dart',
      templateName: 'repository.dart.template',
      testTemplateName: 'repository_test.dart.template',
    ),
    'usecase': ArtifactDefinition(
      relativePath: 'usecases/{{artifact_snake}}_usecase.dart',
      templateName: 'usecase.dart.template',
    ),
  };

  static const _clean = {
    'screen': ArtifactDefinition(
      relativePath: 'presentation/screens/{{artifact_snake}}_screen.dart',
      templateName: 'screen.dart.template',
      testTemplateName: 'widget_test.dart.template',
    ),
    'model': ArtifactDefinition(
      relativePath: 'domain/{{artifact_snake}}_entity.dart',
      templateName: 'entity.dart.template',
    ),
    'repository': ArtifactDefinition(
      relativePath: 'data/{{artifact_snake}}_repository.dart',
      templateName: 'repository.dart.template',
      testTemplateName: 'repository_test.dart.template',
    ),
    'usecase': ArtifactDefinition(
      relativePath: 'domain/{{artifact_snake}}_usecase.dart',
      templateName: 'usecase.dart.template',
    ),
  };

  static const _mvvm = {
    'screen': ArtifactDefinition(
      relativePath: 'views/{{artifact_snake}}_view.dart',
      templateName: 'screen.dart.template',
      testTemplateName: 'widget_test.dart.template',
    ),
    'model': ArtifactDefinition(
      relativePath: 'models/{{artifact_snake}}_model.dart',
      templateName: 'model.dart.template',
    ),
    'repository': ArtifactDefinition(
      relativePath: 'models/{{artifact_snake}}_repository.dart',
      templateName: 'repository.dart.template',
      testTemplateName: 'repository_test.dart.template',
    ),
    'usecase': ArtifactDefinition(
      relativePath: 'viewmodels/{{artifact_snake}}_viewmodel.dart',
      templateName: 'viewmodel.dart.template',
    ),
  };

  static const _mvc = {
    'screen': ArtifactDefinition(
      relativePath: 'views/{{artifact_snake}}_view.dart',
      templateName: 'screen.dart.template',
      testTemplateName: 'widget_test.dart.template',
    ),
    'model': ArtifactDefinition(
      relativePath: 'models/{{artifact_snake}}_model.dart',
      templateName: 'model.dart.template',
    ),
    'repository': ArtifactDefinition(
      relativePath: 'models/{{artifact_snake}}_repository.dart',
      templateName: 'repository.dart.template',
      testTemplateName: 'repository_test.dart.template',
    ),
    'usecase': ArtifactDefinition(
      relativePath: 'controllers/{{artifact_snake}}_controller.dart',
      templateName: 'mvc_controller.dart.template',
    ),
  };

  static const _mvi = {
    'screen': ArtifactDefinition(
      relativePath: 'view/{{artifact_snake}}_page.dart',
      templateName: 'screen.dart.template',
      testTemplateName: 'widget_test.dart.template',
    ),
    'model': ArtifactDefinition(
      relativePath: 'state/{{artifact_snake}}_state.dart',
      templateName: 'mvi_state.dart.template',
    ),
    'repository': ArtifactDefinition(
      relativePath: 'reducer/{{artifact_snake}}_reducer.dart',
      templateName: 'mvi_reducer.dart.template',
    ),
    'usecase': ArtifactDefinition(
      relativePath: 'intent/{{artifact_snake}}_intent.dart',
      templateName: 'mvi_intent.dart.template',
    ),
  };
}
