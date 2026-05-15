import '../../../domain/entities/water_purchase_entity.dart';

class PurchaseState {

  final bool isLoading;

  final List<WaterPurchaseEntity>
  purchases;

  final String? error;

  const PurchaseState({

    required this.isLoading,

    required this.purchases,

    this.error,
  });

  factory PurchaseState.initial() {

    return const PurchaseState(

      isLoading: false,

      purchases: [],

      error: null,
    );
  }

  PurchaseState copyWith({

    bool? isLoading,

    List<WaterPurchaseEntity>?
    purchases,

    String? error,
  }) {

    return PurchaseState(

      isLoading:
      isLoading ??
          this.isLoading,

      purchases:
      purchases ??
          this.purchases,

      error: error,
    );
  }
}