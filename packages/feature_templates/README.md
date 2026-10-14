# flutter_feature_kit_templates

Built-in architecture YAML and Dart file templates for [Flutter Feature Kit](https://github.com/greelogix/flutter_ui_kit).

Architectures: `feature_first`, `clean`, `mvvm`, `mvc`, `mvi`, plus `_shared` Dart templates.

## Usage

```dart
import 'package:flutter_feature_kit_templates/flutter_feature_kit_templates.dart';

void main() {
  final paths = TemplatePaths();
  print(paths.builtinTemplatesRoot);
}
```

The bundle includes five architecture manifests and shared Dart templates.
It resolves from the installed package, including when used by a globally
activated CLI. Supply `TemplatePaths(root: '/your/templates')` or set
`FEATURE_KIT_TEMPLATES_ROOT` to use your own bundle.

## License

MIT

## Maintained By [#](https://pub.dev/packages/flutter_feature_kit_templates#maintained-by)

**GreeLogix** — Flutter, Laravel & AI Development Agency

GreeLogix is a senior software agency for startups, SMEs, nonprofits, and international teams who need AI products, custom web & mobile apps, Laravel & Flutter builds, and QA — delivered in weeks, not quarters.

🌐 [https://greelogix.com](https://greelogix.com)\
📩 [hello@greelogix.com](mailto:hello@greelogix.com)
