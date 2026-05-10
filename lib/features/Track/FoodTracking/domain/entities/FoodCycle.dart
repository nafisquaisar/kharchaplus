import 'package:cloud_firestore/cloud_firestore.dart';

import '../enum/SundayRule.dart';
import '../enum/cycle_status.dart';
import '../enum/sync_status.dart';

class FoodCycle {

  final String id;

  final DateTime startDate;

  final DateTime endDate;

  // PRICE OF ONE TIFFIN

  final double mealPrice;

  // TOTAL MONTHLY AMOUNT

  final double monthlyAmount;

  // EXTRA CHARGES

  final double monthlyFee;

  // TIFFIN ANALYTICS

  final int totalTiffin;

  final int totalEaten;

  final int remainingTiffin;

  // RULES

  final SundayRule sundayRule;

  final bool includeSunday;

  // STATUS

  final CycleStatus status;

  // META

  final String createdBy;

  final DateTime createdAt;

  final DateTime updatedAt;

  final String? title;
  final String? note;

  // FLAGS

  final bool isArchived;

  final bool isDeleted;

  final bool isSynced;

  final SyncStatus syncStatus;

  final int version;

  const FoodCycle({

    required this.id,

    required this.startDate,

    required this.endDate,

    required this.mealPrice,

    required this.monthlyAmount,

    required this.monthlyFee,

    required this.totalTiffin,

    required this.totalEaten,

    required this.remainingTiffin,

    required this.sundayRule,

    required this.includeSunday,

    required this.status,

    required this.createdBy,

    required this.createdAt,

    required this.updatedAt,

    this.title,
    this.note,


    this.isArchived = false,

    this.isDeleted = false,

    this.isSynced = false,

    this.syncStatus = SyncStatus.pending,

    this.version = 1,
  });

  // =========================
  // COPY WITH
  // =========================

// =========================
// COPY WITH
// =========================

  FoodCycle copyWith({

    String? id,

    DateTime? startDate,

    DateTime? endDate,

    double? mealPrice,

    double? monthlyAmount,

    double? monthlyFee,

    int? totalTiffin,

    int? totalEaten,

    int? remainingTiffin,

    SundayRule? sundayRule,

    bool? includeSunday,

    CycleStatus? status,

    String? createdBy,

    DateTime? createdAt,

    DateTime? updatedAt,

    String? title,

    String? note,

    bool? isArchived,

    bool? isDeleted,

    bool? isSynced,

    SyncStatus? syncStatus,

    int? version,
  }) {

    return FoodCycle(

      id: id ?? this.id,

      startDate:
      startDate ?? this.startDate,

      endDate:
      endDate ?? this.endDate,

      mealPrice:
      mealPrice ?? this.mealPrice,

      monthlyAmount:
      monthlyAmount ?? this.monthlyAmount,

      monthlyFee:
      monthlyFee ?? this.monthlyFee,

      totalTiffin:
      totalTiffin ?? this.totalTiffin,

      totalEaten:
      totalEaten ?? this.totalEaten,

      remainingTiffin:
      remainingTiffin ?? this.remainingTiffin,

      sundayRule:
      sundayRule ?? this.sundayRule,

      includeSunday:
      includeSunday ?? this.includeSunday,

      status:
      status ?? this.status,

      createdBy:
      createdBy ?? this.createdBy,

      createdAt:
      createdAt ?? this.createdAt,

      updatedAt:
      updatedAt ?? this.updatedAt,

      title:
      title ?? this.title,

      note:
      note ?? this.note,

      isArchived:
      isArchived ?? this.isArchived,

      isDeleted:
      isDeleted ?? this.isDeleted,

      isSynced:
      isSynced ?? this.isSynced,

      syncStatus:
      syncStatus ?? this.syncStatus,

      version:
      version ?? this.version,
    );
  }

  // =========================
  // TO MAP
  // =========================

  Map<String, dynamic> toMap() {

    return {

      "id": id,

      "startDate":
      Timestamp.fromDate(startDate),

      "endDate":
      Timestamp.fromDate(endDate),

      "mealPrice": mealPrice,

      "monthlyAmount":
      monthlyAmount,

      "monthlyFee":
      monthlyFee,

      "totalTiffin":
      totalTiffin,

      "totalEaten":
      totalEaten,

      "remainingTiffin":
      remainingTiffin,

      "sundayRule":
      sundayRule.name,

      "includeSunday":
      includeSunday,

      "status":
      status.name,

      "createdBy":
      createdBy,

      "createdAt":
      Timestamp.fromDate(createdAt),

      "updatedAt":
      Timestamp.fromDate(updatedAt),

      "title":
      title,
      "note": note,


      "isArchived":
      isArchived,

      "isDeleted":
      isDeleted,

      "isSynced":
      isSynced,

      "syncStatus":
      syncStatus.name,

      "version":
      version,
    };
  }

  // =========================
  // FROM MAP
  // =========================

  factory FoodCycle.fromMap(
      Map<String, dynamic> map,
      ) {

    return FoodCycle(

      id: map["id"],

      startDate:
      (map["startDate"]
      as Timestamp)
          .toDate(),

      endDate:
      (map["endDate"]
      as Timestamp)
          .toDate(),

      mealPrice:
      (map["mealPrice"]
      as num)
          .toDouble(),

      monthlyAmount:
      (map["monthlyAmount"]
      as num)
          .toDouble(),

      monthlyFee:
      (map["monthlyFee"]
      as num)
          .toDouble(),

      totalTiffin:
      map["totalTiffin"] ?? 0,

      totalEaten:
      map["totalEaten"] ?? 0,

      remainingTiffin:
      map["remainingTiffin"] ?? 0,

      sundayRule:
      SundayRule.values.firstWhere(

            (e) =>
        e.name ==
            map["sundayRule"],
      ),

      includeSunday:
      map["includeSunday"],

      status:
      CycleStatus.values.firstWhere(

            (e) =>
        e.name ==
            map["status"],
      ),

      createdBy:
      map["createdBy"],

      createdAt:
      (map["createdAt"]
      as Timestamp)
          .toDate(),

      updatedAt:
      (map["updatedAt"]
      as Timestamp)
          .toDate(),

      title:
      map["title"],

      note: map["note"],

      isArchived:
      map["isArchived"] ?? false,

      isDeleted:
      map["isDeleted"] ?? false,

      isSynced:
      map["isSynced"] ?? false,

      syncStatus:
      SyncStatus.values.firstWhere(

            (e) =>
        e.name ==
            map["syncStatus"],

        orElse:
            () =>
        SyncStatus.pending,
      ),

      version:
      map["version"] ?? 1,
    );
  }
}