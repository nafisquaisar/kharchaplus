import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../service/FirebaseElectricityService.dart';
import '../../models/electricity_model.dart';

abstract class ElectricityRemoteDataSource {
  Future<void> addElectricity(ElectricityModel model);

  Future<void> updateElectricity(ElectricityModel model);

  Future<void> softDeleteElectricity(String id);

  Future<List<ElectricityModel>> getElectricityList({
	int limit = 50,
	bool descending = true,
  });

  Stream<List<ElectricityModel>> streamElectricityList({
	int limit = 50,
	bool descending = true,
  });

  Future<List<ElectricityModel>> searchElectricity(
	String query, {
	int limit = 50,
  });

  Future<ElectricityPageResult> getPaginatedElectricity({
	DocumentSnapshot<Map<String, dynamic>>? lastDocument,
	int limit = 20,
	bool descending = true,
  });
}

class ElectricityRemoteDataSourceImpl
	implements ElectricityRemoteDataSource {
  final FirebaseElectricityService service;

  ElectricityRemoteDataSourceImpl({
	required this.service,
  });

  @override
  Future<void> addElectricity(ElectricityModel model) {
	debugPrint('[REMOTE DATASOURCE START] addElectricity');
	return service.addElectricity(model);
  }

  @override
  Future<void> updateElectricity(ElectricityModel model) {
	debugPrint('[REMOTE DATASOURCE START] updateElectricity');
	return service.updateElectricity(model);
  }

  @override
  Future<void> softDeleteElectricity(String id) {
	debugPrint('[REMOTE DATASOURCE START] softDeleteElectricity');
	return service.softDeleteElectricity(id);
  }

  @override
  Future<List<ElectricityModel>> getElectricityList({
	int limit = 50,
	bool descending = true,
  }) {
	debugPrint('[REMOTE DATASOURCE START] getElectricityList');
 	return service.getElectricityList(
 	  limit: limit,
 	  descending: descending,
 	);
  }

  @override
  Stream<List<ElectricityModel>> streamElectricityList({
	int limit = 50,
	bool descending = true,
  }) {
	debugPrint('[REMOTE DATASOURCE START] streamElectricityList');
 	return service.streamElectricityList(
 	  limit: limit,
 	  descending: descending,
 	);
  }

  @override
  Future<List<ElectricityModel>> searchElectricity(
  	String query, {
  	int limit = 50,
  }) {
	debugPrint('[REMOTE DATASOURCE START] searchElectricity');
 	return service.searchElectricity(
 	  query,
 	  limit: limit,
 	);
  }

  @override
  Future<ElectricityPageResult> getPaginatedElectricity({
  	DocumentSnapshot<Map<String, dynamic>>? lastDocument,
  	int limit = 20,
  	bool descending = true,
  }) {
	debugPrint('[REMOTE DATASOURCE START] getPaginatedElectricity');
 	return service.getPaginatedElectricity(
 	  lastDocument: lastDocument,
 	  limit: limit,
 	  descending: descending,
 	);
  }
}
