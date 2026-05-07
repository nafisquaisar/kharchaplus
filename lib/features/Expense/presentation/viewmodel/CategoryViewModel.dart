import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/dummy/predefined_categories.dart';
import '../../data/model/category_model.dart';
import '../../data/repository/category_repository.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryRepository _repo;

  CategoryViewModel(this._repo) {
    _listen();
  }

  List<CategoryModel> categories = [];

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  void _listen() {
    _repo.getCategories(userId).listen((data) {
      categories = data;
      notifyListeners();
    });
  }

  // 🔥 FIXED: now accepts full model
  Future<void> addCategory(CategoryModel category) async {
    await _repo.addCategory(userId, category);
  }

  Future<void> addDefaultCategories() async {
    final alreadyExists = await _repo.hasCategories(userId);

    if (alreadyExists) {
      return;
    }

    final now = DateTime.now();

    for (final item in predefinedCategories) {
      final category = CategoryModel(
        id: item["name"].toString().toLowerCase(),

        name: item["name"],

        icon: (item["icon"] as IconData).codePoint.toString(),

        color: (item["color"] as Color).value,

        createdAt: now,

        updatedAt: now,
      );

      await _repo.addCategory(userId, category);
    }
  }
}
