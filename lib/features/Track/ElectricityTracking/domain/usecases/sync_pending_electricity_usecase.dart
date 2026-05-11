import 'package:flutter/foundation.dart';

import '../repository/electricity_repository.dart';

class SyncPendingElectricityUseCase {
  final ElectricityRepository repository;

  SyncPendingElectricityUseCase({
	required this.repository,
  });

  // =========================
  // EXECUTE
  // =========================

  Future<void> execute() async {
	try {
	  debugPrint('[UseCase] [SYNC START]');
	  await repository.syncPendingElectricity();
	  debugPrint('[UseCase] [SYNC SUCCESS]');
	} catch (e) {
	  debugPrint('[UseCase] [SYNC FAILED] $e');
	  rethrow;
	}
  }
}

