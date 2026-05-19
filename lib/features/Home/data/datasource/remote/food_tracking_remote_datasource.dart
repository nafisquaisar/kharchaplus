import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../models/food_tracking_model.dart';

abstract class FoodTrackingHomeRemoteDataSource {
  Future<List<FoodTrackingHomeModel>> getFoodCycles();

  Stream<List<FoodTrackingHomeModel>> watchFoodCycles();
}

class FoodTrackingHomeRemoteDataSourceImpl
    implements FoodTrackingHomeRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FoodTrackingHomeRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  String? _currentUserId() => auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _collection(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('food_cycles');
  }

  @override
  Future<List<FoodTrackingHomeModel>> getFoodCycles() async {
    final userId = _currentUserId();
    if (userId == null) {
      debugPrint('[FoodHomeRemote] no user for fetch');
      return [];
    }

    try {
      final snapshot = await _collection(userId)
          .orderBy('updatedAt', descending: true)
          .get();

      final result = snapshot.docs
          .map(
            (doc) => FoodTrackingHomeModel.fromJson(
              doc.data(),
              documentId: doc.id,
            ),
          )
          .toList();

      debugPrint('[FoodHomeRemote] fetched ${result.length} items');
      return result;
    } catch (e, stack) {
      debugPrint('[FoodHomeRemote] fetch failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Stream<List<FoodTrackingHomeModel>> watchFoodCycles() {
    final userId = _currentUserId();
    if (userId == null) {
      debugPrint('[FoodHomeRemote] no user for watch');
      return const Stream<List<FoodTrackingHomeModel>>.empty();
    }

    return _collection(userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => FoodTrackingHomeModel.fromJson(
              doc.data(),
              documentId: doc.id,
            ),
          )
          .toList();
    });
  }
}
