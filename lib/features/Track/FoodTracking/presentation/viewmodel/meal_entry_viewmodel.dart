import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/AppFlushbar.dart';
import '../../domain/entities/FoodCycle.dart';
import '../../domain/entities/MealEntry.dart';

import '../../domain/enum/meal_type.dart';
import '../../domain/repository/MealRepository.dart';
import '../../services/meal_mapper_service.dart';
import '../../services/meal_summary_service.dart';
import '../widgets/food_tracking_detail_widgets/meal_date_key.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../Home/domain/entities/RecentActivityEntity.dart';
import '../../../../Home/domain/usecases/recent/add_recent_activity_usecase.dart';
import '../../../../Home/domain/usecases/recent/delete_recent_activity_usecase.dart';
import '../../../../Home/domain/usecases/recent/update_recent_activity_usecase.dart';

class MealEntryViewModel extends ChangeNotifier {
  final MealRepository repository;
  final AddRecentActivityUseCase addRecentActivityUseCase;
  final UpdateRecentActivityUseCase updateRecentActivityUseCase;
  final DeleteRecentActivityUseCase deleteRecentActivityUseCase;

  MealEntryViewModel(
    this.repository, {
    required this.addRecentActivityUseCase,
    required this.updateRecentActivityUseCase,
    required this.deleteRecentActivityUseCase,
  });

  // =========================
  // STATE
  // =========================

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  final List<MealEntry> _meals = [];

  List<MealEntry> get meals => List.unmodifiable(_meals);

  late DateTime _selectedDate;

  DateTime get selectedDate => _selectedDate;

  FoodCycle? _cycle;

  String get cycleTitle => _cycle?.title ?? "Food Tracking";

  int get totalMeals => MealSummaryService.totalMeals(_meals);

  int get lunchCount => MealSummaryService.lunchCount(_meals);

  int get dinnerCount => MealSummaryService.dinnerCount(_meals);

  int get specialCount => MealSummaryService.specialCount(_meals);

  double get totalCost {
    if (_cycle == null) {
      return 0;
    }

    return MealSummaryService.totalCost(
      meals: _meals,

      mealPrice: _cycle!.mealPrice,
    );
  }

  int get remainingMeals {
    if (_cycle == null) {
      return 0;
    }

    return MealSummaryService.remainingMeals(
      totalMeals: totalMeals,

      totalTiffin: _cycle!.totalTiffin,
    );
  }

  Map<String, Map<String, bool>> get calendarData =>
      MealMapperService.buildCalendarData(_meals);

  Future<void> initialize(
      FoodCycle cycle,
      ) async {

    try {

      _isLoading = true;

      notifyListeners();

      _cycle = cycle;

      // =========================
      // NORMALIZED DATES
      // =========================

      final today = normalizeDate(
        DateTime.now(),
      );

      final start = normalizeDate(
        cycle.startDate,
      );

      final end = normalizeDate(
        cycle.endDate,
      );

      // =========================
      // AUTO SELECT DATE
      // =========================

      if (!today.isBefore(start) &&
          !today.isAfter(end)) {

        // TODAY INSIDE RANGE

        _selectedDate = today;
      }

      else if (today.isBefore(start)) {

        // BEFORE CYCLE

        _selectedDate = start;
      }

      else {

        // AFTER CYCLE

        _selectedDate = end;
      }

      // =========================
      // LOAD MEALS
      // =========================

      await loadMeals(cycle.id);

    } catch (e) {

      _error = e.toString();
    }

    finally {

      _isLoading = false;

      notifyListeners();
    }
  }

  // =========================
  // SELECT DATE
  // =========================

  void selectDate(DateTime date) {
    _selectedDate = date;

    notifyListeners();
  }

  // =========================
  // LOAD MEALS
  // =========================

  Future<void> loadMeals(String cycleId) async {
    try {
      _setLoading(true);

      _error = null;

      final response = await repository.getMealEntries(cycleId);

      _meals
        ..clear()
        ..addAll(response);

      notifyListeners();
    } catch (e) {
      _error = e.toString();

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // TOGGLE LUNCH
  // =========================

  Future<void> toggleLunch({
    required String cycleId,

    required DateTime date,
  }) async {
    try {
      final existing = _findMeal(cycleId, date);

      final updated = existing != null
          ? existing.copyWith(lunch: !existing.lunch, updatedAt: DateTime.now())
          : MealEntry(
              id: _entryId(cycleId, date),

              cycleId: cycleId,

              date: date,

              lunch: true,

              dinner: false,

              breakfast: false,

              skipped: false,

              createdAt: DateTime.now(),

              updatedAt: DateTime.now(),
            );

      await _saveMeal(updated);
    } catch (e) {
      _error = e.toString();

      notifyListeners();
    }
  }

  // =========================
  // TOGGLE DINNER
  // =========================

  Future<void> toggleDinner({
    required String cycleId,

    required DateTime date,
  }) async {
    try {
      final existing = _findMeal(cycleId, date);

      final updated = existing != null
          ? existing.copyWith(
              dinner: !existing.dinner,

              updatedAt: DateTime.now(),
            )
          : MealEntry(
              id: _entryId(cycleId, date),

              cycleId: cycleId,

              date: date,

              lunch: false,

              dinner: true,

              breakfast: false,

              skipped: false,

              createdAt: DateTime.now(),

              updatedAt: DateTime.now(),
            );

      await _saveMeal(updated);
    } catch (e) {
      _error = e.toString();

      notifyListeners();
    }
  }

  // =========================
  // SPECIAL THALI
  // =========================

  Future<void> toggleSpecialThali({

    required String cycleId,

    required DateTime date,
  }) async {

    try {

      final existing =
      _findMeal(
        cycleId,
        date,
      );

      final isSpecial =

          existing?.extraMealType ==
              MealType.specialThali;

      MealEntry updated;

      // =========================
      // CREATE NEW
      // =========================

      if (existing == null) {

        updated = MealEntry(

          id: _entryId(
            cycleId,
            date,
          ),

          cycleId: cycleId,

          date: date,

          // ✅ auto lunch included
          lunch: true,

          dinner: false,

          breakfast: false,

          skipped: false,

          extraMealType:
          MealType.specialThali,

          createdAt:
          DateTime.now(),

          updatedAt:
          DateTime.now(),
        );
      }

      // =========================
      // TOGGLE
      // =========================

      else {

        updated = existing.copyWith(

          // ✅ REMOVE / ADD SPECIAL
          extraMealType:

          isSpecial
              ? null
              : MealType.specialThali,

          // ✅ IMPORTANT FIX
          clearExtraMealType:
          isSpecial,

          updatedAt:
          DateTime.now(),
        );
      }

      await _saveMeal(updated);

    } catch (e) {

      _error = e.toString();

      notifyListeners();
    }
  }
  // =========================
  // UPDATE NOTE
  // =========================

  Future<void> updateNote({
    required String cycleId,

    required DateTime date,

    required String note,
  }) async {
    try {
      final existing = _findMeal(cycleId, date);

      final updated = existing != null
          ? existing.copyWith(note: note, updatedAt: DateTime.now())
          : MealEntry(
              id: _entryId(cycleId, date),

              cycleId: cycleId,

              date: date,

              note: note,

              createdAt: DateTime.now(),

              updatedAt: DateTime.now(),
            );

      await _saveMeal(updated);
    } catch (e) {
      _error = e.toString();

      notifyListeners();
    }
  }

  // =========================
  // SAVE INTERNAL
  // =========================

  Future<void> _saveMeal(MealEntry entry) async {
    final existed = _meals.any((e) => e.id == entry.id);

    await repository.saveMealEntry(entry);

    final index = _meals.indexWhere((e) => e.id == entry.id);

    if (index != -1) {
      _meals[index] = entry;
    } else {
      _meals.add(entry);
    }

    notifyListeners();

    await _syncRecentActivity(
      entry: entry,
      isUpdate: existed,
    );
  }

  Future<void> deleteMealEntry(
      MealEntry entry,
      ) async {
    final previousMeals = List<MealEntry>.from(_meals);

    try {
      _meals.removeWhere((e) => e.id == entry.id);
      notifyListeners();

      debugPrint('[Food] recent activity delete referenceId=${entry.id}');
      await deleteRecentActivityUseCase.call(entry.id);

      await repository.deleteMealEntry(entry.cycleId, entry.id);
    } catch (e) {
      _meals
        ..clear()
        ..addAll(previousMeals);
      notifyListeners();
      debugPrint('[Food] delete failed: $e');
      rethrow;
    }
  }

  Future<void> _syncRecentActivity({
    required MealEntry entry,
    required bool isUpdate,
  }) async {

    final cycleTitle = _cycle?.title ?? 'Food Cycle';
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final dateLabel = AppFormatters.date(
      entry.date,
    );

    final mealCount =
        (entry.breakfast ? 1 : 0) +
            (entry.lunch ? 1 : 0) +
            (entry.dinner ? 1 : 0);

    final mealPrice = _cycle?.mealPrice ?? 0;

    final amount =
        (mealPrice * mealCount) +
            entry.extraCharge;

    final recent = RecentActivityEntity(
      id: entry.id,

      userId: userId,

      type: 'food',

      title: isUpdate
          ? 'Food Cycle Updated'
          : 'Food Cycle Added',

      subtitle: '$cycleTitle • $dateLabel',

      amount: amount,

      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,

      referenceId: entry.id,

      isSynced: false,
      isDeleted: false,
      isEdited: isUpdate,

      version: entry.version,
    );

    if (isUpdate) {

      debugPrint(
        '[Food] recent activity updated referenceId=${entry.id}',
      );

      await updateRecentActivityUseCase.call(recent);

    } else {

      debugPrint(
        '[Food] recent activity added referenceId=${entry.id}',
      );

      await addRecentActivityUseCase.call(recent);
    }
  }

  // =========================
  // HELPERS
  // =========================

  void _setLoading(bool value) {
    _isLoading = value;

    notifyListeners();
  }

  MealEntry? _findMeal(String cycleId, DateTime date) {
    try {
      return _meals.firstWhere(
        (e) =>
            e.cycleId == cycleId &&
            e.date.year == date.year &&
            e.date.month == date.month &&
            e.date.day == date.day,
      );
    } catch (_) {
      return null;
    }
  }

  String _entryId(String cycleId, DateTime date) {
    return "${cycleId}_"
        "${date.year}_"
        "${date.month}_"
        "${date.day}";
  }


  Future<void> toggleMeal({
    required BuildContext context,

    required String cycleId,

    required DateTime date,

    required String type,
  }) async {
    final existing = _findMeal(cycleId, date);

    // =========================
    // TIFFIN LIMIT CHECK
    // =========================

    final isTurningOn =
        (type == "lunch" && !(existing?.lunch ?? false)) ||
        (type == "dinner" && !(existing?.dinner ?? false));

    if (isTurningOn && remainingMeals <= 0) {
      AppFlushbar.showError(context, "Your tiffin quota has ended 🍱");

      return;
    }

    switch (type) {
      case "lunch":
        await toggleLunch(cycleId: cycleId, date: date);

        break;

      case "dinner":
        await toggleDinner(cycleId: cycleId, date: date);

        break;

      case "special":
        await toggleSpecialThali(cycleId: cycleId, date: date);

        break;
    }
  }
  // =========================
  // CLEAR ERROR
  // =========================

  void clearError() {
    _error = null;

    notifyListeners();
  }
}
