import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
}