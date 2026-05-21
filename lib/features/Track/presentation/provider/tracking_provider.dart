import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// MODELS
import '../../data/models/tracking_model.dart';

/// SERVICES
import '../../data/datasource/remote/firebase_tracking_service.dart';
import '../../data/datasource/remote/initialize_tracking_data.dart';

/// REPOSITORY
import '../../data/repository/tracking_repository_impl.dart';

/// USECASES
import '../../domain/usecases/get_tracking_data_usecase.dart';

import '../../domain/usecases/save_tracking_data_usecase.dart';

import '../../domain/usecases/update_total_amount_usecase.dart';

import '../../domain/usecases/update_today_amount_usecase.dart';

import '../../domain/usecases/update_active_cycles_usecase.dart';

import '../../domain/usecases/delete_tracking_module_usecase.dart';

/// ===============================================
/// FIREBASE INSTANCES
/// ===============================================

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

/// ===============================================
/// FIREBASE TRACKING SERVICE
/// ===============================================

final firebaseTrackingServiceProvider =
    Provider<FirebaseTrackingService>((ref) {
  return FirebaseTrackingService(
    firestore: ref.read(firebaseFirestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
});

final initializeTrackingDataProvider = Provider<InitializeTrackingData>((ref) {
  return InitializeTrackingData(
    firestore: ref.watch(firebaseFirestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
});

/// ===============================================
/// TRACKING REPOSITORY
/// ===============================================

final trackingRepositoryProvider = Provider<TrackingRepositoryImpl>((ref) {
  return TrackingRepositoryImpl(
    ref.read(firebaseTrackingServiceProvider),
  );
});

/// ===============================================
/// USE CASE PROVIDERS
/// ===============================================

final getTrackingDataUseCaseProvider = Provider<GetTrackingDataUseCase>((ref) {
  return GetTrackingDataUseCase(
    ref.read(trackingRepositoryProvider),
  );
});

final saveTrackingDataUseCaseProvider =
    Provider<SaveTrackingDataUseCase>((ref) {
  return SaveTrackingDataUseCase(
    ref.read(trackingRepositoryProvider),
  );
});

final updateTotalAmountUseCaseProvider =
    Provider<UpdateTotalAmountUseCase>((ref) {
  return UpdateTotalAmountUseCase(
    ref.read(trackingRepositoryProvider),
  );
});

final updateTodayAmountUseCaseProvider =
    Provider<UpdateTodayAmountUseCase>((ref) {
  return UpdateTodayAmountUseCase(
    ref.read(trackingRepositoryProvider),
  );
});

final updateActiveCyclesUseCaseProvider =
    Provider<UpdateActiveCyclesUseCase>((ref) {
  return UpdateActiveCyclesUseCase(
    ref.read(trackingRepositoryProvider),
  );
});

final deleteTrackingModuleUseCaseProvider =
    Provider<DeleteTrackingModuleUseCase>((ref) {
  return DeleteTrackingModuleUseCase(
    ref.read(trackingRepositoryProvider),
  );
});

/// ===============================================
/// TRACKING STREAM PROVIDER
/// ===============================================

final trackingProvider = StreamProvider.autoDispose<List<TrackingModel>>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  final defaultModules = TrackingModel.mergeWithDefaults(
    const <TrackingModel>[],
  );

  if (authState.isLoading) {
    return Stream.value(defaultModules);
  }

  final user = authState.valueOrNull;

  if (user == null) {
    return Stream.value(defaultModules);
  }

  final initializer = ref.read(
    initializeTrackingDataProvider,
  );

  final stream = ref
      .read(getTrackingDataUseCaseProvider)
      .call()
      .map(
        TrackingModel.mergeWithDefaults,
      )
      .handleError((error, stackTrace) {
    debugPrint('[TrackingProvider] stream error: $error');
    debugPrint('$stackTrace');
  });

  return (() async* {
    yield defaultModules;
    try {
      await initializer.initialize();
    } catch (error, stackTrace) {
      debugPrint('[TrackingProvider] init error: $error');
      debugPrint('$stackTrace');
    }
    yield* stream;
  })();
});
