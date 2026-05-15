import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/water_purchase_entity.dart';
import '../purchase/purchase_provider.dart';

class MonthYear {
  final int month;
  final int year;

  const MonthYear({
    required this.month,
    required this.year,
  });

  DateTime toDate() => DateTime(year, month, 1);
}

final selectedMonthProvider = StateProvider<MonthYear>((ref) {
  final now = DateTime.now();
  return MonthYear(month: now.month, year: now.year);
});

final filteredPurchasesProvider = Provider<List<WaterPurchaseEntity>>((ref) {
  final state = ref.watch(purchaseNotifierProvider);
  final filter = ref.watch(selectedMonthProvider);

  return state.purchases.where((purchase) {
    return purchase.date.month == filter.month &&
        purchase.date.year == filter.year;
  }).toList();
});

