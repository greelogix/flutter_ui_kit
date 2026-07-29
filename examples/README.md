# Examples

## Demo Flutter app (all platforms + web)

```bash
cd examples/demo_flutter_app
flutter pub get
flutter run -d chrome
# or
flutter run -d web-server --web-port=8080
```

Install the CLI from the monorepo root:

```bash
dart pub global activate --source path packages/feature_cli
cd examples/demo_flutter_app
feature init
feature create profile
```

Platform folders (`android`, `ios`, `web`, `linux`, `macos`, `windows`) live under `demo_flutter_app/`.
