# flutter_feature_kit_cli

Command-line tool for [Flutter Feature Kit](https://github.com/greelogix/flutter_ui_kit).

## Install

```bash
dart pub global activate flutter_feature_kit_cli
```

## Commands (v0.2)

- `feature init`
- `feature create <name>`
- `feature add screen|model|repository|usecase <name> --feature <feature>`
- `feature doctor`

The CLI requires Dart 3.12 or later. Run commands from your Flutter project root.
`feature create` and `feature add` generate files using `featurekit.yaml`; duplicate
features or artifacts are rejected without overwriting them. Enable tests, exports,
and documentation in the configuration to generate those with new features.

`feature analyze`, `feature docs`, and `feature generate exports` remain planned
commands. They report that they are unavailable and exit with code 69. They do
not currently perform analysis, regenerate documentation, or refresh exports.

## Library usage

```dart
import 'package:flutter_feature_kit_cli/flutter_feature_kit_cli.dart';

Future<void> main() async {
  final result = await FeatureCommandRunner().run(['doctor']);
  print('Exit status: $result');
}
```

## License

MIT

## Maintained By [#](https://pub.dev/packages/flutter_feature_kit_cli#maintained-by)

**GreeLogix** — Flutter, Laravel & AI Development Agency

GreeLogix is a senior software agency for startups, SMEs, nonprofits, and international teams who need AI products, custom web & mobile apps, Laravel & Flutter builds, and QA — delivered in weeks, not quarters.

🌐 [https://greelogix.com](https://greelogix.com)\
📩 [hello@greelogix.com](mailto:hello@greelogix.com)
