import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../../../../../core/services/auth_service.dart';
import '../../../../Track/WaterTracking/data/models/water_goal_model.dart';
import '../../../../Track/WaterTracking/data/models/water_intake_model.dart';
import '../../../../Track/WaterTracking/data/models/water_purchase_model.dart';
import '../../../../Track/WaterTracking/data/repository/water_repository_impl.dart';
import '../../models/water_tracking_model.dart';
import '../../../services/water_tracking_home_analytics_service.dart';

abstract class WaterTrackingHomeRemoteDataSource {
  Future<WaterTrackingHomeModel?> buildSnapshot();

  Stream<WaterTrackingHomeModel?> watchSnapshot();
}

class WaterTrackingHomeRemoteDataSourceImpl
    implements WaterTrackingHomeRemoteDataSource {
  final WaterRepositoryImpl waterRepository;
  final WaterTrackingHomeAnalyticsService analyticsService;
  final AuthService authService;
  final Isar isar;

  WaterTrackingHomeRemoteDataSourceImpl({
    required this.waterRepository,
    required this.analyticsService,
    required this.authService,
    required this.isar,
  });

  @override
  Future<WaterTrackingHomeModel?> buildSnapshot() async {
    final userId = await authService.getCurrentUserId();

    final todayIntake = await waterRepository.getTodayIntake();
    final weeklyIntake = await waterRepository.getWeeklyIntake();
    final monthlyIntake = await waterRepository.getMonthlyIntake();
    final purchases = await waterRepository.getPurchases();
    final goal = await waterRepository.getGoal();

    debugPrint(
      '[WaterHomeRemote] intake fetched today=${todayIntake.length} weekly=${weeklyIntake.length} monthly=${monthlyIntake.length}',
    );
    debugPrint('[WaterHomeRemote] purchases fetched count=${purchases.length}');
    debugPrint('[WaterHomeRemote] daily goal calculated ml=${goal?.dailyGoalMl ?? 0}');

    final snapshot = analyticsService.buildSnapshot(
      userId: userId,
      todayIntake: todayIntake,
      weeklyIntake: weeklyIntake,
      monthlyIntake: monthlyIntake,
      purchases: purchases,
      goal: goal,
    );

    debugPrint('[WaterHomeRemote] snapshot built user=$userId');
    return snapshot;
  }

  @override
  Stream<WaterTrackingHomeModel?> watchSnapshot() {
    final controller = StreamController<WaterTrackingHomeModel?>();
    final subscriptions = <StreamSubscription<void>>[];

    Future<void> emitSnapshot() async {
      try {
        final snapshot = await buildSnapshot();
        controller.add(snapshot);
        debugPrint('[WaterHomeRemote] snapshot stream update');
      } catch (e, stack) {
        debugPrint('[WaterHomeRemote] snapshot build failed $e');
        debugPrint('$stack');
        controller.addError(e, stack);
      }
    }

    void bind(Stream<void> stream) {
      subscriptions.add(stream.listen((_) => emitSnapshot()));
    }

    bind(isar.waterIntakeModels.watchLazy(fireImmediately: true));
    bind(isar.waterPurchaseModels.watchLazy(fireImmediately: true));
    bind(isar.waterGoalModels.watchLazy(fireImmediately: true));

    controller.onCancel = () {
      for (final sub in subscriptions) {
        sub.cancel();
      }
    };

    return controller.stream;
  }
}
