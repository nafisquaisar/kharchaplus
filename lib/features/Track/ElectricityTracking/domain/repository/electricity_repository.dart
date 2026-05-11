import '../entities/electricity_entity.dart';

abstract class ElectricityRepository {

  Future<List<ElectricityEntity>>
  getElectricityList();

  Stream<List<ElectricityEntity>>
  streamElectricityList();

  Future<void> addElectricity(
      ElectricityEntity entity,
      );

  Future<void> updateElectricity(
      ElectricityEntity entity,
      );

  Future<void> deleteElectricity(
      String id,
      );

  Future<List<ElectricityEntity>>
  searchElectricity(
      String query,
      );

  Future<void> syncPendingElectricity();
}