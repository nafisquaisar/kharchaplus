import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:isar/isar.dart';

import '../../domain/entities/RecentActivityEntity.dart';


part 'recent_activity_model.g.dart';

@collection
class RecentActivityModel extends RecentActivityEntity {
  Id isarId = Isar.autoIncrement;

  RecentActivityModel({
    required super.id,
    required super.type,
    required super.title,
    required super.subtitle,
    required super.amount,
    required super.createdAt,
    required super.referenceId,
  });

  factory RecentActivityModel.fromEntity(
      RecentActivityEntity entity,
      ) {
    return RecentActivityModel(
      id: entity.id,
      type: entity.type,
      title: entity.title,
      subtitle: entity.subtitle,
      amount: entity.amount,
      createdAt: entity.createdAt,
      referenceId: entity.referenceId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'amount': amount,
      'createdAt': firestore.Timestamp.fromDate(createdAt),
      'referenceId': referenceId,
    };
  }

  factory RecentActivityModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final createdAtValue = json['createdAt'];

    return RecentActivityModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdAt: createdAtValue is firestore.Timestamp
          ? createdAtValue.toDate()
          : DateTime.parse(createdAtValue as String),
      referenceId: json['referenceId'] as String,
    );
  }
}