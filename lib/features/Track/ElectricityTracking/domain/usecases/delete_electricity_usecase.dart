import 'package:flutter/foundation.dart';

import '../repository/electricity_repository.dart';

class DeleteElectricityUseCase {
  final ElectricityRepository repository;

  DeleteElectricityUseCase({
	required this.repository,
  });

  // =========================
  // EXECUTE
  // =========================

  Future<void> execute(String id) async {
	try {
	  debugPrint('[UseCase] [DELETE START] $id');
	  await repository.deleteElectricity(id);
	  debugPrint('[UseCase] [DELETE SUCCESS] $id');
	} catch (e) {
	  debugPrint('[UseCase] [DELETE FAILED] $e');
	  rethrow;
	}
  }
}

