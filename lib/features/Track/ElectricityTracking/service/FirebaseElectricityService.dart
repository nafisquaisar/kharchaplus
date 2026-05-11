import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../data/models/electricity_model.dart';

class ElectricityPageResult {
  final List<ElectricityModel> items;
  final DocumentSnapshot<Map<String, dynamic>>? lastDocument;

  const ElectricityPageResult({
    required this.items,
    required this.lastDocument,
  });
}

class FirebaseElectricityService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FirebaseElectricityService({
    required this.firestore,
    required this.auth,
  });

  // =========================
  // HELPERS
  // =========================

  String get uid {
    final user = auth.currentUser;
    if (user == null) {
      debugPrint(
        '[FirebaseElectricityService] [AUTH ERROR] User not authenticated',
      );
      throw StateError('User not authenticated');
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get electricityRef =>
      firestore
          .collection('users')
          .doc(uid)
          .collection('electricity_cycles');

  String get _collectionPath => 'users/$uid/electricity_cycles';

  void _logFirebaseError(String action, FirebaseException e) {
    debugPrint('[FirebaseElectricityService] [$action ERROR] ${e.message}');
    debugPrint('[FirebaseElectricityService] [$action CODE] ${e.code}');
  }

  String _docId(ElectricityModel model) =>
      model.serverId?.trim().isNotEmpty == true
          ? model.serverId!
          : model.id;

  void _validateModel(ElectricityModel model) {
    if (model.id.trim().isEmpty) {
      throw ArgumentError('Electricity id is required');
    }
    if (model.startDate.isAfter(model.endDate)) {
      throw ArgumentError('Start date must be before end date');
    }
    if (model.prevUnit > model.currentUnit) {
      throw ArgumentError('Previous unit must be <= current unit');
    }
  }

  DateTime _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  Map<String, dynamic> _normalizeFirestoreMap(
    Map<String, dynamic> data,
    String docId,
  ) {
    final map = Map<String, dynamic>.from(data);

    map['id'] ??= docId;
    map['serverId'] ??= docId;
    map['userId'] ??= uid;

    map['startDate'] = _parseDate(map['startDate']).toIso8601String();
    map['endDate'] = _parseDate(map['endDate']).toIso8601String();
    map['createdAt'] = _parseDate(map['createdAt']).toIso8601String();
    map['updatedAt'] = _parseDate(map['updatedAt']).toIso8601String();

    return map;
  }

  Map<String, dynamic> _toFirestoreMap(
    ElectricityModel model, {
    required bool includeCreatedAt,
    bool isEdited = false,
  }) {
    final data = Map<String, dynamic>.from(model.toJson());

    data['id'] = model.id;
    data['serverId'] = _docId(model);
    data['userId'] = uid;

    data['startDate'] = Timestamp.fromDate(model.startDate);
    data['endDate'] = Timestamp.fromDate(model.endDate);

    if (includeCreatedAt) {
      data['createdAt'] = FieldValue.serverTimestamp();
    } else {
      data.remove('createdAt');
    }

    data['updatedAt'] = FieldValue.serverTimestamp();
    data['isEdited'] = isEdited || model.isEdited;
    data['isDeleted'] = model.isDeleted;

    return data;
  }

  ElectricityModel _fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Missing electricity document data');
    }
    final normalized = _normalizeFirestoreMap(data, doc.id);
    return ElectricityModel.fromJson(normalized);
  }

  // =========================
  // CREATE
  // =========================

  Future<void> addElectricity(ElectricityModel model) async {
    _validateModel(model);

    final docId = _docId(model);
    final payload = _toFirestoreMap(
      model,
      includeCreatedAt: true,
      isEdited: false,
    );
    payload['isDeleted'] = false;

    try {
      debugPrint('[FIREBASE UPLOAD START] $docId');
      debugPrint('[FirebaseElectricityService] [ADD] $docId');
      debugPrint('[FirebaseElectricityService] [UID] $uid');
      debugPrint('[FirebaseElectricityService] [PATH] $_collectionPath');
      debugPrint('[FirebaseElectricityService] [PAYLOAD KEYS] ${payload.keys}');
      await electricityRef.doc(docId).set(
            payload,
            SetOptions(merge: true),
          );
      debugPrint('[FIREBASE UPLOAD SUCCESS] $docId');
      debugPrint('[FirebaseElectricityService] [ADD SUCCESS] $docId');
    } on FirebaseException catch (e) {
      _logFirebaseError('ADD', e);
      rethrow;
    } catch (e) {
      debugPrint('[FirebaseElectricityService] [ADD ERROR] $e');
      rethrow;
    }
  }

  // =========================
  // UPDATE
  // =========================

  Future<void> updateElectricity(ElectricityModel model) async {
    _validateModel(model);

    final docId = _docId(model);
    final payload = _toFirestoreMap(
      model,
      includeCreatedAt: false,
      isEdited: true,
    );
    payload['version'] = model.version + 1;

    try {
      debugPrint('[FIREBASE UPDATE START] $docId');
      debugPrint('[FirebaseElectricityService] [UPDATE] $docId');
      debugPrint('[FirebaseElectricityService] [PATH] $_collectionPath');
      debugPrint('[FirebaseElectricityService] [PAYLOAD KEYS] ${payload.keys}');
      await electricityRef.doc(docId).update(payload);
      debugPrint('[FIREBASE UPDATE SUCCESS] $docId');
      debugPrint('[FirebaseElectricityService] [UPDATE SUCCESS] $docId');
    } on FirebaseException catch (e) {
      _logFirebaseError('UPDATE', e);
      rethrow;
    } catch (e) {
      debugPrint('[FirebaseElectricityService] [UPDATE ERROR] $e');
      rethrow;
    }
  }

  // =========================
  // SOFT DELETE
  // =========================

  Future<void> softDeleteElectricity(String id) async {
    if (id.trim().isEmpty) {
      throw ArgumentError('Electricity id is required');
    }

    try {
      debugPrint('[FIREBASE DELETE START] $id');
      debugPrint('[FirebaseElectricityService] [DELETE] $id');
      debugPrint('[FirebaseElectricityService] [PATH] $_collectionPath');
      await electricityRef.doc(id).update({
        'isDeleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('[FIREBASE DELETE SUCCESS] $id');
      debugPrint('[FirebaseElectricityService] [DELETE SUCCESS] $id');
    } on FirebaseException catch (e) {
      _logFirebaseError('DELETE', e);
      rethrow;
    } catch (e) {
      debugPrint('[FirebaseElectricityService] [DELETE ERROR] $e');
      rethrow;
    }
  }

  // =========================
  // FETCH LIST
  // =========================

  Future<List<ElectricityModel>> getElectricityList({
    int limit = 50,
    bool descending = true,
  }) async {
    try {
      debugPrint('[FirebaseElectricityService] [FETCH] limit=$limit');
      debugPrint('[FirebaseElectricityService] [PATH] $_collectionPath');
      final snapshot = await electricityRef
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt', descending: descending)
          .limit(limit)
          .get();

      final items = snapshot.docs.map(_fromSnapshot).toList();
      debugPrint('[FirebaseElectricityService] [FETCH SUCCESS] ${items.length}');
      return items;
    } on FirebaseException catch (e) {
      _logFirebaseError('FETCH', e);
      rethrow;
    } catch (e) {
      debugPrint('[FirebaseElectricityService] [FETCH ERROR] $e');
      rethrow;
    }
  }

  // =========================
  // STREAM LIST
  // =========================

  Stream<List<ElectricityModel>> streamElectricityList({
    int limit = 50,
    bool descending = true,
  }) {
    debugPrint('[FirebaseElectricityService] [STREAM] limit=$limit');
    debugPrint('[FirebaseElectricityService] [PATH] $_collectionPath');
    return electricityRef
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: descending)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          debugPrint(
            '[FirebaseElectricityService] [STREAM UPDATE] ${snapshot.docs.length}',
          );
          return snapshot.docs.map(_fromSnapshot).toList();
        });
  }

  // =========================
  // SEARCH
  // =========================

  Future<List<ElectricityModel>> searchElectricity(
    String query, {
    int limit = 50,
  }) async {
    final searchText = query.trim();
    if (searchText.isEmpty) {
      return [];
    }

    try {
      debugPrint('[FirebaseElectricityService] [SEARCH] $searchText');
      debugPrint('[FirebaseElectricityService] [PATH] $_collectionPath');
      final snapshot = await electricityRef
          .where('isDeleted', isEqualTo: false)
          .orderBy('title')
          .startAt([searchText])
          .endAt(['$searchText\uf8ff'])
          .limit(limit)
          .get();

      final items = snapshot.docs.map(_fromSnapshot).toList();
      debugPrint('[FirebaseElectricityService] [SEARCH SUCCESS] ${items.length}');
      return items;
    } on FirebaseException catch (e) {
      _logFirebaseError('SEARCH', e);
      rethrow;
    } catch (e) {
      debugPrint('[FirebaseElectricityService] [SEARCH ERROR] $e');
      rethrow;
    }
  }

  // =========================
  // PAGINATION
  // =========================

  Future<ElectricityPageResult> getPaginatedElectricity({
    DocumentSnapshot<Map<String, dynamic>>? lastDocument,
    int limit = 20,
    bool descending = true,
  }) async {
    try {
      debugPrint('[FirebaseElectricityService] [PAGINATION] limit=$limit');
      Query<Map<String, dynamic>> query = electricityRef
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt', descending: descending)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();
      final items = snapshot.docs.map(_fromSnapshot).toList();
      final last = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      debugPrint('[FirebaseElectricityService] [PAGINATION SUCCESS] ${items.length}');
      return ElectricityPageResult(
        items: items,
        lastDocument: last,
      );
    } on FirebaseException catch (e) {
      _logFirebaseError('PAGINATION', e);
      rethrow;
    } catch (e) {
      debugPrint('[FirebaseElectricityService] [PAGINATION ERROR] $e');
      rethrow;
    }
  }
}