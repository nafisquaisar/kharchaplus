import 'package:flutter/foundation.dart';

import '../entities/electricity_entity.dart';
import '../repository/electricity_repository.dart';

class SearchElectricityUseCase {
  final ElectricityRepository repository;

  SearchElectricityUseCase({
	required this.repository,
  });

  // =========================
  // EXECUTE
  // =========================

  Future<List<ElectricityEntity>> execute(String query) async {
	try {
	  debugPrint('[UseCase] [SEARCH START] $query');
	  final result = await repository.searchElectricity(query);
	  debugPrint('[UseCase] [SEARCH SUCCESS] ${result.length}');
	  return result;
	} catch (e) {
	  debugPrint('[UseCase] [SEARCH FAILED] $e');
	  rethrow;
	}
  }
}

