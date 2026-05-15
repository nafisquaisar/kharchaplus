import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/water_purchase_entity.dart';
import '../purchase/purchase_provider.dart';
import 'purchase_history_filter_provider.dart';

class PurchaseHistoryAnalytics {
  final double totalExpense;
  final int totalPurchases;
  final int tankerCount;
  final double averageMonthlyExpense;

  const PurchaseHistoryAnalytics({
    required this.totalExpense,
    required this.totalPurchases,
    required this.tankerCount,
    required this.averageMonthlyExpense,
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

    if (filter.type != PurchaseTypeFilter.all) {
      final match = _typeMatches(filter.type, purchase.type);
      if (!match) {
        return false;
      }
    }

    if (searchTerm.isNotEmpty) {
      final typeMatch = purchase.type.toLowerCase().contains(searchTerm);
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
  final months = <String, double>{};

  for (final purchase in purchases) {
    totalExpense += purchase.price;
    if (purchase.type == 'Tanker') {
      tankerCount += 1;
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

bool _typeMatches(PurchaseTypeFilter filter, String type) {
  switch (filter) {
    case PurchaseTypeFilter.tanker:
      return type == 'Tanker';
    case PurchaseTypeFilter.can20:
      return type == '20L Can';
    case PurchaseTypeFilter.bisleri:
      return type == 'Bisleri';
    case PurchaseTypeFilter.all:
      return true;
  }
}
