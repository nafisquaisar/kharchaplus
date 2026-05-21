import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../models/recent_activity_model.dart';

abstract class RecentActivityRemoteDataSource {

  Future<void> addActivity(
      RecentActivityModel activity,
      );

  Future<List<RecentActivityModel>>
  getRecentActivities(
      String userId,
      );

  Stream<List<RecentActivityModel>>
  watchRecentActivities(
      String userId,
      );

  Future<void> updateActivity(
      RecentActivityModel activity,
      );

  Future<void> deleteActivity(
      String referenceId,
      );

  Future<void> deleteActivityById(
      String id,
      );
}


class RecentActivityRemoteDataSourceImpl
    implements RecentActivityRemoteDataSource {
  final FirebaseFirestore firestore;

  final FirebaseAuth auth;

  RecentActivityRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  String? _currentUserId() {
    return auth.currentUser?.uid;
  }

  CollectionReference<Map<String, dynamic>> _collection(
    String userId,
  ) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('Home')
        .doc('recentActivity')
        .collection('activities');
  }

  // =====================================================
  // ADD
  // =====================================================

  @override
  Future<void> addActivity(
    RecentActivityModel activity,
  ) async {
    final userId = _currentUserId();

    if (userId == null) {
      debugPrint(
        'RecentActivityRemoteDataSource: no user for add',
      );

      return;
    }

    try {
      final updatedActivity = activity.copyWith(
        userId: userId,
      );

      await _collection(userId).doc(updatedActivity.id).set(
            updatedActivity.toJson(),
          );

      debugPrint(
        'RecentActivityRemoteDataSource: added ${updatedActivity.id}',
      );
    } catch (e, stack) {
      debugPrint(
        'RecentActivityRemoteDataSource: add failed $e',
      );

      debugPrint('$stack');

      rethrow;
    }
  }

  // =====================================================
  // GET
  // =====================================================

  @override
  Future<List<RecentActivityModel>>
  getRecentActivities(
      String userId,
      ) async {
      final userId = _currentUserId();

      if (userId == null) {
        debugPrint(
          'RecentActivityRemoteDataSource: no user for fetch',
        );

        return [];
      }

      try {
        final snapshot = await _collection(userId)
            .where(
              'userId',
              isEqualTo: userId,
            )
            .orderBy(
              'createdAt',
              descending: true,
            )
            .get();

        final result = snapshot.docs
            .map(
              (doc) => RecentActivityModel.fromJson(
                doc.data(),
              ),
            )
            .toList();

        debugPrint(
          'RecentActivityRemoteDataSource: fetched ${result.length} items',
        );

        return result;
      } catch (e, stack) {
        debugPrint(
          'RecentActivityRemoteDataSource: fetch failed $e',
        );

        debugPrint('$stack');

        rethrow;
      }
    }

  // =====================================================
  // WATCH
  // =====================================================

  @override
  Stream<List<RecentActivityModel>>
  watchRecentActivities(
      String userId,
      ) {
    final userId = _currentUserId();

    if (userId == null) {
      debugPrint(
        'RecentActivityRemoteDataSource: no user for watch',
      );

      return const Stream<List<RecentActivityModel>>.empty();
    }

    return _collection(userId)
        .where(
          'userId',
          isEqualTo: userId,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map(
              (doc) => RecentActivityModel.fromJson(
                doc.data(),
              ),
            )
            .toList();
      },
    );
  }

  // =====================================================
  // UPDATE
  // =====================================================

  @override
  Future<void> updateActivity(
    RecentActivityModel activity,
  ) async {
    final userId = _currentUserId();

    if (userId == null) {
      debugPrint(
        'RecentActivityRemoteDataSource: no user for update',
      );

      return;
    }

    try {
      final updatedActivity = activity.copyWith(
        userId: userId,
        updatedAt: DateTime.now(),
      );

      await _collection(userId).doc(updatedActivity.id).set(
            updatedActivity.toJson(),
            SetOptions(
              merge: true,
            ),
          );

      final snapshot = await _collection(userId)
          .where(
            'referenceId',
            isEqualTo: updatedActivity.referenceId,
          )
          .get();

      final duplicates = snapshot.docs
          .where(
            (doc) => doc.id != updatedActivity.id,
          )
          .toList();

      for (final doc in duplicates) {
        await doc.reference.delete();
      }

      if (duplicates.isNotEmpty) {
        debugPrint(
          'RecentActivityRemoteDataSource: deduped referenceId=${updatedActivity.referenceId} removed=${duplicates.length}',
        );
      }

      debugPrint(
        'RecentActivityRemoteDataSource: updated ${updatedActivity.id}',
      );
    } catch (e, stack) {
      debugPrint(
        'RecentActivityRemoteDataSource: update failed $e',
      );

      debugPrint('$stack');

      rethrow;
    }
  }

  // =====================================================
  // DELETE
  // =====================================================

  @override
  Future<void> deleteActivity(
    String referenceId,
  ) async {
    final userId = _currentUserId();

    if (userId == null) {
      debugPrint(
        'RecentActivityRemoteDataSource: no user for delete',
      );

      return;
    }

    try {
      final snapshot = await _collection(userId)
          .where(
            'referenceId',
            isEqualTo: referenceId,
          )
          .where(
            'userId',
            isEqualTo: userId,
          )
          .get();

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }

      debugPrint(
        'RecentActivityRemoteDataSource: deleted $referenceId',
      );
    } catch (e, stack) {
      debugPrint(
        'RecentActivityRemoteDataSource: delete failed $e',
      );

      debugPrint('$stack');

      rethrow;
    }
  }

  // =====================================================
  // DELETE BY ID
  // =====================================================

  @override
  Future<void> deleteActivityById(
    String id,
  ) async {
    final userId = _currentUserId();

    if (userId == null) {
      debugPrint(
        'RecentActivityRemoteDataSource: no user for delete by id',
      );

      return;
    }

    try {
      await _collection(userId).doc(id).delete();

      debugPrint(
        'RecentActivityRemoteDataSource: deleted id $id',
      );
    } catch (e, stack) {
      debugPrint(
        'RecentActivityRemoteDataSource: delete by id failed $e',
      );

      debugPrint('$stack');

      rethrow;
    }
  }
}
