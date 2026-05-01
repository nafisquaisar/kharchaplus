class FriendModel {
  final String id;
  final String name;
  final double amount;
  final String type; // "owe" or "get"
  final String status; // "pending" or "paid"

  FriendModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.type,
    required this.status,
  });
}