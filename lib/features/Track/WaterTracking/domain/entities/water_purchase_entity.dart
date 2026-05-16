import '../../../../../core/base/base_entity.dart';
import '../enum/payment_status.dart';
import '../enum/purchase_type.dart';

class WaterPurchaseEntity extends BaseEntity {
  final PurchaseType type;

  final String? customTypeName;

  final int quantity;

  final double price;

  final String? vendor;

  final PaymentStatus paymentStatus;

  final DateTime date;

  const WaterPurchaseEntity({
    required super.id,
    required super.isSynced,
    required super.isDeleted,
    required super.isEdited,
    required super.isActive,
    required super.isOfflineCreated,
    required super.version,
    required super.createdAt,
    required super.updatedAt,
    required super.userId,
    super.serverId,
    required this.type,
    this.customTypeName,
    required this.quantity,
    required this.price,
    this.vendor,
    this.paymentStatus = PaymentStatus.unpaid,
    required this.date,
  });

  String get displayTypeName {
    if (type == PurchaseType.other) {
      final value = customTypeName?.trim() ?? '';
      if (value.isNotEmpty) {
        return value;
      }
    }

    return type.label;
  }

  WaterPurchaseEntity copyWith({
    String? id,
    PurchaseType? type,
    String? customTypeName,
    int? quantity,
    double? price,
    String? vendor,
    PaymentStatus? paymentStatus,
    DateTime? date,
    bool? isSynced,
    bool? isDeleted,
    bool? isEdited,
    bool? isActive,
    bool? isOfflineCreated,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    String? serverId,
  }) {
    return WaterPurchaseEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      customTypeName: customTypeName ?? this.customTypeName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      vendor: vendor ?? this.vendor,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      date: date ?? this.date,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      isEdited: isEdited ?? this.isEdited,
      isActive: isActive ?? this.isActive,
      isOfflineCreated: isOfflineCreated ?? this.isOfflineCreated,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      serverId: serverId ?? this.serverId,
    );
  }

  factory WaterPurchaseEntity.fromJson(Map<String, dynamic> json) {
    return WaterPurchaseEntity(
      id: json['id'] as String? ?? '',
      type: PurchaseTypeX.fromName(json['type'] as String?),
      customTypeName: json['customTypeName'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      vendor: json['vendor'] as String?,
      paymentStatus: PaymentStatusX.fromValue(
        json['paymentStatus'] as String?,
      ),
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      isSynced: json['isSynced'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      isEdited: json['isEdited'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      isOfflineCreated: json['isOfflineCreated'] as bool? ?? false,
      version: (json['version'] as num?)?.toInt() ?? 1,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
      userId: json['userId'] as String? ?? '',
      serverId: json['serverId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'customTypeName': customTypeName,
      'quantity': quantity,
      'price': price,
      'vendor': vendor,
      'paymentStatus': paymentStatus.value,
      'date': date.toIso8601String(),
      'isSynced': isSynced,
      'isDeleted': isDeleted,
      'isEdited': isEdited,
      'isActive': isActive,
      'isOfflineCreated': isOfflineCreated,
      'version': version,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
      'serverId': serverId,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WaterPurchaseEntity &&
            id == other.id &&
            type == other.type &&
            customTypeName == other.customTypeName &&
            quantity == other.quantity &&
            price == other.price &&
            vendor == other.vendor &&
            paymentStatus == other.paymentStatus &&
            date == other.date &&
            isSynced == other.isSynced &&
            isDeleted == other.isDeleted &&
            isEdited == other.isEdited &&
            isActive == other.isActive &&
            isOfflineCreated == other.isOfflineCreated &&
            version == other.version &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt &&
            userId == other.userId &&
            serverId == other.serverId;
  }

  @override
  int get hashCode => Object.hash(
        id,
        type,
        customTypeName,
        quantity,
        price,
        vendor,
        paymentStatus,
        date,
        isSynced,
        isDeleted,
        isEdited,
        isActive,
        isOfflineCreated,
        version,
        createdAt,
        updatedAt,
        userId,
        serverId,
      );
}
