import 'package:cloud_firestore/cloud_firestore.dart';

class TrackingModel {
  static const List<String> supportedTypes = <String>[
    'food',
    'water',
    'electricity',
  ];

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

  const TrackingModel({
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

  factory TrackingModel.zero(
    String type, {
    DateTime? now,
  }) {
    final normalizedType = type.toLowerCase().trim();
    final timestamp = now ?? DateTime.now();

    return TrackingModel(
      type: normalizedType,
      totalAmount: 0,
      todayAmount: 0,
      monthlyAmount: 0,
      activeCycles: 0,
      totalRecords: 0,
      isActive: true,
      progressPercent: 0,
      status: 'Active',
      iconType: _defaultIconType(normalizedType),
      categoryColor: _defaultCategoryColor(normalizedType),
      createdAt: timestamp,
      updatedAt: timestamp,
    );
  }

  factory TrackingModel.fromMap(
    String type,
    Map<String, dynamic> map,
  ) {
    final normalizedType = type.toLowerCase().trim();

    return TrackingModel(
      type: normalizedType,
      totalAmount: _asDouble(map['totalAmount']),
      todayAmount: _asDouble(map['todayAmount']),
      monthlyAmount: _asDouble(map['monthlyAmount']),
      activeCycles: _asInt(map['activeCycles']),
      totalRecords: _asInt(map['totalRecords']),
      isActive: _asBool(map['isActive'], defaultValue: true),
      progressPercent: _normalizeProgress(_asDouble(map['progressPercent'])),
      status: (map['status'] as String?)?.trim().isNotEmpty == true
          ? (map['status'] as String).trim()
          : 'Active',
      iconType: (map['iconType'] as String?)?.trim().isNotEmpty == true
          ? (map['iconType'] as String).trim().toLowerCase()
          : _defaultIconType(normalizedType),
      categoryColor:
          (map['categoryColor'] as String?)?.trim().isNotEmpty == true
              ? (map['categoryColor'] as String).trim()
              : _defaultCategoryColor(normalizedType),
      createdAt: _asDateTime(map['createdAt']) ?? DateTime.now(),
      updatedAt: _asDateTime(map['updatedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalAmount': totalAmount,
      'todayAmount': todayAmount,
      'monthlyAmount': monthlyAmount,
      'activeCycles': activeCycles,
      'totalRecords': totalRecords,
      'isActive': isActive,
      'progressPercent': _normalizeProgress(progressPercent),
      'status': status,
      'iconType': iconType,
      'categoryColor': categoryColor,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  static List<TrackingModel> mergeWithDefaults(
    List<TrackingModel> source,
  ) {
    final map = <String, TrackingModel>{
      for (final model in source) model.type.toLowerCase().trim(): model,
    };

    return supportedTypes
        .map((type) => map[type] ?? TrackingModel.zero(type))
        .toList(growable: false);
  }

  static double _asDouble(dynamic value) {
    if (value == null) {
      return 0;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }

  static int _asInt(dynamic value) {
    if (value == null) {
      return 0;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static bool _asBool(
    dynamic value, {
    required bool defaultValue,
  }) {
    if (value == null) {
      return defaultValue;
    }
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true') {
        return true;
      }
      if (normalized == 'false') {
        return false;
      }
    }
    return defaultValue;
  }

  static DateTime? _asDateTime(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static double _normalizeProgress(double value) {
    if (value.isNaN || value.isInfinite) {
      return 0;
    }
    if (value < 0) {
      return 0;
    }
    if (value > 1) {
      return 1;
    }
    return value;
  }

  static String _defaultIconType(String type) {
    switch (type) {
      case 'food':
        return 'food';
      case 'water':
        return 'water';
      case 'electricity':
        return 'electricity';
      default:
        return type;
    }
  }

  static String _defaultCategoryColor(String type) {
    switch (type) {
      case 'food':
        return '#4CAF50';
      case 'water':
        return '#2196F3';
      case 'electricity':
        return '#FFC107';
      default:
        return '#9E9E9E';
    }
  }
}
