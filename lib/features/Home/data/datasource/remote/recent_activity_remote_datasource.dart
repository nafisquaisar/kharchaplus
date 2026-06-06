import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../models/recent_activity_model.dart';

abstract class RecentActivityRemoteDataSource {
  Future<void> addActivity(RecentActivityModel activity);

  Future<List<RecentActivityModel>> getRecentActivities();

  Stream<List<RecentActivityModel>> watchRecentActivities();

  Future<void> updateActivity(RecentActivityModel activity);

  Future<void> deleteActivity(String referenceId);

  Future<void> deleteActivityById(String id);
}

class RecentActivityRemoteDataSourceImpl
    implements RecentActivityRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  RecentActivityRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  String? _currentUserId() => auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _collection(String userId) {
    // Firestore path requirement: users/{userUID}/Home/recentActivity/{activityId}
    return firestore
        .collection('users')
        .doc(userId)
        .collection('Home')
        .doc('recentActivity')
        .collection('activities');
  }

  @override
  Future<void> addActivity(RecentActivityModel activity) async {
    final userId = _currentUserId();
    if (userId == null) {
      debugPrint('RecentActivityRemoteDataSource: no user for add');
      return;
    }

    try {
      debugPrint('RecentActivityRemoteDataSource: add type=${activity.type} id=${activity.id} referenceId=${activity.referenceId} parentCardId=${activity.parentCardId}');
      await _collection(userId)
          .doc(activity.id)
          .set(activity.toJson());
      debugPrint('RecentActivityRemoteDataSource: added ${activity.id}');
    } catch (e, stack) {
      debugPrint('RecentActivityRemoteDataSource: add failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Future<List<RecentActivityModel>> getRecentActivities() async {
    final userId = _currentUserId();
    if (userId == null) {
      debugPrint('RecentActivityRemoteDataSource: no user for fetch');
      return [];
    }

    try {
      final snapshot = await _collection(userId)
          .orderBy('createdAt', descending: true)
          .get();

      final result = snapshot.docs
          .map((doc) => RecentActivityModel.fromJson(doc.data()))
          .toList();

      debugPrint('RecentActivityRemoteDataSource: fetched ${result.length} items');
      for (final item in result) {
        debugPrint('RecentActivityRemoteDataSource: fetched item type=${item.type} id=${item.id} referenceId=${item.referenceId} parentCardId=${item.parentCardId}');
      }
      return result;
    } catch (e, stack) {
      debugPrint('RecentActivityRemoteDataSource: fetch failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Stream<List<RecentActivityModel>> watchRecentActivities() {
    final userId = _currentUserId();
    if (userId == null) {
      debugPrint('RecentActivityRemoteDataSource: no user for watch');
      return const Stream<List<RecentActivityModel>>.empty();
    }

    return _collection(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RecentActivityModel.fromJson(doc.data()))
          .toList();
    });
  }

  @override
  Future<void> updateActivity(RecentActivityModel activity) async {
    final userId = _currentUserId();
    if (userId == null) {
      debugPrint('RecentActivityRemoteDataSource: no user for update');
      return;
    }

    try {
      debugPrint('RecentActivityRemoteDataSource: update type=${activity.type} id=${activity.id} referenceId=${activity.referenceId} parentCardId=${activity.parentCardId}');
      await _collection(userId)
          .doc(activity.id)
          .set(activity.toJson(), SetOptions(merge: true));

      final snapshot = await _collection(userId)
          .where('referenceId', isEqualTo: activity.referenceId)
          .get();

      final duplicates = snapshot.docs
          .where((doc) => doc.id != activity.id)
          .toList();

      for (final doc in duplicates) {
        await doc.reference.delete();
      }

      if (duplicates.isNotEmpty) {
        debugPrint(
          'RecentActivityRemoteDataSource: deduped referenceId=${activity.referenceId} removed=${duplicates.length}',
        );
      }

      debugPrint('RecentActivityRemoteDataSource: updated ${activity.id}');
    } catch (e, stack) {
      debugPrint('RecentActivityRemoteDataSource: update failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Future<void> deleteActivity(String referenceId) async {
    final userId = _currentUserId();
    if (userId == null) {
      debugPrint('RecentActivityRemoteDataSource: no user for delete');
      return;
    }

    try {
      final snapshot = await _collection(userId)
          .where('referenceId', isEqualTo: referenceId)
          .get();

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }

      debugPrint('RecentActivityRemoteDataSource: deleted $referenceId');
    } catch (e, stack) {
      debugPrint('RecentActivityRemoteDataSource: delete failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Future<void> deleteActivityById(String id) async {
    final userId = _currentUserId();
    if (userId == null) {
      debugPrint('RecentActivityRemoteDataSource: no user for delete by id');
      return;
    }

    try {
      await _collection(userId).doc(id).delete();
      debugPrint('RecentActivityRemoteDataSource: deleted id $id');
    } catch (e, stack) {
      debugPrint('RecentActivityRemoteDataSource: delete by id failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }
}
