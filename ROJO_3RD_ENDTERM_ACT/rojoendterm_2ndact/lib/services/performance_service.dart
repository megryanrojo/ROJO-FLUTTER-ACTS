import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/performance_report.dart';

class PerformanceService {
  PerformanceService._();

  static final PerformanceService _instance = PerformanceService._();
  factory PerformanceService() => _instance;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<PerformanceReport> measure({int limit = 200}) async {
    final realtimeRef = _database.ref('inventory/items').limitToFirst(limit);
    final firestoreQuery = _firestore.collection('bookings').limit(limit);

    final realtimeWatch = Stopwatch()..start();
    final realtimeSnapshot = await realtimeRef.get();
    realtimeWatch.stop();

    final firestoreWatch = Stopwatch()..start();
    final firestoreSnapshot = await firestoreQuery.get();
    firestoreWatch.stop();

    final realtimeCount = realtimeSnapshot.children.length;
    final firestoreCount = firestoreSnapshot.docs.length;

    return PerformanceReport(
      realtimeDuration: realtimeWatch.elapsed,
      firestoreDuration: firestoreWatch.elapsed,
      realtimeCount: realtimeCount,
      firestoreCount: firestoreCount,
      generatedAt: DateTime.now(),
    );
  }
}


