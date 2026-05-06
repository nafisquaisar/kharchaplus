import 'dart:convert';

class CategoryModel {
  final String id;
  final String name;

  final String icon; // icon name or asset path
  final int color; // store as hex (e.g. 0xFF00FF)

  final bool isDefault;
  final bool isDeleted;

  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.isDefault = true,
    this.isDeleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // 🔁 CopyWith
  CategoryModel copyWith({
    String? id,
    String? name,
    String? icon,
    int? color,
    bool? isDefault,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isDefault: isDefault ?? this.isDefault,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // 🔄 JSON → Object
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      color: json['color'],
      isDefault: json['isDefault'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // 🔄 Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'isDefault': isDefault,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // 🔁 Encode / Decode list
  static String encode(List<CategoryModel> categories) =>
      json.encode(categories.map((e) => e.toJson()).toList());

  static List<CategoryModel> decode(String categories) =>
      (json.decode(categories) as List<dynamic>)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
}
