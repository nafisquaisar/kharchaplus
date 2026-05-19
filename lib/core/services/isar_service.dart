import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/Track/WaterTracking/data/models/water_goal_model.dart';
import '../../features/Track/WaterTracking/data/models/water_intake_model.dart';
import '../../features/Track/WaterTracking/data/models/water_purchase_model.dart';
import '../../features/Track/WaterTracking/data/models/water_reminder_model.dart';
import '../../features/Home/data/models/recent_activity_model.dart';
import '../../features/Home/data/models/food_tracking_model.dart';
import '../../features/Home/data/models/electricity_tracking_model.dart';
import '../../features/Home/data/models/water_tracking_model.dart';
import '../../features/Profile/data/models/profile_stats_model.dart';
import '../../features/Profile/data/models/profile_achievement_model.dart';

class IsarService {

  static late Isar isar;

  static Future<void> init() async {

    final dir =
    await getApplicationDocumentsDirectory();

    isar = await Isar.open(

      [
        RecentActivityModelSchema,
        FoodTrackingHomeModelSchema,
        ElectricityTrackingHomeModelSchema,
        WaterIntakeModelSchema,
        WaterPurchaseModelSchema,
        WaterGoalModelSchema,
        WaterReminderModelSchema,
        WaterTrackingHomeModelSchema,
        ProfileStatsModelSchema,
        ProfileAchievementModelSchema,
      ],

      directory: dir.path,

      inspector: true,
    );
  }
}