# Flutter Feature Kit

**Bring your architecture. Flutter Feature Kit automates it.**

Universal Flutter feature scaffolding for teams using any architecture, state management, navigation, or dependency injection stack.

## Monorepo

| Package | Description |
|---------|-------------|
| [`feature_cli`](packages/feature_cli) | `feature` CLI executable |
| [`feature_core`](packages/feature_core) | Configuration, templates, generation |
| [`feature_templates`](packages/feature_templates) | Built-in architecture templates |
| [`feature_analyzer`](packages/feature_analyzer) | Feature analysis (v0.4 roadmap) |

## Phase 1 (v0.1) — Available now

- `feature init` — detect project settings and write `featurekit.yaml`
- `feature create <name>` — generate a feature from architecture templates
- YAML configuration (`featurekit.yaml`)
- Template engine with built-in architectures:
  - `feature_first`, `clean`, `mvvm`, `mvc`, `mvi`
- State-management adapters (Riverpod, Bloc, Provider, GetX, MobX, none)
- `feature doctor` — validate local setup

## Quick start

From the monorepo root:

```bash
dart pub get
dart run feature_cli:feature --help
```

In a Flutter app directory:

```bash
dart pub global activate --source path packages/feature_cli
cd /path/to/your/flutter_app
feature init
feature create profile
```

Or without global activate:

```bash
dart run /path/to/flutter_feature_kit/packages/feature_cli:feature init
```

## Configuration

`featurekit.yaml`:

```yaml
project:
  architecture: clean
  state_management: riverpod
  navigation: go_router
  dependency_injection: get_it

paths:
  features: lib/features

generation:
  tests: true
  exports: true
  documentation: true
```

Custom folder layouts via `featurekit_template.yaml` (set `architecture: custom`).

## Roadmap

- **v0.2** — `feature add` commands, deeper adapter generation
- **v0.3** — navigation/DI hooks, `feature generate exports`, `feature docs`
- **v0.4** — `feature analyze`, expanded `feature doctor`
- **v1.0** — pub.dev release, examples, VS Code extension prep

## Development

```bash
dart pub get
dart test packages/feature_core
dart test packages/feature_cli
```

## License

MIT (add LICENSE file before publishing)
