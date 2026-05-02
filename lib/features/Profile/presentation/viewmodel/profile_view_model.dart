import 'package:flutter/material.dart';
import '../../domain/usecase/get_profile_data.dart';

class ProfileViewModel extends ChangeNotifier {
  final GetProfileData getProfileData;

  ProfileViewModel(this.getProfileData);

  String name = "";
  String email = "";

  int totalExpense = 0;
  int foodExpense = 0;
  int waterAvg = 0;
  int waterToday = 0;
  int streak = 0;

  int mealsCount = 0;
  int messExpense = 0;
  int outsideExpense = 0;

  String insight = "You are doing great 🎉";
  String plan = "Free";

  bool isLoading = false;

  Future<void> loadProfile() async {
    isLoading = true;
    notifyListeners();

    final data = await getProfileData();

    name = data["name"] ?? "";
    email = data["email"] ?? "";

    totalExpense = data["totalExpense"] ?? 0;
    foodExpense = data["foodExpense"] ?? 0;

    waterAvg = data["waterAvg"] ?? 0;
    waterToday = data["waterToday"] ?? 0;

    mealsCount = data["meals"] ?? 0;
    messExpense = data["messExpense"] ?? 0;
    outsideExpense = data["outsideExpense"] ?? 0;

    streak = data["streak"] ?? 0;
    insight = data["insight"] ?? "";

    plan = data["plan"] ?? "Free";

    isLoading = false;
    notifyListeners();
  }

  void logout() {}
  void deleteAccount() {}
}