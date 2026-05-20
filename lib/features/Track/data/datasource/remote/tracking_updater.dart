import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class TrackingUpdater {

  final FirebaseFirestore firestore;

  final FirebaseAuth auth;

  TrackingUpdater({
    required this.firestore,
    required this.auth,
  });

  Future<void> updateTracking({

    required String type,

    required double amount,

  }) async {

    final currentUser = auth.currentUser;

    if (currentUser == null) return;

    final docRef = firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('tracking')
        .doc(type.toLowerCase());

    final doc = await docRef.get();

    if (!doc.exists) return;

    final data = doc.data()!;

    final currentTotal =
    (data['totalAmount'] ?? 0).toDouble();

    final currentToday =
    (data['todayAmount'] ?? 0).toDouble();

    final currentMonthly =
    (data['monthlyAmount'] ?? 0).toDouble();

    final currentRecords =
        data['totalRecords'] ?? 0;

    final currentCycles =
        data['activeCycles'] ?? 0;

    /// SIMPLE PROGRESS

    double progress =
        (currentTotal + amount) / 10000;

    if (progress > 1) {
      progress = 1;
    }

    await docRef.update({

      "totalAmount":
      currentTotal + amount,

      "todayAmount":
      currentToday + amount,

      "monthlyAmount":
      currentMonthly + amount,

      "totalRecords":
      currentRecords + 1,

      "activeCycles":
      currentCycles + 1,

      "progressPercent":
      progress,

      "updatedAt":
      DateTime.now().toIso8601String(),
    });
  }
}