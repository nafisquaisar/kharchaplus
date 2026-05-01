import 'package:flutter/material.dart';
import '../../domain/usecase/get_profile_data.dart';

class ProfileViewModel extends ChangeNotifier {
  final GetProfileData getProfileData;

  ProfileViewModel(this.getProfileData);

  String name = "";
  String email = "";

  int pending = 0;
  int overdue = 0;
  int completed = 0;
  int streak = 0;

  bool isLoading = false;

  Future<void> loadProfile() async {
    isLoading = true;
    notifyListeners();

    final data = await getProfileData();

    name = data["name"];
    email = data["email"];
    pending = data["pending"];
    overdue = data["overdue"];
    completed = data["completed"];
    streak = data["streak"];

    isLoading = false;
    notifyListeners();
  }

  void logout() {}
  void deleteAccount() {}
}