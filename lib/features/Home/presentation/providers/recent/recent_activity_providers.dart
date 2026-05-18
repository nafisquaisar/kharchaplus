import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_tracker/features/Home/presentation/providers/recent/recent_activity_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/isar_service.dart';
import '../../../data/datasource/local/RecentActivityLocalDataSource.dart';
import '../../../data/datasource/remote/recent_activity_remote_datasource.dart';
import '../../../data/repository/recent_activity_repository_impl.dart';
import '../../../domain/entities/RecentActivityEntity.dart';
import '../../../domain/repository/RecentActivityRepository.dart';
import '../../../domain/usecases/recent/add_recent_activity_usecase.dart';
import '../../../domain/usecases/recent/delete_recent_activity_usecase.dart';
import '../../../domain/usecases/recent/get_recent_activities_usecase.dart';
import '../../../domain/usecases/recent/watch_recent_activities_usecase.dart';
import '../../../domain/usecases/recent/watch_remote_recent_activities_usecase.dart';
import '../../../domain/usecases/recent/sync_recent_activities_usecase.dart';
import '../../../domain/usecases/recent/update_recent_activity_usecase.dart';


/// DATASOURCE
final recentActivityLocalDataSourceProvider =
Provider<RecentActivityLocalDataSource>(
      (ref) {
  return RecentActivityLocalDataSourceImpl(
    IsarService.isar,
  );
},
);

final recentActivityRemoteDataSourceProvider =
Provider<RecentActivityRemoteDataSource>(
      (ref) {
  return RecentActivityRemoteDataSourceImpl(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
},
);

/// REPOSITORY
final recentActivityRepositoryProvider =
Provider<RecentActivityRepository>(
      (ref) {
  final localDataSource = ref.watch(
    recentActivityLocalDataSourceProvider,
  );
  final remoteDataSource = ref.watch(
    recentActivityRemoteDataSourceProvider,
  );

  return RecentActivityRepositoryImpl(
    localDataSource,
    remoteDataSource,
  );
},
);

/// USECASES

final addRecentActivityUseCaseProvider =
Provider<AddRecentActivityUseCase>(
      (ref) {
  final repository = ref.watch(
    recentActivityRepositoryProvider,
  );

  return AddRecentActivityUseCase(
    repository,
  );
},
);

final getRecentActivitiesUseCaseProvider =
Provider<GetRecentActivitiesUseCase>(
      (ref) {
  final repository = ref.watch(
    recentActivityRepositoryProvider,
  );

  return GetRecentActivitiesUseCase(
    repository,
  );
},
);

final watchRecentActivitiesUseCaseProvider =
Provider<WatchRecentActivitiesUseCase>(
      (ref) {
  final repository = ref.watch(
    recentActivityRepositoryProvider,
  );

  return WatchRecentActivitiesUseCase(
    repository,
  );
},
);

final watchRemoteRecentActivitiesUseCaseProvider =
Provider<WatchRemoteRecentActivitiesUseCase>(
      (ref) {
  final repository = ref.watch(
    recentActivityRepositoryProvider,
  );

  return WatchRemoteRecentActivitiesUseCase(
    repository,
  );
},
);

final syncRecentActivitiesUseCaseProvider =
Provider<SyncRecentActivitiesUseCase>(
      (ref) {
  final repository = ref.watch(
    recentActivityRepositoryProvider,
  );

  return SyncRecentActivitiesUseCase(
    repository,
  );
},
);

final deleteRecentActivityUseCaseProvider =
Provider<DeleteRecentActivityUseCase>(
      (ref) {
  final repository = ref.watch(
    recentActivityRepositoryProvider,
  );

  return DeleteRecentActivityUseCase(
    repository,
  );
},
);

final updateRecentActivityUseCaseProvider =
Provider<UpdateRecentActivityUseCase>(
      (ref) {
  final repository = ref.watch(
    recentActivityRepositoryProvider,
  );

  return UpdateRecentActivityUseCase(
    repository,
  );
},
);

final recentActivityNotifierProvider = StateNotifierProvider<
    RecentActivityNotifier,
    AsyncValue<List<RecentActivityEntity>>>(
      (ref) {
  return RecentActivityNotifier(ref);
},
);