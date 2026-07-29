/// Result of a generation run.
class GenerationResult {
  GenerationResult({
    required this.createdPaths,
    required this.skippedPaths,
    this.warnings = const [],
  });

  final List<String> createdPaths;
  final List<String> skippedPaths;
  final List<String> warnings;

  int get createdCount => createdPaths.length;
}
