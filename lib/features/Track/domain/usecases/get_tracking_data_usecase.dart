import '../../data/models/tracking_model.dart';

import '../repository/tracking_repository.dart';

class GetTrackingDataUseCase {

  final TrackingRepository repository;

  GetTrackingDataUseCase(this.repository);

  Stream<List<TrackingModel>> call() {

    return repository.getTrackingData();
  }
}