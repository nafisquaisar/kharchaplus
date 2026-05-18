import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/AppFlushbar.dart';

import '../../domain/entities/FoodCycle.dart';

import '../../domain/enum/SundayRule.dart';
import '../../domain/enum/cycle_status.dart';

import '../../domain/enum/sync_status.dart';
import '../../presentation/viewmodel/food_cycle_viewmodel.dart';

class FoodCycleSheetService {
  // =========================
  // VALIDATION
  // =========================

  static bool validate({
    required BuildContext context,

    required String title,

    required double? monthlyAmount,

    required DateTime? startDate,

    required DateTime? endDate,
  }) {
    if (title.trim().isEmpty) {
      AppFlushbar.showError(context, "Please enter cycle title");

      return false;
    }

    if (monthlyAmount == null || monthlyAmount <= 0) {
      AppFlushbar.showError(context, "Please enter valid amount");

      return false;
    }

    if (startDate == null) {
      AppFlushbar.showError(context, "Please select start date");

      return false;
    }

    if (endDate == null) {
      AppFlushbar.showError(context, "Please select end date");

      return false;
    }

    if (endDate.isBefore(startDate)) {
      AppFlushbar.showError(context, "End date cannot be before start date");

      return false;
    }

    return true;
  }

  // =========================
  // MONTHLY DAY COUNT
  // =========================

  static int getMealDays(String sundayOption) {
    switch (sundayOption) {
      case "2 Meals":
        return 60;

      case "1 Meal":
        return 56;

      case "Off":
        return 52;

      default:
        return 60;
    }
  }

  // =========================
  // TOTAL TIFFIN COUNT
  // =========================

  static int getTotalTiffin(String sundayOption) {
    switch (sundayOption) {
      case "2 Meals":
        return 60;

      case "1 Meal":
        return 56;

      case "Off":
        return 52;

      default:
        return 60;
    }
  }

  // =========================
  // CREATE MODEL
  // =========================

  static FoodCycle buildCycle({
    required FoodCycle? oldCycle,

    required String title,

    required double monthlyAmount,

    required DateTime startDate,

    required DateTime endDate,
    required String? note,

    required String sundayOption,
  }) {
    final mealDays = getMealDays(sundayOption);

    final totalTiffin = getTotalTiffin(sundayOption);

    final mealPrice = monthlyAmount / mealDays;

    return FoodCycle(
      id: oldCycle?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      note: note,
      startDate: startDate,
      endDate: endDate,
      // PRICE
      mealPrice: mealPrice,
      monthlyAmount: monthlyAmount,

      monthlyFee: oldCycle?.monthlyFee ?? 0,

      // TIFFIN STATS
      totalTiffin: totalTiffin,

      totalEaten: oldCycle?.totalEaten ?? 0,

      remainingTiffin: totalTiffin - (oldCycle?.totalEaten ?? 0),

      // RULES
      sundayRule: sundayOption == "2 Meals"
          ? SundayRule.twoMeals
          : sundayOption == "1 Meal"
          ? SundayRule.oneMeal
          : SundayRule.off,

      includeSunday: sundayOption != "Off",

      // STATUS
      status: oldCycle?.status ?? CycleStatus.active,

      // META
      createdBy:
      oldCycle?.createdBy ??
          FirebaseAuth.instance.currentUser!.uid,

      createdAt: oldCycle?.createdAt ?? DateTime.now(),

      updatedAt: DateTime.now(),

      // FLAGS
      isArchived: oldCycle?.isArchived ?? false,

      isDeleted: oldCycle?.isDeleted ?? false,

      isSynced: oldCycle?.isSynced ?? false,

      syncStatus: oldCycle?.syncStatus ?? SyncStatus.pending,

      version: oldCycle?.version ?? 1,
    );
  }

  // =========================
  // SAVE
  // =========================

  static Future<void> saveCycle({
    required FoodCycleViewModel vm,

    required FoodCycle cycle,

    required bool isEdit,
  }) async {
    if (isEdit) {
      await vm.updateCycle(cycle);
    } else {
      await vm.createCycle(cycle);
    }
  }

  // =========================
  // DATE PICKER
  // =========================

  static Future<DateTime?> pickDate(BuildContext context) async {
    return await showDatePicker(
      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime(2020),

      lastDate: DateTime(2100),
    );
  }

  // =========================
  // FORMAT DATE
  // =========================

  static String formatDate(DateTime date) {
    return "${date.day}/"
        "${date.month}/"
        "${date.year}";
  }
}
