import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/providers/auth_provider.dart';
import '../../../data/datasource/local/isar/water_goal_local_ds_imple.dart';
import '../../../data/datasource/local/isar/water_intake_local_ds_impl.dart';
import '../../../data/datasource/local/isar/water_purchase_local_ds_impl.dart';
import '../../../data/datasource/local/isar/water_reminder_local_ds_impl.dart';
import '../../../data/datasource/remote/firebase_water_remote_ds.dart';
import '../../../data/repository/water_sync_repository_impl.dart';
import '../../../domain/repository/water_sync_repository.dart';
import '../../../domain/usecases/sync/sync_water_data.dart';
import '../../../services/water_sync_service.dart';
import 'sync_notifier.dart';
import 'sync_state.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final waterRemoteDataSourceProvider =
    Provider<FirebaseWaterRemoteDataSource>((ref) {
  return FirebaseWaterRemoteDataSourceImpl(
    firestore: ref.read(firebaseFirestoreProvider),
    auth: ref.read(firebaseAuthProvider),
  );
});

final waterSyncServiceProvider = Provider<WaterSyncService>((ref) {
  return WaterSyncService(
    remoteDataSource: ref.read(waterRemoteDataSourceProvider),
    intakeLocalDataSource: WaterIntakeLocalDataSourceImpl(),
    purchaseLocalDataSource: WaterPurchaseLocalDataSourceImpl(),
    goalLocalDataSource: WaterGoalLocalDataSourceImpl(),
    reminderLocalDataSource: WaterReminderLocalDataSourceImpl(),
    authService: ref.read(authServiceProvider),
    connectivity: ref.read(connectivityProvider),
  );
});

final waterSyncRepositoryProvider = Provider<WaterSyncRepository>((ref) {
  return WaterSyncRepositoryImpl(
    service: ref.read(waterSyncServiceProvider),
  );
});

final syncWaterDataProvider = Provider<SyncWaterData>((ref) {
  return SyncWaterData(
    ref.read(waterSyncRepositoryProvider),
  );
});

final waterSyncNotifierProvider =
    StateNotifierProvider<WaterSyncNotifier, SyncState>((ref) {
  return WaterSyncNotifier(
    syncWaterData: ref.read(syncWaterDataProvider),
    connectivity: ref.read(connectivityProvider),
  )..start();
});
