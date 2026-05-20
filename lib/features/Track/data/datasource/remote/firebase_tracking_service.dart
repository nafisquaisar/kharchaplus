import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/tracking_model.dart';

class FirebaseTrackingService {

  final FirebaseFirestore firestore;

  final FirebaseAuth auth;

  FirebaseTrackingService({
    required this.firestore,
    required this.auth,
  });

  /// ===============================
  /// GET ALL TRACKING DATA
  /// ===============================

  Stream<List<TrackingModel>> getTrackingData() {

    final currentUser = auth.currentUser;

    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    return firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('tracking')
        .snapshots()
        .map((snapshot) {

      final trackingList = snapshot.docs.map((doc) {

        final data = doc.data();

        return TrackingModel.fromMap(
          doc.id,
          data,
        );

      }).toList();

      /// SORT BY UPDATED TIME

      trackingList.sort(
            (a, b) => b.updatedAt.compareTo(a.updatedAt),
      );

      return trackingList;
    });
  }

  /// ===============================
  /// CREATE OR UPDATE TRACKING
  /// ===============================

  Future<void> saveTrackingData({
    required TrackingModel tracking,
  }) async {

    final currentUser = auth.currentUser;

    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    await firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('tracking')
        .doc(tracking.type.toLowerCase())
        .set(
      tracking.toMap(),
      SetOptions(merge: true),
    );
  }

  /// ===============================
  /// DELETE TRACKING MODULE
  /// ===============================

  Future<void> deleteTrackingModule({
    required String type,
  }) async {

    final currentUser = auth.currentUser;

    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    await firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('tracking')
        .doc(type.toLowerCase())
        .delete();
  }

  /// ===============================
  /// UPDATE TOTAL AMOUNT
  /// ===============================

  Future<void> updateTotalAmount({
    required String type,
    required double amount,
  }) async {

    final currentUser = auth.currentUser;

    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    final docRef = firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('tracking')
        .doc(type.toLowerCase());

    final doc = await docRef.get();

    if (!doc.exists) return;

    final currentAmount =
    (doc.data()?['totalAmount'] ?? 0).toDouble();

    await docRef.update({

      'totalAmount': currentAmount + amount,

      'updatedAt':
      DateTime.now().toIso8601String(),

    });
  }

  /// ===============================
  /// UPDATE TODAY AMOUNT
  /// ===============================

  Future<void> updateTodayAmount({
    required String type,
    required double amount,
  }) async {

    final currentUser = auth.currentUser;

    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    final docRef = firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('tracking')
        .doc(type.toLowerCase());

    final doc = await docRef.get();

    if (!doc.exists) return;

    final currentTodayAmount =
    (doc.data()?['todayAmount'] ?? 0).toDouble();

    await docRef.update({

      'todayAmount':
      currentTodayAmount + amount,

      'updatedAt':
      DateTime.now().toIso8601String(),

    });
  }

  /// ===============================
  /// UPDATE ACTIVE CYCLES
  /// ===============================

  Future<void> updateActiveCycles({
    required String type,
    required int cycle,
  }) async {

    final currentUser = auth.currentUser;

    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    await firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('tracking')
        .doc(type.toLowerCase())
        .update({

      'activeCycles': cycle,

      'updatedAt':
      DateTime.now().toIso8601String(),

    });
  }
}