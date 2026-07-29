# Flutter Feature Kit

**Bring your architecture. Flutter Feature Kit automates it.**

Universal Flutter feature scaffolding for teams using any architecture, state management, navigation, or dependency injection stack.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release notes. Current version: **0.2.0**.

## Monorepo

| Package | Description |
|---------|-------------|
| [`feature_cli`](packages/feature_cli) | `feature` CLI executable |
| [`feature_core`](packages/feature_core) | Configuration, templates, generation |
| [`feature_templates`](packages/feature_templates) | Built-in architecture templates |
| [`feature_analyzer`](packages/feature_analyzer) | Feature analysis (v0.4 roadmap) |

## Phase 2 (v0.2) — Available now

- **`feature add`** — add `screen`, `model`, `repository`, or `usecase` to an existing feature  
  `feature add screen login --feature auth`
- **Architecture artifact maps** — template-driven paths per architecture (Clean, MVVM, MVI, …)
- **Architecture registry** — discover built-in architectures from `feature_templates`
- **State adapters** — Riverpod, Bloc, Provider, GetX, MobX, **Redux**, **ValueNotifier**, none
- **Improved project detection** — MVC, MVI, Redux, ValueNotifier in `feature init`
- Barrel export refresh after `feature add` when exports are enabled

## Phase 1 (v0.1)

- `feature init` — detect project settings and write `featurekit.yaml`
- `feature create <name>` — generate a feature from architecture templates
- YAML configuration (`featurekit.yaml`)
- Built-in architectures: `feature_first`, `clean`, `mvvm`, `mvc`, `mvi`
- `feature doctor` — validate local setup

## Quick start

**Web demo (example app):**

```bash
cd examples/demo_flutter_app
flutter pub get
flutter run -d chrome
# or: flutter run -d web-server --web-port=8080  → http://127.0.0.1:8080
```

From the monorepo root (CLI):

```bash
dart pub get
dart run feature_cli:feature --help
```

In a Flutter app directory:

```bash
dart pub global activate --source path packages/feature_cli
cd examples/demo_flutter_app   # or your own app
feature init
feature create profile
feature add screen settings --feature profile
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

Optional per-architecture **`artifacts`** overrides in YAML for `feature add` paths.

## Roadmap

- **v0.3** — navigation/DI hooks, `feature generate exports`, `feature docs`
- **v0.4** — `feature analyze`, expanded `feature doctor`
- **v1.0** — pub.dev release, VS Code extension prep

## Development

```bash
dart pub get
dart test packages/
dart analyze packages/feature_core packages/feature_cli packages/feature_templates packages/feature_analyzer
```

### Pub score (pana)

```bash
dart pub global activate pana
dart pub global run pana packages/feature_core      # 160/160
dart pub global run pana packages/feature_templates # 160/160
```

The CLI package uses **path dependencies** in this monorepo (`130/160` until you publish `feature_core` / `feature_templates` and switch `feature_cli` to hosted `^0.2.0` constraints for pub.dev).

## Documentation

- [Getting started](docs/getting_started.md)

## License

MIT — see [LICENSE](LICENSE).
