import '../../domain/repository/tracking_repository.dart';

import '../datasource/remote/firebase_tracking_service.dart';

import '../models/tracking_model.dart';

class TrackingRepositoryImpl
    implements TrackingRepository {

  final FirebaseTrackingService service;

  TrackingRepositoryImpl(this.service);

  /// ===============================
  /// GET TRACKING DATA
  /// ===============================

  @override
  Stream<List<TrackingModel>> getTrackingData() {

    return service.getTrackingData();
  }

  /// ===============================
  /// SAVE TRACKING
  /// ===============================

  @override
  Future<void> saveTrackingData({
    required TrackingModel tracking,
  }) {

    return service.saveTrackingData(
      tracking: tracking,
    );
  }

  /// ===============================
  /// DELETE MODULE
  /// ===============================

  @override
  Future<void> deleteTrackingModule({
    required String type,
  }) {

    return service.deleteTrackingModule(
      type: type,
    );
  }

  /// ===============================
  /// UPDATE TOTAL AMOUNT
  /// ===============================

  @override
  Future<void> updateTotalAmount({
    required String type,
    required double amount,
  }) {

    return service.updateTotalAmount(
      type: type,
      amount: amount,
    );
  }

  /// ===============================
  /// UPDATE TODAY AMOUNT
  /// ===============================

  @override
  Future<void> updateTodayAmount({
    required String type,
    required double amount,
  }) {

    return service.updateTodayAmount(
      type: type,
      amount: amount,
    );
  }

  /// ===============================
  /// UPDATE ACTIVE CYCLES
  /// ===============================

  @override
  Future<void> updateActiveCycles({
    required String type,
    required int cycle,
  }) {

    return service.updateActiveCycles(
      type: type,
      cycle: cycle,
    );
  }
}