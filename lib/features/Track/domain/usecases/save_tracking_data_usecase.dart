import '../../data/models/tracking_model.dart';

import '../repository/tracking_repository.dart';

class SaveTrackingDataUseCase {

  final TrackingRepository repository;

  SaveTrackingDataUseCase(this.repository);

  Future<void> call({
    required TrackingModel tracking,
  }) {

    return repository.saveTrackingData(
      tracking: tracking,
    );
  }
}