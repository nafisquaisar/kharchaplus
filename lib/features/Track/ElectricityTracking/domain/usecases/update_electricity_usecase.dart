import 'package:flutter/foundation.dart';

import '../entities/electricity_entity.dart';
import '../repository/electricity_repository.dart';

class UpdateElectricityUseCase {
  final ElectricityRepository repository;

  UpdateElectricityUseCase({
	required this.repository,
  });

  // =========================
  // EXECUTE
  // =========================

  Future<void> execute(ElectricityEntity entity) async {
	try {
	  debugPrint('[UseCase] [UPDATE ELECTRICITY] start');
	  await repository.updateElectricity(entity);
	  debugPrint('[UseCase] [UPDATE ELECTRICITY] success');
	} catch (e) {
	  debugPrint('[UseCase] [UPDATE ELECTRICITY] failed: $e');
	  rethrow;
	}
  }
}

