import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class InitializeTrackingData {

  final FirebaseFirestore firestore;

  final FirebaseAuth auth;

  InitializeTrackingData({
    required this.firestore,
    required this.auth,
  });

  /// ==========================================
  /// CREATE DEFAULT TRACKING MODULES
  /// ==========================================

  Future<void> initialize() async {

    final currentUser = auth.currentUser;

    if (currentUser == null) {
      return;
    }

    final trackingRef = firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('tracking');

    final snapshot =
    await trackingRef.get();

    /// ==========================================
    /// ALREADY EXISTS
    /// ==========================================

    if (snapshot.docs.isNotEmpty) {
      return;
    }

    /// ==========================================
    /// DEFAULT MODULES
    /// ==========================================

    final now =
    DateTime.now().toIso8601String();

    final defaultModules = {

      "food": {

        "totalAmount": 0,

        "todayAmount": 0,

        "monthlyAmount": 0,

        "activeCycles": 0,

        "totalRecords": 0,

        "isActive": true,

        "progressPercent": 0.0,

        "status": "Active",

        "iconType": "food",

        "categoryColor": "#4CAF50",

        "createdAt": now,

        "updatedAt": now,
      },

      "water": {

        "totalAmount": 0,

        "todayAmount": 0,

        "monthlyAmount": 0,

        "activeCycles": 0,

        "totalRecords": 0,

        "isActive": true,

        "progressPercent": 0.0,

        "status": "Active",

        "iconType": "water",

        "categoryColor": "#2196F3",

        "createdAt": now,

        "updatedAt": now,
      },

      "electricity": {

        "totalAmount": 0,

        "todayAmount": 0,

        "monthlyAmount": 0,

        "activeCycles": 0,

        "totalRecords": 0,

        "isActive": true,

        "progressPercent": 0.0,

        "status": "Active",

        "iconType": "electricity",

        "categoryColor": "#FFC107",

        "createdAt": now,

        "updatedAt": now,
      },
    };

    /// ==========================================
    /// SAVE ALL MODULES
    /// ==========================================

    final batch = firestore.batch();

    defaultModules.forEach((docId, data) {

      final docRef =
      trackingRef.doc(docId);

      batch.set(docRef, data);
    });

    await batch.commit();
  }
}