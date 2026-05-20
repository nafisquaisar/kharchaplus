import '../repository/tracking_repository.dart';

class UpdateTotalAmountUseCase {

  final TrackingRepository repository;

  UpdateTotalAmountUseCase(this.repository);

  Future<void> call({
    required String type,
    required double amount,
  }) {

    return repository.updateTotalAmount(
      type: type,
      amount: amount,
    );
  }
}