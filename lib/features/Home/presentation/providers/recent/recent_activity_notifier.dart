import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/entities/RecentActivityEntity.dart';

import 'recent_activity_providers.dart';

class RecentActivityNotifier extends StateNotifier<
    AsyncValue<List<RecentActivityEntity>>> {

  final Ref ref;

  StreamSubscription<List<RecentActivityEntity>>?
  _localSubscription;

  StreamSubscription<List<RecentActivityEntity>>?
  _remoteSubscription;

  RecentActivityNotifier(
      this.ref,
      ) : super(
    const AsyncLoading(),
  ) {

    _bindLocalStream();

    _bindRemoteStream();

    _bootstrap();
  }

  String? get _userId =>
      FirebaseAuth.instance.currentUser?.uid;

  // =====================================================
  // LOCAL STREAM
  // =====================================================

  void _bindLocalStream() {

    final userId = _userId;

    if (userId == null) {
      return;
    }

    _localSubscription?.cancel();

    _localSubscription = ref
        .read(
      watchRecentActivitiesUseCaseProvider,
    )
        .call(userId)
        .listen(

          (activities) {

        state = AsyncData(
          activities,
        );
      },

      onError: (e, stack) {

        debugPrint(
          'RecentActivityNotifier: local stream error $e',
        );

        state = AsyncError(
          e,
          stack,
        );
      },
    );
  }

  // =====================================================
  // REMOTE STREAM
  // =====================================================

  void _bindRemoteStream() {

    final userId = _userId;

    if (userId == null) {
      return;
    }

    _remoteSubscription?.cancel();

    _remoteSubscription = ref
        .read(
      watchRemoteRecentActivitiesUseCaseProvider,
    )
        .call(userId)
        .listen(

          (_) {},

      onError: (e, stack) {

        debugPrint(
          'RecentActivityNotifier: remote stream error $e',
        );

        if (state is AsyncLoading) {

          state = AsyncError(
            e,
            stack,
          );
        }
      },
    );
  }

  // =====================================================
  // INITIAL SYNC
  // =====================================================

  Future<void> _bootstrap() async {

    final userId = _userId;

    if (userId == null) {
      return;
    }

    try {

      await ref
          .read(
        syncRecentActivitiesUseCaseProvider,
      )
          .call(userId);

    } catch (e, stack) {

      debugPrint(
        'RecentActivityNotifier: initial sync failed $e',
      );

      if (state is AsyncLoading) {

        state = AsyncError(
          e,
          stack,
        );
      }
    }
  }

  // =====================================================
  // LOAD
  // =====================================================

  Future<void> loadRecentActivities() async {

    final userId = _userId;

    if (userId == null) {
      return;
    }

    try {

      state = const AsyncLoading();

      final activities = await ref
          .read(
        getRecentActivitiesUseCaseProvider,
      )
          .call(userId);

      state = AsyncData(
        activities,
      );

    } catch (e, stack) {

      state = AsyncError(
        e,
        stack,
      );
    }
  }

  // =====================================================
  // ADD
  // =====================================================

  Future<void> addRecentActivity(
      RecentActivityEntity activity,
      ) async {

    try {

      await ref
          .read(
        addRecentActivityUseCaseProvider,
      )
          .call(activity);

    } catch (e, stack) {

      debugPrint(
        'RecentActivityNotifier: add failed $e',
      );

      state = AsyncError(
        e,
        stack,
      );
    }
  }

  // =====================================================
  // UPDATE
  // =====================================================

  Future<void> updateRecentActivity(
      RecentActivityEntity activity,
      ) async {

    final previous = state;

    state = state.whenData(

          (items) {

        return items
            .map(

              (item) =>
          item.referenceId ==
              activity.referenceId
              ? activity
              : item,
        )
            .toList();
      },
    );

    try {

      await ref
          .read(
        updateRecentActivityUseCaseProvider,
      )
          .call(activity);

    } catch (e) {

      debugPrint(
        'RecentActivityNotifier: update failed $e',
      );

      state = previous;
    }
  }

  // =====================================================
  // DELETE
  // =====================================================

  Future<void> deleteRecentActivity(
      String referenceId,
      String userId
      ) async {

    final previous = state;

    state = state.whenData(

          (items) {

        return items
            .where(

              (item) =>
          item.referenceId !=
              referenceId,
        )
            .toList();
      },
    );

    try {

      await ref
          .read(
        deleteRecentActivityUseCaseProvider,
      )
          .call(referenceId, userId);

    } catch (e) {

      debugPrint(
        'RecentActivityNotifier: delete failed $e',
      );

      state = previous;
    }
  }

  @override
  void dispose() {

    _localSubscription?.cancel();

    _remoteSubscription?.cancel();

    super.dispose();
  }
}