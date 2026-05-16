import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/home_dashboard_entity.dart';
import 'home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {

  HomeNotifier() : super(HomeState.initial());

  Future<void> loadDashboard() async {

    final dashboard = HomeDashboardEntity(
      balance: 50000,
      income: 80000,
      expense: 30000,
      totalTransactions: 25,
      selectedDate: DateTime.now(),
    );

    state = state.copyWith(
      dashboard: dashboard,
    );
  }
}