import 'package:isar/isar.dart';
import '../../domain/enum/payment_status.dart';

part 'water_purchase_model.g.dart';

@collection
class WaterPurchaseModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  // tanker
  // bisleri
  // 20L can

  late String type;

  String? customTypeName;

  late int quantity;

  late double price;

  String? vendor;

  @Index()
  String paymentStatus = PaymentStatus.unpaid.value;

  @Index()
  late DateTime date;

  // =========================
  // Sync Fields
  // =========================

  late bool isSynced;

  late bool isDeleted;

  late bool isEdited;

  late bool isActive;

  late bool isOfflineCreated;

  late int version;

  late DateTime createdAt;

  late DateTime updatedAt;

  @Index()
  late String userId;

  String? serverId;
}
