import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../models/tracking_model.dart';

class TrackingUpdater {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  TrackingUpdater({
    required this.firestore,
    required this.auth,
  });

  CollectionReference<Map<String, dynamic>> _trackingRef(String uid) {
    return firestore.collection('users').doc(uid).collection('tracking');
  }

  String _normalizeType(String type) {
    return type.toLowerCase().trim();
  }

  Map<String, dynamic> _defaultTrackingMap(String type) {
    return TrackingModel.zero(type).toMap();
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

  int _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  Future<void> ensureTrackingModules() async {
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      return;
    }

    final uid = currentUser.uid;
    final collection = _trackingRef(uid);
    final snapshot = await collection.get();
    final existing = snapshot.docs.map((doc) => doc.id.toLowerCase()).toSet();

    final batch = firestore.batch();
    var hasWrites = false;

    for (final type in TrackingModel.supportedTypes) {
      if (!existing.contains(type)) {
        hasWrites = true;
        batch.set(
          collection.doc(type),
          _defaultTrackingMap(type),
          SetOptions(merge: true),
        );
      }
    }

    if (hasWrites) {
      await batch.commit();
      debugPrint('[TrackingUpdater] initialized tracking docs for uid=$uid');
    }
  }

  Future<void> updateTracking({
    required String type,
    required double amount,
  }) async {
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      return;
    }

    final normalizedType = _normalizeType(type);
    final docRef = _trackingRef(currentUser.uid).doc(normalizedType);

    await firestore.runTransaction((transaction) async {
      final snap = await transaction.get(docRef);
      final data = snap.exists
          ? Map<String, dynamic>.from(snap.data()!)
          : _defaultTrackingMap(normalizedType);

      final totalAmount = _asDouble(data['totalAmount']) + amount;
      final todayAmount = _asDouble(data['todayAmount']) + amount;
      final monthlyAmount = _asDouble(data['monthlyAmount']) + amount;
      final totalRecords = _asInt(data['totalRecords']) + 1;
      final activeCycles = max(_asInt(data['activeCycles']), 1);

      var progress = totalAmount / 10000;
      if (progress < 0) {
        progress = 0;
      } else if (progress > 1) {
        progress = 1;
      }

      transaction.set(
        docRef,
        <String, dynamic>{
          ..._defaultTrackingMap(normalizedType),
          ...data,
          'totalAmount': totalAmount,
          'todayAmount': todayAmount,
          'monthlyAmount': monthlyAmount,
          'totalRecords': totalRecords,
          'activeCycles': activeCycles,
          'progressPercent': progress,
          'isActive': true,
          'status': 'Active',
          'updatedAt': Timestamp.now(),
        },
        SetOptions(merge: true),
      );
    });

    debugPrint(
      '[TrackingUpdater] incremented type=$normalizedType amount=$amount',
    );
  }

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
      return;
    }

    final normalizedType = _normalizeType(type);
    final docRef = _trackingRef(currentUser.uid).doc(normalizedType);
    final existing = await docRef.get();
    final data = existing.exists
        ? Map<String, dynamic>.from(existing.data()!)
        : _defaultTrackingMap(normalizedType);

    var progress = totalAmount / 10000;
    if (progress < 0) {
      progress = 0;
    } else if (progress > 1) {
      progress = 1;
    }

    await docRef.set(
      <String, dynamic>{
        ..._defaultTrackingMap(normalizedType),
        ...data,
        'totalAmount': totalAmount,
        'todayAmount': todayAmount,
        'monthlyAmount': monthlyAmount,
        'activeCycles': activeCycles < 0 ? 0 : activeCycles,
        'totalRecords': totalRecords < 0 ? 0 : totalRecords,
        'progressPercent': progress,
        'isActive': true,
        'status': 'Active',
        'updatedAt': Timestamp.now(),
      },
      SetOptions(merge: true),
    );

    debugPrint(
      '[TrackingUpdater] snapshot synced type=$normalizedType total=$totalAmount records=$totalRecords',
    );
  }
}
