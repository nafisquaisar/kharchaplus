class RecentActivityEntity {

  final String id;
  final String userId;

  final String type;
  final String title;
  final String subtitle;

  final double amount;

  final DateTime createdAt;
  final DateTime updatedAt;

  final String referenceId;

  final bool isSynced;
  final bool isDeleted;
  final bool isEdited;

  final int version;

  const RecentActivityEntity({
    required this.id,
    required this.userId,

    required this.type,
    required this.title,
    required this.subtitle,

    required this.amount,

    required this.createdAt,
    required this.updatedAt,

    required this.referenceId,

    required this.isSynced,
    required this.isDeleted,
    required this.isEdited,

    required this.version,
  });
}