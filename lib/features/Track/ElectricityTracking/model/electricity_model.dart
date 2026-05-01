import 'package:intl/intl.dart';

class ElectricityModel {
  final String id;
  final String? title; // ✅ optional custom title
  final DateTime startDate;
  final DateTime endDate;
  final int prevUnit;
  final int currentUnit;
  final double rate;

  ElectricityModel({
    required this.id,
    this.title,
    required this.startDate,
    required this.endDate,
    required this.prevUnit,
    required this.currentUnit,
    required this.rate,
  });

  // 🔥 SAFE CONSUMPTION
  int get consumed => (currentUnit - prevUnit) < 0
      ? 0
      : (currentUnit - prevUnit);

  double get total => consumed * rate;

  // 🔥 DATE FORMAT
  String get formattedRange {
    final f = DateFormat("d MMM yyyy");
    return "${f.format(startDate)} - ${f.format(endDate)}";
  }

  // 🔥 FINAL TITLE
  String get displayTitle {
    return (title != null && title!.isNotEmpty)
        ? title!
        : formattedRange;
  }
}