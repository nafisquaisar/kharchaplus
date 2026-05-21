import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../models/tracking_model.dart';

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

    final snapshot = await trackingRef.get();
    final existingIds =
        snapshot.docs.map((doc) => doc.id.toLowerCase()).toSet();

    final missingTypes = TrackingModel.supportedTypes
        .where((type) => !existingIds.contains(type))
        .toList(growable: false);

    if (missingTypes.isEmpty) {
      return;
    }

    final batch = firestore.batch();
    final now = DateTime.now();

    for (final type in missingTypes) {
      batch.set(
        trackingRef.doc(type),
        TrackingModel.zero(type, now: now).toMap(),
        SetOptions(merge: true),
      );
    }

    await batch.commit();

    debugPrint(
      '[TrackingInit] initialized missing modules for ${currentUser.uid}: $missingTypes',
    );
  }
}
