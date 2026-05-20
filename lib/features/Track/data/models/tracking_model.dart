class TrackingModel {

  final String type;

  final double totalAmount;

  final double todayAmount;

  final double monthlyAmount;

  final int activeCycles;

  final int totalRecords;

  final bool isActive;

  final double progressPercent;

  final String status;

  final String iconType;

  final String categoryColor;

  final DateTime createdAt;

  final DateTime updatedAt;

  TrackingModel({
    required this.type,
    required this.totalAmount,
    required this.todayAmount,
    required this.monthlyAmount,
    required this.activeCycles,
    required this.totalRecords,
    required this.isActive,
    required this.progressPercent,
    required this.status,
    required this.iconType,
    required this.categoryColor,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrackingModel.fromMap(
      String type,
      Map<String, dynamic> map,
      ) {

    return TrackingModel(

      type: type,

      totalAmount:
      (map['totalAmount'] ?? 0).toDouble(),

      todayAmount:
      (map['todayAmount'] ?? 0).toDouble(),

      monthlyAmount:
      (map['monthlyAmount'] ?? 0).toDouble(),

      activeCycles:
      map['activeCycles'] ?? 0,

      totalRecords:
      map['totalRecords'] ?? 0,

      isActive:
      map['isActive'] ?? true,

      progressPercent:
      (map['progressPercent'] ?? 0).toDouble(),

      status:
      map['status'] ?? "Active",

      iconType:
      map['iconType'] ?? "",

      categoryColor:
      map['categoryColor'] ?? "",

      createdAt:
      DateTime.tryParse(
        map['createdAt'] ?? '',
      ) ??
          DateTime.now(),

      updatedAt:
      DateTime.tryParse(
        map['updatedAt'] ?? '',
      ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {

    return {

      'totalAmount': totalAmount,

      'todayAmount': todayAmount,

      'monthlyAmount': monthlyAmount,

      'activeCycles': activeCycles,

      'totalRecords': totalRecords,

      'isActive': isActive,

      'progressPercent': progressPercent,

      'status': status,

      'iconType': iconType,

      'categoryColor': categoryColor,

      'createdAt': createdAt.toIso8601String(),

      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}