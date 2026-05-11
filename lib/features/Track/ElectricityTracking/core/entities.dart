abstract class BaseEntity {

  final String id;

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

  const BaseEntity({
    required this.id,

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
}