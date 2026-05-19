import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_tracker/features/Home/domain/entities/electricity_tracking_entity.dart';
import 'package:expense_tracker/features/Home/presentation/providers/electricity_tracking/electricity_tracking_home_providers.dart';
import 'package:expense_tracker/features/Home/presentation/widgets/electricity_tracking/electricity_tracking_card.dart';
import 'package:expense_tracker/features/Home/services/electricity_tracking_analytics_service.dart';
import 'package:expense_tracker/features/Home/domain/repository/electricity_tracking_home_repository.dart';
import 'package:expense_tracker/features/Home/domain/usecases/electricity_tracking/sync_electricity_tracking_home_usecase.dart';
import 'package:expense_tracker/features/Home/domain/usecases/electricity_tracking/watch_electricity_tracking_home_usecase.dart';
import 'package:expense_tracker/features/Home/domain/usecases/electricity_tracking/watch_remote_electricity_tracking_home_usecase.dart';
import 'package:expense_tracker/features/Home/presentation/providers/electricity_tracking/electricity_tracking_home_notifier.dart';

class _FakeElectricityHomeRepository
    implements ElectricityTrackingHomeRepository {
  final List<ElectricityTrackingHomeEntity> seed;

  _FakeElectricityHomeRepository(this.seed);

  @override
  Future<List<ElectricityTrackingHomeEntity>> getCachedCycles() async => seed;

  @override
  Stream<List<ElectricityTrackingHomeEntity>> watchCachedCycles() =>
      Stream.value(seed);

  @override
  Stream<List<ElectricityTrackingHomeEntity>> watchRemoteCycles() =>
      const Stream.empty();

  @override
  Future<void> syncCycles() async {}
}

List<ElectricityTrackingHomeEntity> _seedData() {
  return [
    ElectricityTrackingHomeEntity(
      id: '1',
      title: 'Electricity Bill',
      startDate: DateTime(2026, 3, 1),
      endDate: DateTime(2026, 3, 31),
      prevUnit: 100,
      currentUnit: 160,
      rate: 8,
      isActive: true,
      createdAt: DateTime(2026, 3, 31),
      updatedAt: DateTime(2026, 3, 31),
    ),
    ElectricityTrackingHomeEntity(
      id: '2',
      title: 'Electricity Bill',
      startDate: DateTime(2026, 4, 1),
      endDate: DateTime(2026, 4, 30),
      prevUnit: 160,
      currentUnit: 220,
      rate: 8,
      isActive: true,
      createdAt: DateTime(2026, 4, 30),
      updatedAt: DateTime(2026, 4, 30),
    ),
  ];
}

void main() {
  testWidgets('ElectricityTrackingCard renders with data', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          electricityTrackingHomeNotifierProvider
              .overrideWith((ref) {
            final repository = _FakeElectricityHomeRepository(_seedData());
            return ElectricityTrackingHomeNotifier(
              watchLocalUseCase: WatchElectricityTrackingHomeUseCase(repository),
              watchRemoteUseCase:
                  WatchRemoteElectricityTrackingHomeUseCase(repository),
              syncUseCase: SyncElectricityTrackingHomeUseCase(repository),
              analyticsService: ElectricityTrackingHomeAnalyticsService(),
            );
          }),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ElectricityTrackingCard(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Electricity Tracking'), findsOneWidget);
    expect(find.textContaining('Units'), findsOneWidget);
  });
}

