# Getting started

## Install the CLI

From this repository:

```bash
dart pub global activate --source path packages/feature_cli
```

Ensure `~/.pub-cache/bin` is on your `PATH`.

## Initialize a Flutter project

```bash
cd your_flutter_app
feature init
```

This writes `featurekit.yaml` using heuristics from `pubspec.yaml` and `lib/`.

## Create a feature

```bash
feature create auth
```

The CLI prints progress steps and generates:

- Architecture folders/files under `paths.features`
- Optional tests under `test/`
- Barrel file `<feature>_feature.dart` when exports are enabled
- Feature doc `AUTH.md` when documentation is enabled

## Custom architecture

Create `featurekit_template.yaml`:

```yaml
name: company_architecture

folders:
  - api
  - models
  - services
  - controllers
  - screens
  - widgets
```

Set `project.architecture: custom` in `featurekit.yaml`, then run `feature create payment`.

## Add artifacts (v0.2)

```bash
feature add screen settings --feature profile
feature add model user --feature profile
feature add repository user --feature profile
feature add usecase load_profile --feature profile
```

Requires an existing feature folder under `paths.features`.

## Verify setup

```bash
feature doctor
```
