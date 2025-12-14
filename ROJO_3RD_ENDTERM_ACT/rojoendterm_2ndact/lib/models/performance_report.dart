class PerformanceReport {
  final Duration realtimeDuration;
  final Duration firestoreDuration;
  final int realtimeCount;
  final int firestoreCount;
  final DateTime generatedAt;

  const PerformanceReport({
    required this.realtimeDuration,
    required this.firestoreDuration,
    required this.realtimeCount,
    required this.firestoreCount,
    required this.generatedAt,
  });
}


