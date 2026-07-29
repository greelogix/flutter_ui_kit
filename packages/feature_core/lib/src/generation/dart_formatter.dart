import 'package:dart_style/dart_style.dart';

/// Formats generated Dart source with [dart_style].
class DartSourceFormatter {
  DartSourceFormatter({DartFormatter? formatter})
    : _formatter =
          formatter ?? DartFormatter(languageVersion: _languageVersion);

  static final _languageVersion = DartFormatter.latestLanguageVersion;

  final DartFormatter _formatter;

  String format(String source) {
    try {
      return _formatter.format(source);
    } on FormatException {
      return source;
    }
  }
}
