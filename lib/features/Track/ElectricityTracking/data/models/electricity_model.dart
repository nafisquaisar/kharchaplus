class ElectricityModel {

  final String id;

  final String? title;

  final DateTime startDate;
  final DateTime endDate;

  final int prevUnit;
  final int currentUnit;

  final double rate;

  final bool isSynced;
  final bool isDeleted;
  final bool isEdited;
  final bool isActive;

  final bool isOfflineCreated;

  final int version;

  final DateTime createdAt;
  final DateTime updatedAt;

  final String userId;

  final String? serverId;

  const ElectricityModel({
    required this.id,

    this.title,

    required this.startDate,
    required this.endDate,

    required this.prevUnit,
    required this.currentUnit,

    required this.rate,

    required this.isSynced,
    required this.isDeleted,
    required this.isEdited,
    required this.isActive,

    required this.isOfflineCreated,

    required this.version,

    required this.createdAt,
    required this.updatedAt,

    required this.userId,

    this.serverId,
  });

  factory ElectricityModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return ElectricityModel(

      id: json['id'],

      title: json['title'],

      startDate:
      DateTime.parse(json['startDate']),

      endDate:
      DateTime.parse(json['endDate']),

      prevUnit: json['prevUnit'],

      currentUnit: json['currentUnit'],

      rate:
      (json['rate'] as num).toDouble(),

      isSynced: json['isSynced'],

      isDeleted: json['isDeleted'],

      isEdited: json['isEdited'],

      isActive: json['isActive'],

      isOfflineCreated:
      json['isOfflineCreated'],

      version: json['version'],

      createdAt:
      DateTime.parse(json['createdAt']),

      updatedAt:
      DateTime.parse(json['updatedAt']),

      userId: json['userId'],

      serverId: json['serverId'],
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'title': title,

      'startDate':
      startDate.toIso8601String(),

      'endDate':
      endDate.toIso8601String(),

      'prevUnit': prevUnit,

      'currentUnit': currentUnit,

      'rate': rate,

      'isSynced': isSynced,

      'isDeleted': isDeleted,

      'isEdited': isEdited,

      'isActive': isActive,

      'isOfflineCreated':
      isOfflineCreated,

      'version': version,

      'createdAt':
      createdAt.toIso8601String(),

      'updatedAt':
      updatedAt.toIso8601String(),

      'userId': userId,

      'serverId': serverId,
    };
  }
}