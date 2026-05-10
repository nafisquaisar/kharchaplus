import 'package:cloud_firestore/cloud_firestore.dart';

import '../enum/meal_type.dart';
import '../enum/sync_status.dart';

class MealEntry {

  final String id;

  final String cycleId;

  final DateTime date;

  final bool breakfast;
  final bool lunch;
  final bool dinner;

  final bool skipped;

  final double extraCharge;

  final String? note;

  final MealType? extraMealType;

  final DateTime createdAt;
  final DateTime updatedAt;

  final bool isDeleted;

  final bool isSynced;

  final SyncStatus syncStatus;

  final int version;

  MealEntry({
    required this.id,
    required this.cycleId,
    required this.date,
    this.breakfast = false,
    this.lunch = false,
    this.dinner = false,
    this.skipped = false,
    this.extraCharge = 0,
    this.note,
    this.extraMealType,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.isSynced = false,
    this.syncStatus = SyncStatus.pending,
    this.version = 1,
  });

  // =========================
  // COPY WITH
  // =========================

  MealEntry copyWith({
    String? id,
    String? cycleId,
    DateTime? date,
    bool? breakfast,
    bool? lunch,
    bool? dinner,
    bool? skipped,
    double? extraCharge,
    String? note,
    MealType? extraMealType,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    bool? isSynced,
    SyncStatus? syncStatus,
    int? version,
  }) {

    return MealEntry(

      id: id ?? this.id,

      cycleId: cycleId ?? this.cycleId,

      date: date ?? this.date,

      breakfast: breakfast ?? this.breakfast,

      lunch: lunch ?? this.lunch,

      dinner: dinner ?? this.dinner,

      skipped: skipped ?? this.skipped,

      extraCharge: extraCharge ?? this.extraCharge,

      note: note ?? this.note,

      extraMealType:
      extraMealType ?? this.extraMealType,

      createdAt: createdAt ?? this.createdAt,

      updatedAt: updatedAt ?? this.updatedAt,

      isDeleted: isDeleted ?? this.isDeleted,

      isSynced: isSynced ?? this.isSynced,

      syncStatus: syncStatus ?? this.syncStatus,

      version: version ?? this.version,
    );
  }

  // =========================
  // TO MAP
  // =========================

  Map<String, dynamic> toMap() {

    return {

      "id": id,

      "cycleId": cycleId,

      "date": Timestamp.fromDate(date),

      "breakfast": breakfast,

      "lunch": lunch,

      "dinner": dinner,

      "skipped": skipped,

      "extraCharge": extraCharge,

      "note": note,

      "extraMealType": extraMealType?.name,

      "createdAt":
      Timestamp.fromDate(createdAt),

      "updatedAt":
      Timestamp.fromDate(updatedAt),

      "isDeleted": isDeleted,

      "isSynced": isSynced,

      "syncStatus": syncStatus.name,

      "version": version,
    };
  }

  // =========================
  // FROM MAP
  // =========================

  factory MealEntry.fromMap(
      Map<String, dynamic> map,
      ) {

    return MealEntry(

      id: map["id"],

      cycleId: map["cycleId"],

      date:
      (map["date"] as Timestamp).toDate(),

      breakfast: map["breakfast"] ?? false,

      lunch: map["lunch"] ?? false,

      dinner: map["dinner"] ?? false,

      skipped: map["skipped"] ?? false,

      extraCharge:
      (map["extraCharge"] as num?)?.toDouble() ?? 0,

      note: map["note"],

      extraMealType:
      map["extraMealType"] != null
          ? MealType.values.firstWhere(
            (e) =>
        e.name == map["extraMealType"],
      )
          : null,

      createdAt:
      (map["createdAt"] as Timestamp).toDate(),

      updatedAt:
      (map["updatedAt"] as Timestamp).toDate(),

      isDeleted: map["isDeleted"] ?? false,

      isSynced: map["isSynced"] ?? false,

      syncStatus: SyncStatus.values.firstWhere(
            (e) => e.name == map["syncStatus"],
        orElse: () => SyncStatus.pending,
      ),

      version: map["version"] ?? 1,
    );
  }
}