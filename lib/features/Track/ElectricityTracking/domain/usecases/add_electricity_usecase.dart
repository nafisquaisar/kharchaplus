import 'package:flutter/foundation.dart';

import '../entities/electricity_entity.dart';
import '../repository/electricity_repository.dart';

class AddElectricityUseCase {
  final ElectricityRepository repository;

  AddElectricityUseCase({
	required this.repository,
  });

  // =========================
  // EXECUTE
  // =========================

  Future<void> execute(ElectricityEntity entity) async {
	try {
	  debugPrint('[UseCase] [ADD ELECTRICITY] start');
	  await repository.addElectricity(entity);
	  debugPrint('[UseCase] [ADD ELECTRICITY] success');
	} catch (e) {
	  debugPrint('[UseCase] [ADD ELECTRICITY] failed: $e');
	  rethrow;
	}
  }
}

