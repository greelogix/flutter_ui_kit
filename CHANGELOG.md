# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-07-29

### Added

- **`feature add`** — `screen`, `model`, `repository`, and `usecase` subcommands with required `--feature` / `-f` flag.
- **Architecture artifact maps** — per-architecture paths for `feature add` via YAML `artifacts` and `DefaultArtifactPaths`.
- **`ArchitectureRegistry`** — template-based architecture adapter discovery.
- **State adapters** — full `ReduxAdapter` and `ValueNotifierAdapter` with templates and tests.
- **Deeper Riverpod hints** — optional generation comments when adding screens with Riverpod.
- **Project detection** — MVC, MVI, Redux, and ValueNotifier heuristics in `feature init`.
- **Shared templates** — `usecase.dart.template`, widget/repository test templates.
- **Package examples**, **LICENSE**, and pub.dev metadata across packages.

### Changed

- Screen/model/repository templates use `{{artifact_*}}` placeholders (compatible with `feature create` and `feature add`).
- Barrel exports refresh automatically after `feature add` when `generation.exports` is enabled.
- Package version bumped to **0.2.0**.
- Switched package linting to `package:lints/recommended.yaml` for pub.dev static analysis compatibility.
- Removed orphaned root Flutter `lib/main.dart` template.

## [0.1.0] - 2026-07-29

### Added

- Initial monorepo: `feature_cli`, `feature_core`, `feature_templates`, `feature_analyzer` (stub).
- **`feature init`**, **`feature create`**, **`feature doctor`**.
- YAML configuration (`featurekit.yaml`) and custom `featurekit_template.yaml`.
- Built-in architectures: `feature_first`, `clean`, `mvvm`, `mvc`, `mvi`.
- State management adapters: Riverpod, Bloc, Provider, GetX, MobX, none.
- Template engine, `dart_style` formatting, tests, barrel files, feature docs on create.

[0.2.0]: https://github.com/greelogix/flutter_feature_kit/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/greelogix/flutter_feature_kit/releases/tag/v0.1.0
