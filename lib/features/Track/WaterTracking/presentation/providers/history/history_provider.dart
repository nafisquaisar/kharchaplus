import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/providers/auth_provider.dart';
import '../../../domain/usecases/intake/add_water_intake.dart';
import '../../../domain/usecases/intake/get_intake_by_date.dart';
import '../../../domain/usecases/intake/get_intake_by_month.dart';
import '../../../domain/usecases/intake/get_intake_by_week.dart';
import '../../../domain/usecases/intake/soft_delete_water_intake.dart';
import '../../../domain/usecases/intake/update_water_intake.dart';
import '../goal/goal_provider.dart';
import '../intake/intake_provider.dart';
import 'history_notifier.dart';
import 'history_state.dart';

final historyAddWaterIntakeProvider = Provider<AddWaterIntake>(
  (ref) {
    return AddWaterIntake(
      ref.read(waterRepositoryProvider),
    );
  },
);

final historyGetIntakeByDateProvider = Provider<GetIntakeByDate>(
  (ref) {
    return GetIntakeByDate(
      ref.read(waterRepositoryProvider),
    );
  },
);

final historyGetIntakeByWeekProvider = Provider<GetIntakeByWeek>(
  (ref) {
    return GetIntakeByWeek(
      ref.read(waterRepositoryProvider),
    );
  },
);

final historyGetIntakeByMonthProvider = Provider<GetIntakeByMonth>(
  (ref) {
    return GetIntakeByMonth(
      ref.read(waterRepositoryProvider),
    );
  },
);

final historyUpdateWaterIntakeProvider = Provider<UpdateWaterIntake>(
  (ref) {
    return UpdateWaterIntake(
      ref.read(waterRepositoryProvider),
    );
  },
);

final historySoftDeleteWaterIntakeProvider = Provider<SoftDeleteWaterIntake>(
  (ref) {
    return SoftDeleteWaterIntake(
      ref.read(waterRepositoryProvider),
    );
  },
);

final historyNotifierProvider =
    StateNotifierProvider<HistoryNotifier, HistoryState>(
  (ref) {
    return HistoryNotifier(
      ref: ref,
      authService: ref.read(authServiceProvider),
      getGoalUsecase: ref.read(getGoalProvider),
      addWaterIntakeUsecase: ref.read(historyAddWaterIntakeProvider),
      getIntakeByDateUsecase: ref.read(historyGetIntakeByDateProvider),
      getIntakeByWeekUsecase: ref.read(historyGetIntakeByWeekProvider),
      getIntakeByMonthUsecase: ref.read(historyGetIntakeByMonthProvider),
      updateWaterIntakeUsecase: ref.read(historyUpdateWaterIntakeProvider),
      softDeleteWaterIntakeUsecase:
          ref.read(historySoftDeleteWaterIntakeProvider),
    );
  },
);
