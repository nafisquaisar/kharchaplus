import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/Track/WaterTracking/data/models/water_goal_model.dart';
import '../../features/Track/WaterTracking/data/models/water_intake_model.dart';
import '../../features/Track/WaterTracking/data/models/water_purchase_model.dart';
import '../../features/Track/WaterTracking/data/models/water_reminder_model.dart';

class IsarService {

  static late Isar isar;

  static Future<void> init() async {

    final dir =
    await getApplicationDocumentsDirectory();

    isar = await Isar.open(

      [
        WaterIntakeModelSchema,
        WaterPurchaseModelSchema,
        WaterGoalModelSchema,
        WaterReminderModelSchema,
      ],

      directory: dir.path,

      inspector: true,
    );
  }
}