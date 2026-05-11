import 'package:flutter/foundation.dart';

import '../entities/electricity_entity.dart';
import '../repository/electricity_repository.dart';

class GetElectricityUseCase {
  final ElectricityRepository repository;

  GetElectricityUseCase({
	required this.repository,
  });

  // =========================
  // EXECUTE
  // =========================

  Future<List<ElectricityEntity>> execute() async {
	try {
	  debugPrint('[UseCase] [FETCH START]');
	  final result = await repository.getElectricityList();
	  debugPrint('[UseCase] [FETCH SUCCESS] ${result.length}');
	  return result;
	} catch (e) {
	  debugPrint('[UseCase] [FETCH FAILED] $e');
	  rethrow;
	}
  }
}

