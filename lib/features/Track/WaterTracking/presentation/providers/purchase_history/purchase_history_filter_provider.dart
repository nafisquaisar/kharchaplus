import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PurchaseTypeFilter {
  all,
  tanker,
  can20,
  bisleri,
}

enum PurchaseSort {
  latest,
  oldest,
  highestPrice,
  lowestPrice,
}

class PurchaseHistoryFilterState {
  final int? month;
  final int? year;
  final PurchaseTypeFilter type;
  final PurchaseSort sort;

  const PurchaseHistoryFilterState({
    required this.month,
    required this.year,
    required this.type,
    required this.sort,
  });

  PurchaseHistoryFilterState copyWith({
    int? month,
    int? year,
    PurchaseTypeFilter? type,
    PurchaseSort? sort,
    bool clearMonth = false,
    bool clearYear = false,
  }) {
    return PurchaseHistoryFilterState(
      month: clearMonth ? null : month ?? this.month,
      year: clearYear ? null : year ?? this.year,
      type: type ?? this.type,
      sort: sort ?? this.sort,
    );
  }

  factory PurchaseHistoryFilterState.initial() {
    return const PurchaseHistoryFilterState(
      month: null,
      year: null,
      type: PurchaseTypeFilter.all,
      sort: PurchaseSort.latest,
    );
  }
}

class PurchaseHistoryFilterNotifier
    extends StateNotifier<PurchaseHistoryFilterState> {
  PurchaseHistoryFilterNotifier()
      : super(PurchaseHistoryFilterState.initial());

  void setMonth(int? month) {
    state = state.copyWith(month: month, clearMonth: month == null);
  }

  void setYear(int? year) {
    state = state.copyWith(year: year, clearYear: year == null);
  }

  void setType(PurchaseTypeFilter type) {
    state = state.copyWith(type: type);
  }

  void setSort(PurchaseSort sort) {
    state = state.copyWith(sort: sort);
  }

  void reset() {
    state = PurchaseHistoryFilterState.initial();
  }
}

final purchaseHistoryFilterProvider = StateNotifierProvider<
    PurchaseHistoryFilterNotifier,
    PurchaseHistoryFilterState>(
  (ref) => PurchaseHistoryFilterNotifier(),
);

final purchaseHistorySearchProvider = StateProvider<String>(
  (ref) => '',
);
