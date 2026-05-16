import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/water_purchase_entity.dart';
import '../../../domain/enum/payment_status.dart';
import '../../../domain/enum/purchase_type.dart';
import '../purchase/purchase_provider.dart';
import 'purchase_history_filter_provider.dart';

class PurchaseHistoryAnalytics {
  final double totalExpense;
  final int totalPurchases;
  final int tankerCount;
  final double averageMonthlyExpense;
  final double totalUnpaidAmount;
  final int paidPurchases;
  final double pendingAmount;

  const PurchaseHistoryAnalytics({
    required this.totalExpense,
    required this.totalPurchases,
    required this.tankerCount,
    required this.averageMonthlyExpense,
    required this.totalUnpaidAmount,
    required this.paidPurchases,
    required this.pendingAmount,
  });
}

class PurchaseHistoryViewState {
  final List<WaterPurchaseEntity> purchases;
  final PurchaseHistoryAnalytics analytics;
  final bool isLoading;
  final String? error;

  const PurchaseHistoryViewState({
    required this.purchases,
    required this.analytics,
    required this.isLoading,
    required this.error,
  });
}

final purchaseHistoryFilteredProvider =
    Provider<List<WaterPurchaseEntity>>((ref) {
  final state = ref.watch(purchaseNotifierProvider);
  final filter = ref.watch(purchaseHistoryFilterProvider);
  final search = ref.watch(purchaseHistorySearchProvider);

  final searchTerm = search.trim().toLowerCase();
  final filtered = state.purchases.where((purchase) {
    if (filter.month != null && purchase.date.month != filter.month) {
      return false;
    }
    if (filter.year != null && purchase.date.year != filter.year) {
      return false;
    }

    if (filter.type != null && purchase.type != filter.type) {
      return false;
    }

    if (searchTerm.isNotEmpty) {
      final typeMatch =
          purchase.displayTypeName.toLowerCase().contains(searchTerm);
      final vendorMatch =
          (purchase.vendor ?? '').toLowerCase().contains(searchTerm);
      if (!typeMatch && !vendorMatch) {
        return false;
      }
    }

    return true;
  }).toList();

  filtered.sort((a, b) {
    switch (filter.sort) {
      case PurchaseSort.latest:
        return b.date.compareTo(a.date);
      case PurchaseSort.oldest:
        return a.date.compareTo(b.date);
      case PurchaseSort.highestPrice:
        return b.price.compareTo(a.price);
      case PurchaseSort.lowestPrice:
        return a.price.compareTo(b.price);
    }
  });

  return filtered;
});

final purchaseHistoryAnalyticsProvider =
    Provider<PurchaseHistoryAnalytics>((ref) {
  final purchases = ref.watch(purchaseHistoryFilteredProvider);

  double totalExpense = 0;
  int tankerCount = 0;
  double totalUnpaidAmount = 0;
  double pendingAmount = 0;
  int paidPurchases = 0;
  final months = <String, double>{};

  for (final purchase in purchases) {
    totalExpense += purchase.price;
    if (purchase.type == PurchaseType.tanker) {
      tankerCount += 1;
    }

    if (purchase.paymentStatus == PaymentStatus.paid) {
      paidPurchases += 1;
    }
    if (purchase.paymentStatus == PaymentStatus.unpaid) {
      totalUnpaidAmount += purchase.price;
    }
    if (purchase.paymentStatus.isPending) {
      pendingAmount += purchase.price;
    }

    final key = '${purchase.date.year}-${purchase.date.month}';
    months[key] = (months[key] ?? 0) + purchase.price;
  }

  final averageMonthlyExpense = months.isEmpty
      ? 0.0
      : (months.values.reduce((a, b) => a + b) / months.length).toDouble();

  return PurchaseHistoryAnalytics(
    totalExpense: totalExpense,
    totalPurchases: purchases.length,
    tankerCount: tankerCount,
    averageMonthlyExpense: averageMonthlyExpense,
    totalUnpaidAmount: totalUnpaidAmount,
    paidPurchases: paidPurchases,
    pendingAmount: pendingAmount,
  );
});

final purchaseHistoryProvider = Provider<PurchaseHistoryViewState>((ref) {
  final state = ref.watch(purchaseNotifierProvider);
  final purchases = ref.watch(purchaseHistoryFilteredProvider);
  final analytics = ref.watch(purchaseHistoryAnalyticsProvider);

  return PurchaseHistoryViewState(
    purchases: purchases,
    analytics: analytics,
    isLoading: state.isLoading,
    error: state.error,
  );
});

