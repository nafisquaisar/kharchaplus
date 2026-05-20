import 'package:flutter/foundation.dart';

@immutable
class ProfileOverviewModel {
  static const String totalExpenseKey = 'totalExpense';
  static const String totalIncomeKey = 'totalIncome';
  static const String electricityUnitsKey = 'electricityUnits';
  static const String waterIntakeKey = 'waterIntake';
  static const String expenseTrendPercentKey = 'expenseTrendPercent';
  static const String incomeTrendPercentKey = 'incomeTrendPercent';
  static const String electricityTrendPercentKey = 'electricityTrendPercent';
  static const String waterTrendPercentKey = 'waterTrendPercent';
  static const String expenseIncreasedKey = 'expenseIncreased';
  static const String incomeIncreasedKey = 'incomeIncreased';
  static const String electricityIncreasedKey = 'electricityIncreased';
  static const String waterIncreasedKey = 'waterIncreased';

  final double totalExpense;
  final double totalIncome;
  final double electricityUnits;
  final double waterIntake;
  final double expenseTrendPercent;
  final double incomeTrendPercent;
  final double electricityTrendPercent;
  final double waterTrendPercent;
  final bool expenseIncreased;
  final bool incomeIncreased;
  final bool electricityIncreased;
  final bool waterIncreased;

  const ProfileOverviewModel({
    required this.totalExpense,
    required this.totalIncome,
    required this.electricityUnits,
    required this.waterIntake,
    required this.expenseTrendPercent,
    required this.incomeTrendPercent,
    required this.electricityTrendPercent,
    required this.waterTrendPercent,
    required this.expenseIncreased,
    required this.incomeIncreased,
    required this.electricityIncreased,
    required this.waterIncreased,
  });

  const ProfileOverviewModel.empty()
      : totalExpense = 0.0,
        totalIncome = 0.0,
        electricityUnits = 0.0,
        waterIntake = 0.0,
        expenseTrendPercent = 0.0,
        incomeTrendPercent = 0.0,
        electricityTrendPercent = 0.0,
        waterTrendPercent = 0.0,
        expenseIncreased = false,
        incomeIncreased = false,
        electricityIncreased = false,
        waterIncreased = false;

  factory ProfileOverviewModel.fromJson(Map<String, dynamic> json) {
    return ProfileOverviewModel(
      totalExpense: _readDouble(json[totalExpenseKey]),
      totalIncome: _readDouble(json[totalIncomeKey]),
      electricityUnits: _readDouble(json[electricityUnitsKey]),
      waterIntake: _readDouble(json[waterIntakeKey]),
      expenseTrendPercent: _readDouble(json[expenseTrendPercentKey]),
      incomeTrendPercent: _readDouble(json[incomeTrendPercentKey]),
      electricityTrendPercent: _readDouble(json[electricityTrendPercentKey]),
      waterTrendPercent: _readDouble(json[waterTrendPercentKey]),
      expenseIncreased: _readBool(json[expenseIncreasedKey]),
      incomeIncreased: _readBool(json[incomeIncreasedKey]),
      electricityIncreased: _readBool(json[electricityIncreasedKey]),
      waterIncreased: _readBool(json[waterIncreasedKey]),
    );
  }

  ProfileOverviewModel copyWith({
    double? totalExpense,
    double? totalIncome,
    double? electricityUnits,
    double? waterIntake,
    double? expenseTrendPercent,
    double? incomeTrendPercent,
    double? electricityTrendPercent,
    double? waterTrendPercent,
    bool? expenseIncreased,
    bool? incomeIncreased,
    bool? electricityIncreased,
    bool? waterIncreased,
  }) {
    return ProfileOverviewModel(
      totalExpense: totalExpense ?? this.totalExpense,
      totalIncome: totalIncome ?? this.totalIncome,
      electricityUnits: electricityUnits ?? this.electricityUnits,
      waterIntake: waterIntake ?? this.waterIntake,
      expenseTrendPercent: expenseTrendPercent ?? this.expenseTrendPercent,
      incomeTrendPercent: incomeTrendPercent ?? this.incomeTrendPercent,
      electricityTrendPercent:
          electricityTrendPercent ?? this.electricityTrendPercent,
      waterTrendPercent: waterTrendPercent ?? this.waterTrendPercent,
      expenseIncreased: expenseIncreased ?? this.expenseIncreased,
      incomeIncreased: incomeIncreased ?? this.incomeIncreased,
      electricityIncreased: electricityIncreased ?? this.electricityIncreased,
      waterIncreased: waterIncreased ?? this.waterIncreased,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      totalExpenseKey: totalExpense,
      totalIncomeKey: totalIncome,
      electricityUnitsKey: electricityUnits,
      waterIntakeKey: waterIntake,
      expenseTrendPercentKey: expenseTrendPercent,
      incomeTrendPercentKey: incomeTrendPercent,
      electricityTrendPercentKey: electricityTrendPercent,
      waterTrendPercentKey: waterTrendPercent,
      expenseIncreasedKey: expenseIncreased,
      incomeIncreasedKey: incomeIncreased,
      electricityIncreasedKey: electricityIncreased,
      waterIncreasedKey: waterIncreased,
    };
  }

  bool get isEmpty =>
      totalExpense == 0.0 &&
      totalIncome == 0.0 &&
      electricityUnits == 0.0 &&
      waterIntake == 0.0;

  static double _readDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  static bool _readBool(Object? value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }
    return false;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ProfileOverviewModel &&
            runtimeType == other.runtimeType &&
            totalExpense == other.totalExpense &&
            totalIncome == other.totalIncome &&
            electricityUnits == other.electricityUnits &&
            waterIntake == other.waterIntake &&
            expenseTrendPercent == other.expenseTrendPercent &&
            incomeTrendPercent == other.incomeTrendPercent &&
            electricityTrendPercent == other.electricityTrendPercent &&
            waterTrendPercent == other.waterTrendPercent &&
            expenseIncreased == other.expenseIncreased &&
            incomeIncreased == other.incomeIncreased &&
            electricityIncreased == other.electricityIncreased &&
            waterIncreased == other.waterIncreased;
  }

  @override
  int get hashCode => Object.hash(
        totalExpense,
        totalIncome,
        electricityUnits,
        waterIntake,
        expenseTrendPercent,
        incomeTrendPercent,
        electricityTrendPercent,
        waterTrendPercent,
        expenseIncreased,
        incomeIncreased,
        electricityIncreased,
        waterIncreased,
      );
}
