import '../../../../../../core/base/base_entity.dart';
import '../../repository/water_repository.dart';

class GetPendingSync {

  final WaterRepository repository;

  GetPendingSync(this.repository);

  Future<List<BaseEntity>>
  call() async {
    return repository.getPendingSync();
  }
}