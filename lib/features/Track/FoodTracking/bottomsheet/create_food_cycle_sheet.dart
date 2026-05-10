import 'package:expense_tracker/features/Track/FoodTracking/bottomsheet/services/food_cycle_sheet_service.dart';
import 'package:expense_tracker/features/Track/FoodTracking/bottomsheet/widgets/FoodBottomSheetHeader.dart';
import 'package:expense_tracker/features/Track/FoodTracking/bottomsheet/widgets/basic_details_section.dart';
import 'package:expense_tracker/features/Track/FoodTracking/bottomsheet/widgets/cycle_duration_section.dart';
import 'package:expense_tracker/features/Track/FoodTracking/bottomsheet/widgets/gradient_button.dart';
import 'package:expense_tracker/features/Track/FoodTracking/bottomsheet/widgets/meal_rules_section.dart';
import 'package:expense_tracker/features/Track/FoodTracking/bottomsheet/widgets/pricing_section.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/AppColors.dart';

import '../../../../core/utils/AppFlushbar.dart';
import '../domain/entities/FoodCycle.dart';
import '../domain/enum/SundayRule.dart';
import '../domain/enum/cycle_status.dart';

import '../presentation/viewmodel/food_cycle_viewmodel.dart';

class CreateFoodCycleSheet extends StatefulWidget {
  final FoodCycle? cycle;

  const CreateFoodCycleSheet({super.key, this.cycle});

  @override
  State<CreateFoodCycleSheet> createState() => _CreateFoodCycleSheetState();
}

class _CreateFoodCycleSheetState extends State<CreateFoodCycleSheet> {
  // =========================
  // CONTROLLERS
  // =========================

  final titleController = TextEditingController();

  final notesController = TextEditingController();

  final priceController = TextEditingController();

  final monthlyFeeController = TextEditingController();
  final monthlyAmountController = TextEditingController();

  // =========================
  // STATE
  // =========================

  DateTime? startDate;

  DateTime? endDate;

  String sundayOption = "2 Meals";

  bool includeSunday = true;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final cycle = widget.cycle;
    if (cycle != null) {
      titleController.text = cycle.title ?? "";
      notesController.text = cycle.note ?? "";
      monthlyAmountController.text = (cycle.monthlyAmount).toStringAsFixed(0);
      startDate = cycle.startDate;
      endDate = cycle.endDate;
      sundayOption = cycle.sundayRule.name == "twoMeals"
          ? "2 Meals"
          : cycle.sundayRule.name == "oneMeal"
          ? "1 Meal"
          : "Off";
    }
  }

  // =========================
  // FORMAT DATE
  // =========================

  String formatDate(DateTime date) {
    return DateFormat("d MMM yyyy").format(date);
  }

  // =========================
  // PICK DATE
  // =========================

  Future<void> pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime(2020),

      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      if (isStart) {
        startDate = picked;
      } else {
        endDate = picked;
      }
    });
  }

  // =========================
  // ERROR
  // =========================

  void showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  // =========================
  // SUBMIT
  // =========================

  Future<void> submit() async {
    FocusScope.of(context).unfocus();

    final title = titleController.text.trim();

    final monthlyAmount = double.tryParse(monthlyAmountController.text);

    final isValid = FoodCycleSheetService.validate(
      context: context,

      title: title,

      monthlyAmount: monthlyAmount,

      startDate: startDate,

      endDate: endDate,
    );

    if (!isValid) return;

    try {
      setState(() {
        isLoading = true;
      });

      final cycle = FoodCycleSheetService.buildCycle(
        oldCycle: widget.cycle,

        title: title,

        monthlyAmount: monthlyAmount!,

        startDate: startDate!,

        note: notesController.text.trim().isEmpty ? null : notesController.text.trim(),

        endDate: endDate!,

        sundayOption: sundayOption,
      );

      await FoodCycleSheetService.saveCycle(
        context: context,

        cycle: cycle,

        isEdit: widget.cycle != null,
      );

      if (!mounted) return;

      Navigator.pop(context);

      AppFlushbar.showSuccess(
        context,

        widget.cycle != null
            ? "Cycle updated successfully"
            : "Cycle created successfully",
      );
    } catch (e) {
      AppFlushbar.showError(context, e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,

      initialChildSize: 0.88,

      minChildSize: 0.65,

      maxChildSize: 0.95,

      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,

            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),

          child: Padding(
            padding: EdgeInsets.only(
              left: 20,

              right: 20,

              top: 14,

              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),

            child: ListView(
              controller: scrollController,

              physics: const BouncingScrollPhysics(),

              children: [
                // HEADER
                FoodBottomSheetHeader(

                  title: widget.cycle != null
                      ? "Update Food Cycle"
                      : "Create Food Cycle",
                ),

                const SizedBox(height: 16),

                // BASIC DETAILS
                BasicDetailsSection(
                  titleController: titleController,

                  notesController: notesController,
                ),

                const SizedBox(height: 14),

                // DURATION
                CycleDurationSection(
                  startDate: startDate,

                  endDate: endDate,

                  formatDate: formatDate,

                  onStartTap: () => pickDate(true),

                  onEndTap: () => pickDate(false),
                ),

                const SizedBox(height: 14),

                // PRICING
                PricingSection(
                  monthlyAmountController: monthlyAmountController,

                  monthlyFeeController: monthlyFeeController,
                ),

                const SizedBox(height: 14),

                // RULES
                MealRulesSection(
                  sundayOption: sundayOption,

                  onSundayChanged: (v) {
                    setState(() {
                      sundayOption = v!;
                    });
                  },
                ),

                const SizedBox(height: 28),

                // BUTTON
                GradientButton(

                  text: isLoading

                      ? widget.cycle != null
                      ? "Updating..."
                      : "Creating..."

                      : widget.cycle != null
                      ? "Update Cycle"
                      : "Create Cycle",

                  onTap: isLoading
                      ? null
                      : () async {
                    await submit();
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    titleController.dispose();

    notesController.dispose();

    priceController.dispose();

    monthlyFeeController.dispose();

    super.dispose();
  }
}
