import '../../models/electricity_model.dart';

abstract class ElectricityLocalDataSource {
  Future<void> cacheElectricityList(
	List<ElectricityModel> models,
  );

  Future<List<ElectricityModel>> getElectricityList({
	bool includeDeleted = false,
  });

  Future<ElectricityModel?> getElectricityById(String id);

  Future<void> upsertElectricity(ElectricityModel model);

  Future<void> softDeleteElectricity(String id);

  Future<List<ElectricityModel>> searchElectricity(String query);

  Future<List<ElectricityModel>> getPendingSync();
}

class InMemoryElectricityLocalDataSource
	implements ElectricityLocalDataSource {
  final List<ElectricityModel> _cache = [];

  @override
  Future<void> cacheElectricityList(
	List<ElectricityModel> models,
  ) async {
	_cache
	  ..clear()
	  ..addAll(models);
  }

  @override
  Future<List<ElectricityModel>> getElectricityList({
	bool includeDeleted = false,
  }) async {
	return _cache
		.where((item) => includeDeleted || !item.isDeleted)
		.toList();
  }

  @override
  Future<ElectricityModel?> getElectricityById(String id) async {
	try {
	  return _cache.firstWhere((item) => item.id == id);
	} catch (_) {
	  return null;
	}
  }

  @override
  Future<void> upsertElectricity(ElectricityModel model) async {
	final index = _cache.indexWhere((item) => item.id == model.id);
	if (index == -1) {
	  _cache.add(model);
	} else {
	  _cache[index] = model;
	}
  }

  @override
  Future<void> softDeleteElectricity(String id) async {
	final index = _cache.indexWhere((item) => item.id == id);
	if (index != -1) {
	  _cache[index] = ElectricityModel(
		id: _cache[index].id,
		title: _cache[index].title,
		startDate: _cache[index].startDate,
		endDate: _cache[index].endDate,
		prevUnit: _cache[index].prevUnit,
		currentUnit: _cache[index].currentUnit,
		rate: _cache[index].rate,
		isSynced: false,
		isDeleted: true,
		isEdited: _cache[index].isEdited,
		isActive: _cache[index].isActive,
		isOfflineCreated: _cache[index].isOfflineCreated,
		version: _cache[index].version,
		createdAt: _cache[index].createdAt,
		updatedAt: DateTime.now(),
		userId: _cache[index].userId,
		serverId: _cache[index].serverId,
	  );
	}
  }

  @override
  Future<List<ElectricityModel>> searchElectricity(String query) async {
	final searchText = query.trim().toLowerCase();
	if (searchText.isEmpty) {
	  return [];
	}

	return _cache.where((item) {
	  final title = (item.title ?? '').toLowerCase();
	  return !item.isDeleted && title.contains(searchText);
	}).toList();
  }

  @override
  Future<List<ElectricityModel>> getPendingSync() async {
	return _cache.where((item) {
	  return !item.isSynced || item.isEdited || item.isOfflineCreated;
	}).toList();
  }
}

