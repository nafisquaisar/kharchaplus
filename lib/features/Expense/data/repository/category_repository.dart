import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/category_model.dart';

class CategoryRepository {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<CategoryModel>> getCategories(String userId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("categories")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList();
    });
  }

  Future<void> addCategory(String userId, CategoryModel category) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("categories")
        .doc(category.id)
        .set(category.toJson());
  }
}