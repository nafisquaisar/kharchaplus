import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:isar/isar.dart';

import '../../domain/entities/electricity_tracking_entity.dart';

part 'electricity_tracking_model.g.dart';

@collection
class ElectricityTrackingHomeModel extends ElectricityTrackingHomeEntity {
  Id isarId = Isar.autoIncrement;

  // User id to scope local cache per authenticated user
  String userId = '';

  // soft-delete flag mirrored from remote so we can filter locally
  bool isDeleted = false;

  ElectricityTrackingHomeModel({
    required this.userId,
    required this.isDeleted,
    required super.id,
    required super.title,
    required super.startDate,
    required super.endDate,
    required super.prevUnit,
    required super.currentUnit,
    required super.rate,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ElectricityTrackingHomeModel.fromEntity(
    ElectricityTrackingHomeEntity entity,
  ) {
    return ElectricityTrackingHomeModel(
      userId: '',
      isDeleted: false,
      id: entity.id,
      title: entity.title,
      startDate: entity.startDate,
      endDate: entity.endDate,
      prevUnit: entity.prevUnit,
      currentUnit: entity.currentUnit,
      rate: entity.rate,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'startDate': firestore.Timestamp.fromDate(startDate),
      'endDate': firestore.Timestamp.fromDate(endDate),
      'prevUnit': prevUnit,
      'currentUnit': currentUnit,
      'rate': rate,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'userId': userId,
      'createdAt': firestore.Timestamp.fromDate(createdAt),
      'updatedAt': firestore.Timestamp.fromDate(updatedAt),
    };
  }

  factory ElectricityTrackingHomeModel.fromJson(
    Map<String, dynamic> json, {
    String? documentId,
    String? userId,
  }) {
    return ElectricityTrackingHomeModel(
      userId: userId ?? (json['userId'] as String?) ?? '',
      isDeleted: (json['isDeleted'] as bool?) ?? false,
      id: (json['id'] as String?) ?? documentId ?? '',
      title: (json['title'] as String?) ?? 'Electricity Bill',
      startDate: _parseDate(json['startDate']),
      endDate: _parseDate(json['endDate']),
      prevUnit: (json['prevUnit'] as num?)?.toInt() ?? 0,
      currentUnit: (json['currentUnit'] as num?)?.toInt() ?? 0,
      rate: (json['rate'] as num?)?.toDouble() ?? 0,
      isActive: (json['isActive'] as bool?) ?? true,
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

