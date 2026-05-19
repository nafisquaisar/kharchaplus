import 'package:flutter/foundation.dart';

import '../../../../Track/ElectricityTracking/data/models/electricity_model.dart';
import '../../../../Track/ElectricityTracking/service/FirebaseElectricityService.dart';
import '../../mapper/electricity_tracking_mapper.dart';
import '../../models/electricity_tracking_model.dart';

abstract class ElectricityTrackingHomeRemoteDataSource {
  Future<List<ElectricityTrackingHomeModel>> getElectricityCycles();

  Stream<List<ElectricityTrackingHomeModel>> watchElectricityCycles();
}

class ElectricityTrackingHomeRemoteDataSourceImpl
    implements ElectricityTrackingHomeRemoteDataSource {
  final FirebaseElectricityService service;

  ElectricityTrackingHomeRemoteDataSourceImpl({
    required this.service,
  });

  List<ElectricityTrackingHomeModel> _mapModels(
    List<ElectricityModel> models,
  ) {
    return models
        .where((item) => !item.isDeleted)
        .map(ElectricityTrackingHomeMapper.fromElectricityModel)
        .toList();
  }

  @override
  Future<List<ElectricityTrackingHomeModel>> getElectricityCycles() async {
    try {
      final result = await service.getElectricityList();
      final mapped = _mapModels(result);
      debugPrint('[ElectricityHomeRemote] fetched ${mapped.length} items');
      return mapped;
    } catch (e, stack) {
      debugPrint('[ElectricityHomeRemote] fetch failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Stream<List<ElectricityTrackingHomeModel>> watchElectricityCycles() {
    return service.streamElectricityList().map((items) {
      final mapped = _mapModels(items);
      debugPrint('[ElectricityHomeRemote] stream update ${mapped.length} items');
      return mapped;
    });
  }
}

