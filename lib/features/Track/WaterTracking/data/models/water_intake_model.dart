import 'package:isar/isar.dart';

part 'water_intake_model.g.dart';

@collection
class WaterIntakeModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late int amountMl;

  @Index()
  late DateTime dateTime;

  String? sourceType;

  // =========================
  // Sync Fields
  // =========================

  late bool isSynced;

  late bool isDeleted;

  late bool isEdited;

  late bool isActive;

  late bool isOfflineCreated;

  late int version;

  late DateTime createdAt;

  late DateTime updatedAt;

  late String userId;

  String? serverId;
}
