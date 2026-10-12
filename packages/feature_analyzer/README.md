# flutter_feature_kit_analyzer

Analyzer availability API for Flutter Feature Kit, maintained in the
[Flutter UI Kit monorepo](https://github.com/greelogix/flutter_ui_kit/tree/main/packages/feature_analyzer).

**This package is currently a placeholder.** `FeatureAnalyzer.isImplemented`
returns `false`; no project inspection or diagnostics are implemented yet.
The Feature Kit CLI also treats feature analysis as a planned capability.

## Install

Requires Dart 3.12 or later.

```yaml
dependencies:
  flutter_feature_kit_analyzer: ^0.2.1
```

## Example

```dart
import 'package:flutter_feature_kit_analyzer/flutter_feature_kit_analyzer.dart';

void main() {
  const analyzer = FeatureAnalyzer();
  print(analyzer.isImplemented); // false
}
```

Run the complete example from this package directory:

```sh
dart run example/flutter_feature_kit_analyzer_example.dart
```

## Development

From the monorepo root:

```sh
dart pub get
dart analyze packages/feature_analyzer
dart test packages/feature_analyzer/test
```

## Maintainer

Published by [Greelogix](https://pub.dev/publishers/greelogix.com/packages).
Maintained by [Bilal Imran (@bilalatgreelogix)](https://github.com/bilalatgreelogix),
[bilal.imran@greelogix.com](mailto:bilal.imran@greelogix.com).
Report issues in the [repository issue tracker](https://github.com/greelogix/flutter_ui_kit/issues).

## License

MIT. See LICENSE.
