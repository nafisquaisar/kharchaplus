import 'package:flutter/foundation.dart';

import '../../../../Home/domain/entities/RecentActivityEntity.dart';
import '../../../../Home/domain/usecases/recent/add_recent_activity_usecase.dart';
import '../../../../Home/domain/usecases/recent/delete_recent_activity_usecase.dart';
import '../../../../Home/domain/usecases/recent/update_recent_activity_usecase.dart';
import '../datasource/local/electricity_local_datasource.dart';
import '../datasource/remote/electricity_remote_datasource.dart';
import '../mapper/electricity_mapper.dart';
import '../models/electricity_model.dart';
import '../../domain/entities/electricity_entity.dart';
import '../../domain/repository/electricity_repository.dart';

class ElectricityRepositoryImpl
    implements ElectricityRepository {
  final ElectricityRemoteDataSource remoteDataSource;
  final ElectricityLocalDataSource localDataSource;
  final AddRecentActivityUseCase addRecentActivityUseCase;
  final UpdateRecentActivityUseCase updateRecentActivityUseCase;
  final DeleteRecentActivityUseCase deleteRecentActivityUseCase;

  ElectricityRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.addRecentActivityUseCase,
    required this.updateRecentActivityUseCase,
    required this.deleteRecentActivityUseCase,
  });

  // =========================
  // FETCH LIST
  // =========================

  @override
  Future<List<ElectricityEntity>> getElectricityList() async {
    debugPrint('[REPOSITORY START] getElectricityList');
    try {
      debugPrint('[Repository] [REMOTE FETCH] getElectricityList');
      final remote = await _fetchRemote();
      await _cacheElectricity(remote);
      return remote.map((model) => model.toEntity()).toList();
    } catch (e) {
      debugPrint('[Repository] [ERROR] Remote fetch failed: $e');
      final local = await _fetchLocal();
      return local.map((model) => model.toEntity()).toList();
    }
  }

  // =========================
  // STREAM LIST
  // =========================

  @override
  Stream<List<ElectricityEntity>> streamElectricityList() async* {
    debugPrint('[REPOSITORY START] streamElectricityList');
    debugPrint('[Repository] [STREAM] streamElectricityList');

    final cached = await _fetchLocal();
    if (cached.isNotEmpty) {
      yield cached.map((model) => model.toEntity()).toList();
    }

    try {
      await for (final remote in remoteDataSource.streamElectricityList()) {
        await _cacheElectricity(remote);
        yield remote.map((model) => model.toEntity()).toList();
      }
    } catch (e) {
      debugPrint('[Repository] [ERROR] Stream failed: $e');
    }
  }

  // =========================
  // ADD
  // =========================

  @override
  Future<void> addElectricity(
    ElectricityEntity entity,
  ) async {
    debugPrint('[REPOSITORY START] addElectricity ${entity.id}');
    final model = entity.toModel();

    try {
      debugPrint('[Repository] [REMOTE ADD] ${entity.id}');
      await remoteDataSource.addElectricity(model);

      await localDataSource.upsertElectricity(
        _copyModel(
          model,
          isSynced: true,
          isOfflineCreated: false,
          isEdited: false,
        ),
      );

      await addRecentActivityUseCase.call(
        RecentActivityEntity(
          id: DateTime.now()
              .millisecondsSinceEpoch
              .toString(),

          type: 'electricity',

          title: 'Electricity Bill',

          subtitle:
          model.title ?? 'Electricity Added',

          amount:
          ((model.currentUnit - model.prevUnit) *
              model.rate)
              .toDouble(),

          createdAt: DateTime.now(),

          referenceId: model.id,
        ),
      );

    } catch (e) {
      debugPrint('[Repository] [ERROR] Remote add failed: $e');
      await localDataSource.upsertElectricity(
        _copyModel(
          model,
          isSynced: false,
          isOfflineCreated: true,
          isEdited: false,
        ),
      );
    }
  }

  // =========================
  // UPDATE
  // =========================

  @override
  Future<void> updateElectricity(
    ElectricityEntity entity,
  ) async {
    debugPrint('[REPOSITORY START] updateElectricity ${entity.id}');
    final model = entity.toModel();

    try {
      debugPrint('[Repository] [REMOTE UPDATE] ${entity.id}');
      await remoteDataSource.updateElectricity(model);

      await localDataSource.upsertElectricity(
        _copyModel(
          model,
          isSynced: true,
          isOfflineCreated: false,
          isEdited: false,
        ),
      );

      debugPrint('[Repository] [RECENT UPDATE] referenceId=${model.id}');
      await updateRecentActivityUseCase.call(
        RecentActivityEntity(
          id: model.id,
          type: 'electricity',
          title: 'Electricity Bill',
          subtitle: model.title ?? 'Electricity Updated',
          amount: ((model.currentUnit - model.prevUnit) * model.rate).toDouble(),
          createdAt: DateTime.now(),
          referenceId: model.id,
        ),
      );
    } catch (e) {
      debugPrint('[Repository] [ERROR] Remote update failed: $e');
      await localDataSource.upsertElectricity(
        _copyModel(
          model,
          isSynced: false,
          isOfflineCreated: model.isOfflineCreated,
          isEdited: true,
        ),
      );
    }
  }

  // =========================
  // DELETE (SOFT)
  // =========================

  @override
  Future<void> deleteElectricity(String id) async {
    debugPrint('[REPOSITORY START] deleteElectricity $id');
    if (id.trim().isEmpty) {
      throw ArgumentError('Electricity id is required');
    }

    final cached = await localDataSource.getElectricityById(id);

    try {
      debugPrint('[Repository] [REMOTE DELETE] $id');
      await remoteDataSource.softDeleteElectricity(id);

      if (cached != null) {
        await localDataSource.upsertElectricity(
          _copyModel(
            cached,
            isDeleted: true,
            isSynced: true,
            isEdited: false,
          ),
        );
      }

      debugPrint('[Repository] [RECENT DELETE] referenceId=$id');
      await deleteRecentActivityUseCase.call(id);
    } catch (e) {
      debugPrint('[Repository] [ERROR] Remote delete failed: $e');
      if (cached != null) {
        await localDataSource.upsertElectricity(
          _copyModel(
            cached,
            isDeleted: true,
            isSynced: false,
            isEdited: true,
          ),
        );
      } else {
        await localDataSource.softDeleteElectricity(id);
      }
    }
  }

  // =========================
  // SEARCH
  // =========================

  @override
  Future<List<ElectricityEntity>> searchElectricity(
    String query,
  ) async {
    debugPrint('[REPOSITORY START] searchElectricity $query');
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      debugPrint('[Repository] [REMOTE SEARCH] $query');
      final remote = await remoteDataSource.searchElectricity(query);
      return remote.map((model) => model.toEntity()).toList();
    } catch (e) {
      debugPrint('[Repository] [ERROR] Remote search failed: $e');
      final local = await localDataSource.searchElectricity(query);
      return local.map((model) => model.toEntity()).toList();
    }
  }

  // =========================
  // SYNC
  // =========================

  @override
  Future<void> syncPendingElectricity() async {
    debugPrint('[REPOSITORY START] syncPendingElectricity');
    debugPrint('[Repository] [SYNC START]');

    final pending = await localDataSource.getPendingSync();
    for (final model in pending) {
      try {
        if (model.isDeleted) {
          await remoteDataSource.softDeleteElectricity(model.id);
        } else if (model.isOfflineCreated) {
          await remoteDataSource.addElectricity(model);
        } else {
          await remoteDataSource.updateElectricity(model);
        }

        await localDataSource.upsertElectricity(
          _copyModel(
            model,
            isSynced: true,
            isOfflineCreated: false,
            isEdited: false,
          ),
        );
      } catch (e) {
        debugPrint('[Repository] [ERROR] Sync failed for ${model.id}: $e');
      }
    }

    debugPrint('[Repository] [SYNC SUCCESS]');
  }

  // =========================
  // HELPERS
  // =========================

  Future<void> _cacheElectricity(
    List<ElectricityModel> models,
  ) async {
    debugPrint('[Repository] [LOCAL CACHE] ${models.length} items');
    final cached = models
        .map((model) => _copyModel(
              model,
              isSynced: true,
              isOfflineCreated: false,
              isEdited: false,
            ))
        .toList();
    await localDataSource.cacheElectricityList(cached);
  }

  Future<List<ElectricityModel>> _fetchRemote() async {
    return remoteDataSource.getElectricityList();
  }

  Future<List<ElectricityModel>> _fetchLocal() async {
    debugPrint('[Repository] [LOCAL CACHE] fetch');
    return localDataSource.getElectricityList();
  }

  ElectricityModel _copyModel(
    ElectricityModel model, {
    bool? isSynced,
    bool? isDeleted,
    bool? isEdited,
    bool? isOfflineCreated,
    DateTime? updatedAt,
  }) {
    return ElectricityModel(
      id: model.id,
      title: model.title,
      startDate: model.startDate,
      endDate: model.endDate,
      prevUnit: model.prevUnit,
      currentUnit: model.currentUnit,
      rate: model.rate,
      isSynced: isSynced ?? model.isSynced,
      isDeleted: isDeleted ?? model.isDeleted,
      isEdited: isEdited ?? model.isEdited,
      isActive: model.isActive,
      isOfflineCreated: isOfflineCreated ?? model.isOfflineCreated,
      version: model.version,
      createdAt: model.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      userId: model.userId,
      serverId: model.serverId,
    );
  }
}