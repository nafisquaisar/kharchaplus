import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../models/tracking_model.dart';

class FirebaseTrackingService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FirebaseTrackingService({
    required this.firestore,
    required this.auth,
  });

  CollectionReference<Map<String, dynamic>> _trackingRef(String uid) {
    return firestore.collection('users').doc(uid).collection('tracking');
  }

  String _normalizeType(String type) {
    return type.toLowerCase().trim();
  }

  Map<String, dynamic> _defaultTrackingMap(
    String type, {
    DateTime? now,
  }) {
    return TrackingModel.zero(type, now: now).toMap();
  }

  double _asDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }

  /// ===============================
  /// GET ALL TRACKING DATA (REALTIME)
  /// ===============================

  Stream<List<TrackingModel>> getTrackingData() {
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      return Stream<List<TrackingModel>>.value(
        TrackingModel.mergeWithDefaults(const <TrackingModel>[]),
      );
    }

    final uid = currentUser.uid;

    return _trackingRef(uid)
        .snapshots(includeMetadataChanges: true)
        .map((snapshot) {
      debugPrint(
        '[TrackingStream] uid=$uid docs=${snapshot.docs.length} cache=${snapshot.metadata.isFromCache}',
      );

      final trackingList = snapshot.docs.map((doc) {
        final data = doc.data();
        return TrackingModel.fromMap(doc.id, data);
      }).toList(growable: false);

      return TrackingModel.mergeWithDefaults(trackingList);
    }).handleError((error, stackTrace) {
      debugPrint('[TrackingStream] error: $error');
      debugPrint('$stackTrace');
    });
  }

  /// ===============================
  /// ENSURE DEFAULT MODULE DOCS
  /// ===============================

  Future<void> ensureDefaultTrackingModules() async {
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      return;
    }

    final uid = currentUser.uid;
    final collection = _trackingRef(uid);
    final snapshot = await collection.get();
    final existingTypes =
        snapshot.docs.map((doc) => doc.id.toLowerCase()).toSet();
    final now = DateTime.now();

    final batch = firestore.batch();
    var hasWrites = false;

    for (final type in TrackingModel.supportedTypes) {
      if (!existingTypes.contains(type)) {
        hasWrites = true;
        batch.set(
          collection.doc(type),
          _defaultTrackingMap(type, now: now),
          SetOptions(merge: true),
        );
      }
    }

    if (hasWrites) {
      await batch.commit();
      debugPrint('[TrackingInit] missing module docs created for uid=$uid');
    }
  }

  /// ===============================
  /// CREATE OR UPDATE TRACKING
  /// ===============================

  Future<void> saveTrackingData({
    required TrackingModel tracking,
  }) async {
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not logged in');
    }

    final type = _normalizeType(tracking.type);
    final docRef = _trackingRef(currentUser.uid).doc(type);
    final existing = await docRef.get();

    final payload = <String, dynamic>{
      ..._defaultTrackingMap(type, now: tracking.createdAt),
      ...tracking.toMap(),
      'createdAt': existing.data()?['createdAt'] ??
          Timestamp.fromDate(tracking.createdAt),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };

    await docRef.set(
      payload,
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
      throw Exception('User not logged in');
    }

    await _trackingRef(currentUser.uid).doc(_normalizeType(type)).delete();
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
      throw Exception('User not logged in');
    }

    final normalizedType = _normalizeType(type);
    final docRef = _trackingRef(currentUser.uid).doc(normalizedType);

    await firestore.runTransaction((transaction) async {
      final snap = await transaction.get(docRef);
      final data = snap.exists
          ? Map<String, dynamic>.from(snap.data()!)
          : _defaultTrackingMap(normalizedType);

      final updatedTotal = _asDouble(data['totalAmount']) + amount;

      transaction.set(
        docRef,
        <String, dynamic>{
          ..._defaultTrackingMap(normalizedType),
          ...data,
          'totalAmount': updatedTotal,
          'updatedAt': Timestamp.now(),
        },
        SetOptions(merge: true),
      );
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
      throw Exception('User not logged in');
    }

    final normalizedType = _normalizeType(type);
    final docRef = _trackingRef(currentUser.uid).doc(normalizedType);

    await firestore.runTransaction((transaction) async {
      final snap = await transaction.get(docRef);
      final data = snap.exists
          ? Map<String, dynamic>.from(snap.data()!)
          : _defaultTrackingMap(normalizedType);

      final updatedToday = _asDouble(data['todayAmount']) + amount;

      transaction.set(
        docRef,
        <String, dynamic>{
          ..._defaultTrackingMap(normalizedType),
          ...data,
          'todayAmount': updatedToday,
          'updatedAt': Timestamp.now(),
        },
        SetOptions(merge: true),
      );
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
      throw Exception('User not logged in');
    }

    final normalizedType = _normalizeType(type);
    final docRef = _trackingRef(currentUser.uid).doc(normalizedType);

    await firestore.runTransaction((transaction) async {
      final snap = await transaction.get(docRef);
      final data = snap.exists
          ? Map<String, dynamic>.from(snap.data()!)
          : _defaultTrackingMap(normalizedType);

      transaction.set(
        docRef,
        <String, dynamic>{
          ..._defaultTrackingMap(normalizedType),
          ...data,
          'activeCycles': cycle,
          'updatedAt': Timestamp.now(),
        },
        SetOptions(merge: true),
      );
    });
  }

  /// ===============================
  /// UPSERT FULL TRACKING SNAPSHOT
  /// ===============================

  Future<void> upsertTrackingSnapshot({
    required String type,
    required double totalAmount,
    required double todayAmount,
    required double monthlyAmount,
    required int activeCycles,
    required int totalRecords,
  }) async {
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not logged in');
    }

    final normalizedType = _normalizeType(type);
    final docRef = _trackingRef(currentUser.uid).doc(normalizedType);
    final existing = await docRef.get();
    final base = existing.data() ?? _defaultTrackingMap(normalizedType);

    double progress = totalAmount / 10000;
    if (progress < 0) {
      progress = 0;
    } else if (progress > 1) {
      progress = 1;
    }

    await docRef.set(
      <String, dynamic>{
        ..._defaultTrackingMap(normalizedType),
        ...base,
        'totalAmount': totalAmount,
        'todayAmount': todayAmount,
        'monthlyAmount': monthlyAmount,
        'activeCycles': activeCycles,
        'totalRecords': totalRecords,
        'progressPercent': progress,
        'isActive': true,
        'status': 'Active',
        'updatedAt': Timestamp.now(),
      },
      SetOptions(merge: true),
    );
  }
}
