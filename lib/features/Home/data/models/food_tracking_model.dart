import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:isar/isar.dart';

import '../../domain/entities/food_tracking_entity.dart';

part 'food_tracking_model.g.dart';

@collection
class FoodTrackingHomeModel extends FoodTrackingHomeEntity {
  Id isarId = Isar.autoIncrement;

  // User id to scope local cache per authenticated user
  String userId = '';

  // soft-delete flag mirrored from remote so we can filter locally
  bool isDeleted = false;

  FoodTrackingHomeModel({
    required this.userId,
    required this.isDeleted,
    required super.id,
    required super.title,
    required super.totalTiffin,
    required super.totalEaten,
    required super.remainingTiffin,
    required super.monthlyAmount,
    required super.mealPrice,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory FoodTrackingHomeModel.fromEntity(
    FoodTrackingHomeEntity entity,
  ) {
    return FoodTrackingHomeModel(
      userId: '',
      isDeleted: false,
      id: entity.id,
      title: entity.title,
      totalTiffin: entity.totalTiffin,
      totalEaten: entity.totalEaten,
      remainingTiffin: entity.remainingTiffin,
      monthlyAmount: entity.monthlyAmount,
      mealPrice: entity.mealPrice,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'totalTiffin': totalTiffin,
      'totalEaten': totalEaten,
      'remainingTiffin': remainingTiffin,
      'monthlyAmount': monthlyAmount,
      'mealPrice': mealPrice,
      'status': status,
      'isDeleted': isDeleted,
      'userId': userId,
      'createdAt': firestore.Timestamp.fromDate(createdAt),
      'updatedAt': firestore.Timestamp.fromDate(updatedAt),
    };
  }

  factory FoodTrackingHomeModel.fromJson(
    Map<String, dynamic> json, {
    String? documentId,
    String? userId,
  }) {
    return FoodTrackingHomeModel(
      userId: userId ?? (json['userId'] as String?) ?? '',
      isDeleted: (json['isDeleted'] as bool?) ?? false,
      id: (json['id'] as String?) ?? documentId ?? '',
      title: (json['title'] as String?) ?? 'Untitled Mess',
      totalTiffin: (json['totalTiffin'] as num?)?.toInt() ?? 0,
      totalEaten: (json['totalEaten'] as num?)?.toInt() ?? 0,
      remainingTiffin: (json['remainingTiffin'] as num?)?.toInt() ?? 0,
      monthlyAmount: (json['monthlyAmount'] as num?)?.toDouble() ?? 0,
      mealPrice: (json['mealPrice'] as num?)?.toDouble() ?? 0,
      status: (json['status'] as String?) ?? 'active',
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is firestore.Timestamp) {
      return value.toDate();
    }
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    if (value is DateTime) {
      return value;
    }
    return DateTime.now();
  }
}

