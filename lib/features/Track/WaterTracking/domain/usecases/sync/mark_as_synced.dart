import '../../repository/water_repository.dart';

class MarkAsSynced {

  final WaterRepository repository;

  MarkAsSynced(this.repository);

  Future<void> call(
      String id,
      ) async {

    await repository.markAsSynced(
      id,
    );
  }
}