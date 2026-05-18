class RecentActivityEntity {
  final String id;
  final String type;
  final String title;
  final String subtitle;
  final double amount;
  final DateTime createdAt;
  final String referenceId;

  const RecentActivityEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.createdAt,
    required this.referenceId,
  });
}