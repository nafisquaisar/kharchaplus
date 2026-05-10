import 'package:flutter/material.dart';

import '../../domain/entities/MealEntry.dart';
import '../../domain/repository/food_repository.dart';



class MealEntryViewModel extends ChangeNotifier {

  final FoodRepository repository;

  MealEntryViewModel(this.repository);

  bool isLoading = false;

  String? error;

  List<MealEntry> meals = [];

  Future<void> loadMeals(
      String cycleId,
      ) async {

    try {

      isLoading = true;

      notifyListeners();

      meals = await repository.getMealEntries(
        cycleId,
      );

    } catch (e) {

      error = e.toString();

    } finally {

      isLoading = false;

      notifyListeners();

    }
  }

  Future<void> saveMeal(
      MealEntry entry,
      ) async {

    try {

      await repository.saveMealEntry(entry);

      meals.add(entry);

      notifyListeners();

    } catch (e) {

      error = e.toString();

      notifyListeners();

    }
  }
}