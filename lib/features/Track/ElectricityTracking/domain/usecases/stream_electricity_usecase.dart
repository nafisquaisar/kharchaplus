import 'package:flutter/foundation.dart';

import '../entities/electricity_entity.dart';
import '../repository/electricity_repository.dart';

class StreamElectricityUseCase {
  final ElectricityRepository repository;

  StreamElectricityUseCase({
	required this.repository,
  });

  // =========================
  // EXECUTE
  // =========================

  Stream<List<ElectricityEntity>> execute() {
	try {
	  debugPrint('[UseCase] [STREAM START]');
	  return repository.streamElectricityList();
	} catch (e) {
	  debugPrint('[UseCase] [STREAM FAILED] $e');
	  rethrow;
	}
  }
}

