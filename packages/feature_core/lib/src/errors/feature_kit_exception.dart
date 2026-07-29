/// Base exception for Flutter Feature Kit operations.
class FeatureKitException implements Exception {
  FeatureKitException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() {
    if (cause == null) {
      return 'FeatureKitException: $message';
    }
    return 'FeatureKitException: $message ($cause)';
  }
}
