import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/auth_service.dart';
import '../data/datasource/local/isar/water_goal_local_ds.dart';
import '../data/datasource/local/isar/water_intake_local_ds.dart';
import '../data/datasource/local/isar/water_purchase_local_ds.dart';
import '../data/datasource/local/isar/water_reminder_local_ds.dart';
import '../data/datasource/remote/firebase_water_remote_ds.dart';
import '../data/models/water_goal_model.dart';
import '../data/models/water_intake_model.dart';
import '../data/models/water_purchase_model.dart';
import '../data/models/water_reminder_model.dart';

class WaterSyncReport {
  final bool skipped;
  final int uploaded;
  final int downloaded;
  final String? reason;

  const WaterSyncReport({
    required this.skipped,
    required this.uploaded,
    required this.downloaded,
    this.reason,
  });
}

class WaterSyncService {
  WaterSyncService({
    required this.remoteDataSource,
    required this.intakeLocalDataSource,
    required this.purchaseLocalDataSource,
    required this.goalLocalDataSource,
    required this.reminderLocalDataSource,
    required this.authService,
    required this.connectivity,
  });

  final FirebaseWaterRemoteDataSource remoteDataSource;
  final WaterIntakeLocalDataSource intakeLocalDataSource;
  final WaterPurchaseLocalDataSource purchaseLocalDataSource;
  final WaterGoalLocalDataSource goalLocalDataSource;
  final WaterReminderLocalDataSource reminderLocalDataSource;
  final AuthService authService;
  final Connectivity connectivity;

  static const _lastSyncKey = 'water_last_sync_at';

  Future<void> ensureAnonymousUser() async {
    await authService.getCurrentUserId();
  }

  Future<bool> hasConnection() async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<WaterSyncReport> syncAll({
    void Function(double progress)? onProgress,
  }) async {
    if (!await hasConnection()) {
      return const WaterSyncReport(
        skipped: true,
        uploaded: 0,
        downloaded: 0,
        reason: 'offline',
      );
    }

    await ensureAnonymousUser();

    final lastSync = await _getLastSyncTime();
    final remote = await remoteDataSource.pullRemoteData(
      updatedAfter: lastSync,
    );

    final pendingIntakes = await intakeLocalDataSource.getPendingSync();
    final pendingPurchases = await purchaseLocalDataSource.getPendingSync();
    final pendingGoals = await goalLocalDataSource.getPendingSync();
    final pendingReminders = await reminderLocalDataSource.getPendingSync();

    final totalSteps = _countSteps(
      pendingIntakes.length +
          pendingPurchases.length +
          pendingGoals.length +
          pendingReminders.length,
      remote.intakes.length +
          remote.purchases.length +
          remote.goals.length +
          remote.reminders.length,
    );
    var completedSteps = 0;

    final uploadIntakes =
        _resolveUploads(pendingIntakes, remote.intakes);
    final uploadPurchases =
        _resolveUploads(pendingPurchases, remote.purchases);
    final uploadGoals = _resolveUploads(pendingGoals, remote.goals);
    final uploadReminders =
        _resolveUploads(pendingReminders, remote.reminders);

    await remoteDataSource.syncIntakes(uploadIntakes.toUpload);
    await _markSynced(
      uploadIntakes.toUpload,
      intakeLocalDataSource.markSynced,
    );
    await _markSynced(
      uploadIntakes.toMarkSynced,
      intakeLocalDataSource.markSynced,
    );
    completedSteps +=
        uploadIntakes.toUpload.length + uploadIntakes.toMarkSynced.length;
    _reportProgress(onProgress, completedSteps, totalSteps);

    await remoteDataSource.syncPurchases(uploadPurchases.toUpload);
    await _markSynced(
      uploadPurchases.toUpload,
      purchaseLocalDataSource.markSynced,
    );
    await _markSynced(
      uploadPurchases.toMarkSynced,
      purchaseLocalDataSource.markSynced,
    );
    completedSteps +=
        uploadPurchases.toUpload.length + uploadPurchases.toMarkSynced.length;
    _reportProgress(onProgress, completedSteps, totalSteps);

    await remoteDataSource.syncGoals(uploadGoals.toUpload);
    await _markSynced(uploadGoals.toUpload, goalLocalDataSource.markSynced);
    await _markSynced(
      uploadGoals.toMarkSynced,
      goalLocalDataSource.markSynced,
    );
    completedSteps +=
        uploadGoals.toUpload.length + uploadGoals.toMarkSynced.length;
    _reportProgress(onProgress, completedSteps, totalSteps);

    await remoteDataSource.syncReminders(uploadReminders.toUpload);
    await _markSynced(
      uploadReminders.toUpload,
      reminderLocalDataSource.markSynced,
    );
    await _markSynced(
      uploadReminders.toMarkSynced,
      reminderLocalDataSource.markSynced,
    );
    completedSteps +=
        uploadReminders.toUpload.length + uploadReminders.toMarkSynced.length;
    _reportProgress(onProgress, completedSteps, totalSteps);

    final downloaded = await _applyRemoteChanges(remote, lastSync: lastSync);
    completedSteps += downloaded;
    _reportProgress(onProgress, completedSteps, totalSteps);

    await _setLastSyncTime(DateTime.now());

    return WaterSyncReport(
      skipped: false,
      uploaded: uploadIntakes.toUpload.length +
          uploadPurchases.toUpload.length +
          uploadGoals.toUpload.length +
          uploadReminders.toUpload.length,
      downloaded: downloaded,
    );
  }

  Future<int> _applyRemoteChanges(
    RemoteWaterData remote, {
    DateTime? lastSync,
  }) async {
    var downloaded = 0;

    downloaded += await _mergeRemoteList<WaterIntakeModel>(
      remote.intakes,
      intakeLocalDataSource.getById,
      intakeLocalDataSource.upsertFromRemote,
      lastSync: lastSync,
    );

    downloaded += await _mergeRemoteList<WaterPurchaseModel>(
      remote.purchases,
      purchaseLocalDataSource.getById,
      purchaseLocalDataSource.upsertFromRemote,
      lastSync: lastSync,
    );

    downloaded += await _mergeRemoteList<WaterGoalModel>(
      remote.goals,
      goalLocalDataSource.getGoalById,
      goalLocalDataSource.upsertGoal,
      lastSync: lastSync,
    );

    downloaded += await _mergeRemoteList<WaterReminderModel>(
      remote.reminders,
      reminderLocalDataSource.getById,
      reminderLocalDataSource.upsertFromRemote,
      lastSync: lastSync,
    );

    return downloaded;
  }

  Future<int> _mergeRemoteList<T>(
    List<T> remoteList,
    Future<T?> Function(String id) getById,
    Future<void> Function(T model) upsert, {
    DateTime? lastSync,
  }) async {
    var applied = 0;

    for (final remote in remoteList) {
      final remoteId = _getId(remote);
      final local = await getById(remoteId);

      if (local == null || _isRemoteNewer(remote, local)) {
        await upsert(_markRemoteSynced(remote));
        applied++;
      }
    }

    return applied;
  }

  _UploadDecision<T> _resolveUploads<T>(
    List<T> pending,
    List<T> remote,
  ) {
    final remoteMap = {
      for (final item in remote) _getId(item): item,
    };

    final toUpload = <T>[];
    final toMarkSynced = <T>[];

    for (final local in pending) {
      final remoteItem = remoteMap[_getId(local)];

      if (remoteItem == null) {
        if (_isDeleted(local)) {
          toMarkSynced.add(local);
        } else {
          toUpload.add(local);
        }
        continue;
      }

      if (_isLocalNewer(local, remoteItem)) {
        toUpload.add(local);
      } else if (!_isRemoteNewer(remoteItem, local)) {
        toMarkSynced.add(local);
      }
    }

    return _UploadDecision<T>(
      toUpload: toUpload,
      toMarkSynced: toMarkSynced,
    );
  }

  Future<void> _markSynced<T>(
    List<T> items,
    Future<void> Function(String id, {String? serverId}) markSynced,
  ) async {
    for (final item in items) {
      await markSynced(_getId(item), serverId: _getServerId(item));
    }
  }

  int _countSteps(int uploads, int downloads) {
    final total = uploads + downloads;
    return total == 0 ? 1 : total;
  }

  void _reportProgress(
    void Function(double progress)? onProgress,
    int completed,
    int total,
  ) {
    if (onProgress == null) return;
    onProgress((completed / total).clamp(0.0, 1.0));
  }

  Future<DateTime?> _getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(_lastSyncKey);
    if (value == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  Future<void> _setLastSyncTime(DateTime value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastSyncKey, value.millisecondsSinceEpoch);
  }

  bool _isLocalNewer(dynamic local, dynamic remote) {
    return _getUpdatedAt(local).isAfter(_getUpdatedAt(remote));
  }

  bool _isRemoteNewer(dynamic remote, dynamic local) {
    return _getUpdatedAt(remote).isAfter(_getUpdatedAt(local));
  }

  bool _isDeleted(dynamic item) {
    return item.isDeleted == true;
  }

  String _getId(dynamic item) {
    return item.id as String;
  }

  String? _getServerId(dynamic item) {
    return item.serverId as String?;
  }

  DateTime _getUpdatedAt(dynamic item) {
    return item.updatedAt as DateTime;
  }

  dynamic _markRemoteSynced(dynamic item) {
    if (item == null) return item;
    item.isSynced = true;
    item.isEdited = false;
    item.isOfflineCreated = false;
    return item;
  }
}

class _UploadDecision<T> {
  final List<T> toUpload;
  final List<T> toMarkSynced;

  const _UploadDecision({
    required this.toUpload,
    required this.toMarkSynced,
  });
}
