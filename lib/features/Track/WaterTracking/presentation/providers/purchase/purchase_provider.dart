import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/providers/auth_provider.dart';
import '../../../../../Home/presentation/providers/recent/recent_activity_providers.dart';
import '../../../data/datasource/local/isar/water_goal_local_ds_imple.dart';
import '../../../data/datasource/local/isar/water_intake_local_ds_impl.dart';
import '../../../data/datasource/local/isar/water_purchase_local_ds.dart';

import '../../../data/datasource/local/isar/water_purchase_local_ds_impl.dart';
import '../../../data/repository/water_repository_impl.dart';

import '../../../domain/usecases/purchase/add_purchase.dart';
import '../../../domain/usecases/purchase/get_purchases.dart';
import '../../../domain/usecases/purchase/soft_delete_purchase.dart';
import '../../../domain/usecases/purchase/update_purchase.dart';

import 'purchase_notifier.dart';
import 'purchase_state.dart';

// =========================
// Datasource
// =========================

final waterPurchaseLocalDSProvider =
Provider<
    WaterPurchaseLocalDataSource>(

      (ref) {

    return
      WaterPurchaseLocalDataSourceImpl();
  },
);

// =========================
// Repository
// =========================

final waterPurchaseRepositoryProvider =
Provider<WaterRepositoryImpl>(

      (ref) {

    return WaterRepositoryImpl(

      intakeLocalDataSource:
      WaterIntakeLocalDataSourceImpl(),

      purchaseLocalDataSource:
      ref.read(
        waterPurchaseLocalDSProvider,
      ),

      goalLocalDataSource:
      WaterGoalLocalDataSourceImpl(),

      authService: ref.read(authServiceProvider),
    );
  },
);

// =========================
// Usecases
// =========================

final addPurchaseProvider =
Provider<AddPurchase>(

      (ref) {

    return AddPurchase(

      ref.read(
        waterPurchaseRepositoryProvider,
      ),
    );
  },
);

final getPurchasesProvider =
Provider<GetPurchases>(

      (ref) {

    return GetPurchases(

      ref.read(
        waterPurchaseRepositoryProvider,
      ),
    );
  },
);

final softDeletePurchaseProvider =
Provider<SoftDeletePurchase>(

      (ref) {

    return SoftDeletePurchase(

      ref.read(
        waterPurchaseRepositoryProvider,
      ),
    );
  },
);

final updatePurchaseProvider =
Provider<UpdatePurchase>(
  (ref) {
    return UpdatePurchase(
      ref.read(
        waterPurchaseRepositoryProvider,
      ),
    );
  },
);

// =========================
// Notifier
// =========================

final purchaseNotifierProvider =
StateNotifierProvider<
    PurchaseNotifier,
    PurchaseState>(

      (ref) {

    return PurchaseNotifier(

      ref: ref,

      authService: ref.read(authServiceProvider),

      addPurchaseUsecase:
      ref.read(
        addPurchaseProvider,
      ),

      getPurchasesUsecase:
      ref.read(
        getPurchasesProvider,
      ),

      softDeletePurchaseUsecase:
      ref.read(
        softDeletePurchaseProvider,
      ),

      updatePurchaseUsecase:
      ref.read(
        updatePurchaseProvider,
      ),

      addRecentActivityUseCase:
      ref.read(addRecentActivityUseCaseProvider),

      updateRecentActivityUseCase:
      ref.read(updateRecentActivityUseCaseProvider),

      deleteRecentActivityUseCase:
      ref.read(deleteRecentActivityUseCaseProvider),
    );
  },
);