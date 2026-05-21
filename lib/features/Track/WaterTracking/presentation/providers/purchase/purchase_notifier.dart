import 'package:expense_tracker/core/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../core/utils/formatters.dart';
import '../../../../../Home/domain/entities/RecentActivityEntity.dart';
import '../../../../../Home/domain/usecases/recent/add_recent_activity_usecase.dart';
import '../../../../../Home/domain/usecases/recent/delete_recent_activity_usecase.dart';
import '../../../../../Home/domain/usecases/recent/update_recent_activity_usecase.dart';
import '../../../domain/entities/water_purchase_entity.dart';
import '../../../domain/enum/payment_status.dart';
import '../../../domain/enum/purchase_type.dart';

import '../../../domain/usecases/purchase/add_purchase.dart';
import '../../../domain/usecases/purchase/get_purchases.dart';
import '../../../domain/usecases/purchase/soft_delete_purchase.dart';
import '../../../domain/usecases/purchase/update_purchase.dart';
import '../sync/sync_provider.dart';

import 'purchase_state.dart';

class PurchaseNotifier extends StateNotifier<PurchaseState> {
  final Ref ref;
  final AuthService authService;

  final AddPurchase addPurchaseUsecase;
  final GetPurchases getPurchasesUsecase;
  final SoftDeletePurchase softDeletePurchaseUsecase;
  final UpdatePurchase updatePurchaseUsecase;
  final AddRecentActivityUseCase addRecentActivityUseCase;
  final UpdateRecentActivityUseCase updateRecentActivityUseCase;
  final DeleteRecentActivityUseCase deleteRecentActivityUseCase;

  PurchaseNotifier({
    required this.ref,
    required this.authService,
    required this.addPurchaseUsecase,
    required this.getPurchasesUsecase,
    required this.softDeletePurchaseUsecase,
    required this.updatePurchaseUsecase,
    required this.addRecentActivityUseCase,
    required this.updateRecentActivityUseCase,
    required this.deleteRecentActivityUseCase,
  }) : super(
          PurchaseState.initial(),
        );

  final Uuid uuid = const Uuid();

  String _mapError(
    Object error,
  ) {
    final message = error.toString();
    if (message.contains('Unique index violated')) {
      return 'Purchase update conflicted with local data. Please retry after refresh.';
    }
    return message;
  }

  Future<void> loadPurchases() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final data = await getPurchasesUsecase();

      state = state.copyWith(
        isLoading: false,
        purchases: data,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _mapError(e),
      );
    }
  }

  Future<bool> addPurchase({
    required PurchaseType type,
    String? customTypeName,
    required int quantity,
    required double price,
    String? vendor,
    PaymentStatus paymentStatus = PaymentStatus.unpaid,
  }) async {
    final previousPurchases = state.purchases;

    try {
      final userId = await authService.getCurrentUserId();

      final purchase = WaterPurchaseEntity(
        id: uuid.v4(),
        type: type,
        customTypeName: customTypeName,
        quantity: quantity,
        price: price,
        vendor: vendor,
        paymentStatus: paymentStatus,
        date: DateTime.now(),
        isSynced: false,
        isDeleted: false,
        isEdited: false,
        isActive: true,
        isOfflineCreated: true,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: userId,
      );

      state = state.copyWith(
        isLoading: true,
        purchases: [
          ...state.purchases,
          purchase,
        ],
        error: null,
      );

      await _syncRecentActivity(
        purchase: purchase,
        isUpdate: false,
      );

      await addPurchaseUsecase(
        purchase,
      );

      await loadPurchases();

      ref.read(waterSyncNotifierProvider.notifier).syncNow();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        purchases: previousPurchases,
        error: _mapError(e),
      );
      debugPrint('[Water] recent activity add failed: $e');
      return false;
    }
  }

  Future<void> deletePurchase(
    String id,
  ) async {
    final purchase = state.purchases.firstWhere(
      (item) => item.id == id,
      orElse: () => WaterPurchaseEntity(
        id: id,
        type: PurchaseType.tanker,
        quantity: 0,
        price: 0,
        paymentStatus: PaymentStatus.unpaid,
        date: DateTime.now(),
        isSynced: false,
        isDeleted: false,
        isEdited: false,
        isActive: true,
        isOfflineCreated: false,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: '',
      ),
    );

    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      debugPrint('[Water] recent activity delete referenceId=$id');
      await deleteRecentActivityUseCase.call(id);

      await softDeletePurchaseUsecase(
        id,
      );

      await loadPurchases();

      ref.read(waterSyncNotifierProvider.notifier).syncNow();
    } catch (e) {
      debugPrint('[Water] delete failed: $e');
      await _syncRecentActivity(
        purchase: purchase,
        isUpdate: false,
      );
      state = state.copyWith(
        isLoading: false,
        error: _mapError(e),
      );
    }
  }

  Future<bool> updatePurchase(
    WaterPurchaseEntity purchase,
  ) async {
    final previousPurchases = state.purchases;

    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
        purchases: state.purchases.map((item) {
          if (item.id == purchase.id) {
            return purchase;
          }
          return item;
        }).toList(),
      );

      await _syncRecentActivity(
        purchase: purchase,
        isUpdate: true,
      );

      await updatePurchaseUsecase(purchase);

      await loadPurchases();

      ref.read(waterSyncNotifierProvider.notifier).syncNow();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        purchases: previousPurchases,
        error: _mapError(e),
      );
      debugPrint('[Water] recent activity update failed: $e');
      return false;
    }
  }

  Future<void> _syncRecentActivity({
    required WaterPurchaseEntity purchase,
    required bool isUpdate,
  }) async {
    final dateLabel = AppFormatters.date(
      purchase.date,
    );

    final subtitle = '${purchase.quantity}L • $dateLabel';

    final recent = RecentActivityEntity(
      id: purchase.id,
      userId: purchase.userId,
      type: 'water_management',
      title: 'Water Tanker',
      subtitle: subtitle,
      amount: purchase.price,
      createdAt: purchase.createdAt,
      updatedAt: purchase.updatedAt,
      referenceId: purchase.id,
      isSynced: false,
      isDeleted: false,
      isEdited: isUpdate,
      version: purchase.version,
    );

    if (isUpdate) {
      debugPrint(
        '[Water] recent activity updated referenceId=${purchase.id}',
      );

      await updateRecentActivityUseCase.call(recent);
    } else {
      debugPrint(
        '[Water] recent activity added referenceId=${purchase.id}',
      );

      await addRecentActivityUseCase.call(recent);
    }
  }

  void removePurchaseOptimistic(
    WaterPurchaseEntity purchase,
  ) {
    state = state.copyWith(
      purchases:
          state.purchases.where((item) => item.id != purchase.id).toList(),
    );
  }

  void restorePurchaseOptimistic(
    WaterPurchaseEntity purchase,
  ) {
    state = state.copyWith(
      purchases: [purchase, ...state.purchases],
    );
  }
}
