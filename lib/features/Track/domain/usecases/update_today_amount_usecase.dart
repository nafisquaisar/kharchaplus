import '../repository/tracking_repository.dart';

class UpdateTodayAmountUseCase {

  final TrackingRepository repository;

  UpdateTodayAmountUseCase(this.repository);

  Future<void> call({
    required String type,
    required double amount,
  }) {

    return repository.updateTodayAmount(
      type: type,
      amount: amount,
    );
  }
}