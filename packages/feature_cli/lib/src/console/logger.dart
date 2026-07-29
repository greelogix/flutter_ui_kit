import 'dart:io';

class Logger {
  static bool verbose = false;

  static void step(String message) {
    stdout.writeln('✓ $message');
  }

  static void info(String message) {
    stdout.writeln(message);
  }

  static void title(String message) {
    stdout.writeln();
    stdout.writeln(message);
  }

  static void hint(String message) {
    stdout.writeln(message);
  }

  static void error(String message) {
    stderr.writeln('✗ $message');
  }

  static void warn(String message) {
    stdout.writeln('⚠ $message');
  }

  static void done() {
    stdout.writeln();
    stdout.writeln('Done 🚀');
  }
}
