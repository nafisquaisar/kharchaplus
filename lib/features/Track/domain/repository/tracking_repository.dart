import '../../data/models/tracking_model.dart';

abstract class TrackingRepository {

  /// ===============================
  /// GET ALL TRACKING DATA
  /// ===============================

  Stream<List<TrackingModel>> getTrackingData();

  /// ===============================
  /// SAVE TRACKING
  /// ===============================

  Future<void> saveTrackingData({
    required TrackingModel tracking,
  });

  /// ===============================
  /// DELETE TRACKING MODULE
  /// ===============================

  Future<void> deleteTrackingModule({
    required String type,
  });

  /// ===============================
  /// UPDATE TOTAL AMOUNT
  /// ===============================

  Future<void> updateTotalAmount({
    required String type,
    required double amount,
  });

  /// ===============================
  /// UPDATE TODAY AMOUNT
  /// ===============================

  Future<void> updateTodayAmount({
    required String type,
    required double amount,
  });

  /// ===============================
  /// UPDATE ACTIVE CYCLES
  /// ===============================

  Future<void> updateActiveCycles({
    required String type,
    required int cycle,
  });
}