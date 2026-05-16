import '../../domain/entities/home_dashboard_entity.dart';

class HomeState {

  final HomeDashboardEntity dashboard;

  const HomeState({
    required this.dashboard,
  });

  factory HomeState.initial() {
    return HomeState(
      dashboard: HomeDashboardEntity(
        balance: 0,
        income: 0,
        expense: 0,
        totalTransactions: 0,
        selectedDate: null,
      ),
    );
  }

  HomeState copyWith({
    HomeDashboardEntity? dashboard,
  }) {
    return HomeState(
      dashboard: dashboard ?? this.dashboard,
    );
  }
}