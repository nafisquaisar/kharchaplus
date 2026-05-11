import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/local/electricity_local_datasource.dart';
import '../../data/datasource/remote/electricity_remote_datasource.dart';
import '../../data/repository/electricity_repository_impl.dart';
import '../../domain/repository/electricity_repository.dart';
import '../../domain/usecases/add_electricity_usecase.dart';
import '../../domain/usecases/delete_electricity_usecase.dart';
import '../../domain/usecases/get_electricity_usecase.dart';
import '../../domain/usecases/search_electricity_usecase.dart';
import '../../domain/usecases/stream_electricity_usecase.dart';
import '../../domain/usecases/sync_pending_electricity_usecase.dart';
import '../../domain/usecases/update_electricity_usecase.dart';
import '../../service/FirebaseElectricityService.dart';
import 'electricity_provider.dart';
import '../states/electricity_state.dart';

// =========================
// FIREBASE CORE
// =========================

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  debugPrint('[DI] FirebaseFirestore instance');
  return FirebaseFirestore.instance;
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  debugPrint('[DI] FirebaseAuth instance');
  return FirebaseAuth.instance;
});

// =========================
// SERVICES
// =========================

final firebaseElectricityServiceProvider =
    Provider<FirebaseElectricityService>((ref) {
  debugPrint('[DI] FirebaseElectricityService');
  return FirebaseElectricityService(
    firestore: ref.read(firebaseFirestoreProvider),
    auth: ref.read(firebaseAuthProvider),
  );
});

// =========================
// DATASOURCES
// =========================

final electricityRemoteDataSourceProvider =
    Provider<ElectricityRemoteDataSource>((ref) {
  debugPrint('[DI] ElectricityRemoteDataSource');
  return ElectricityRemoteDataSourceImpl(
    service: ref.read(firebaseElectricityServiceProvider),
  );
});

final electricityLocalDataSourceProvider =
    Provider<ElectricityLocalDataSource>((ref) {
  debugPrint('[DI] ElectricityLocalDataSource');
  return InMemoryElectricityLocalDataSource();
});

// =========================
// REPOSITORY
// =========================

final electricityRepositoryProvider = Provider<ElectricityRepository>((ref) {
  debugPrint('[DI] ElectricityRepository');
  return ElectricityRepositoryImpl(
    remoteDataSource: ref.read(electricityRemoteDataSourceProvider),
    localDataSource: ref.read(electricityLocalDataSourceProvider),
  );
});

// =========================
// USECASES
// =========================

final addElectricityUseCaseProvider = Provider<AddElectricityUseCase>((ref) {
  return AddElectricityUseCase(
    repository: ref.read(electricityRepositoryProvider),
  );
});

final getElectricityUseCaseProvider = Provider<GetElectricityUseCase>((ref) {
  return GetElectricityUseCase(
    repository: ref.read(electricityRepositoryProvider),
  );
});

final updateElectricityUseCaseProvider =
    Provider<UpdateElectricityUseCase>((ref) {
  return UpdateElectricityUseCase(
    repository: ref.read(electricityRepositoryProvider),
  );
});

final deleteElectricityUseCaseProvider =
    Provider<DeleteElectricityUseCase>((ref) {
  return DeleteElectricityUseCase(
    repository: ref.read(electricityRepositoryProvider),
  );
});

final searchElectricityUseCaseProvider =
    Provider<SearchElectricityUseCase>((ref) {
  return SearchElectricityUseCase(
    repository: ref.read(electricityRepositoryProvider),
  );
});

final streamElectricityUseCaseProvider =
    Provider<StreamElectricityUseCase>((ref) {
  return StreamElectricityUseCase(
    repository: ref.read(electricityRepositoryProvider),
  );
});

final syncPendingElectricityUseCaseProvider =
    Provider<SyncPendingElectricityUseCase>((ref) {
  return SyncPendingElectricityUseCase(
    repository: ref.read(electricityRepositoryProvider),
  );
});

// =========================
// PROVIDER
// =========================

final electricityProvider =
    StateNotifierProvider<ElectricityNotifier, ElectricityState>((ref) {
  return ElectricityNotifier(
    addUseCase: ref.read(addElectricityUseCaseProvider),
    getUseCase: ref.read(getElectricityUseCaseProvider),
    updateUseCase: ref.read(updateElectricityUseCaseProvider),
    deleteUseCase: ref.read(deleteElectricityUseCaseProvider),
    searchUseCase: ref.read(searchElectricityUseCaseProvider),
    streamUseCase: ref.read(streamElectricityUseCaseProvider),
    syncPendingUseCase: ref.read(syncPendingElectricityUseCaseProvider),
  );
});
