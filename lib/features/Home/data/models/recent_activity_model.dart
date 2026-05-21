import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:isar/isar.dart';

import '../../domain/entities/RecentActivityEntity.dart';

part 'recent_activity_model.g.dart';

@collection
class RecentActivityModel extends RecentActivityEntity {
  Id isarId = Isar.autoIncrement;

  RecentActivityModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.title,
    required super.subtitle,
    required super.amount,
    required super.createdAt,
    required super.updatedAt,
    required super.referenceId,
    required super.isSynced,
    required super.isDeleted,
    required super.isEdited,
    required super.version,
  });

  // =========================
  // ISAR INDEXES
  // =========================

  @Index()
  String get indexedUserId => userId;

  @Index(unique: true)
  String get indexedReferenceId => referenceId;

  @Index()
  DateTime get indexedCreatedAt => createdAt;

  @Index()
  DateTime get indexedUpdatedAt => updatedAt;

  // =========================
  // ENTITY TO MODEL
  // =========================

  factory RecentActivityModel.fromEntity(
      RecentActivityEntity entity,
      ) {
    return RecentActivityModel(
      id: entity.id,
      userId: entity.userId,
      type: entity.type,
      title: entity.title,
      subtitle: entity.subtitle,
      amount: entity.amount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      referenceId: entity.referenceId,
      isSynced: entity.isSynced,
      isDeleted: entity.isDeleted,
      isEdited: entity.isEdited,
      version: entity.version,
    );
  }

  // =========================
  // FIRESTORE JSON
  // =========================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,

      'type': type,
      'title': title,
      'subtitle': subtitle,

      'amount': amount,

      'createdAt': firestore.Timestamp.fromDate(createdAt),
      'updatedAt': firestore.Timestamp.fromDate(updatedAt),

      'referenceId': referenceId,

      'isSynced': isSynced,
      'isDeleted': isDeleted,
      'isEdited': isEdited,

      'version': version,
    };
  }

  // =========================
  // JSON TO MODEL
  // =========================

  factory RecentActivityModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final createdAtValue = json['createdAt'];
    final updatedAtValue = json['updatedAt'];

    return RecentActivityModel(
      id: json['id'] as String,

      userId: json['userId'] as String,

      type: json['type'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,

      amount: (json['amount'] as num).toDouble(),

      createdAt: createdAtValue is firestore.Timestamp
          ? createdAtValue.toDate()
          : DateTime.parse(createdAtValue as String),

      updatedAt: updatedAtValue is firestore.Timestamp
          ? updatedAtValue.toDate()
          : DateTime.parse(updatedAtValue as String),

      referenceId: json['referenceId'] as String,

      isSynced: json['isSynced'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      isEdited: json['isEdited'] as bool? ?? false,

      version: json['version'] as int? ?? 1,
    );
  }

  // =========================
  // COPY WITH
  // =========================

  RecentActivityModel copyWith({
    String? id,
    String? userId,
    String? type,
    String? title,
    String? subtitle,
    double? amount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? referenceId,
    bool? isSynced,
    bool? isDeleted,
    bool? isEdited,
    int? version,
  }) {
    return RecentActivityModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      referenceId: referenceId ?? this.referenceId,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      isEdited: isEdited ?? this.isEdited,
      version: version ?? this.version,
    )..isarId = isarId;
  }
}