import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../services/FirebaseFoodService.dart';
import '../../services/food_sync_service.dart';
import '../entities/FoodCycle.dart';
import 'food_repository.dart';

class FoodRepositoryImpl implements FoodRepository {
  final FirebaseFoodService firebaseService;
  final FoodSyncService foodSyncService;

  FoodRepositoryImpl({
    required this.firebaseService,
    FoodSyncService? foodSyncService,
  }) : foodSyncService = foodSyncService ??
            FoodSyncService(
              service: firebaseService,
            );

  @override
  Future<void> createCycle(FoodCycle cycle) async {
    await firebaseService.foodCyclesRef.doc(cycle.id).set(cycle.toMap());
    await foodSyncService.syncTrackingModule();
  }

  @override
  Future<List<FoodCycle>> getAllCycles() async {
    final snapshot = await firebaseService.foodCyclesRef
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .get();

    if (snapshot.docs.isEmpty) {
      return <FoodCycle>[];
    }

    final cycles = <FoodCycle>[];

    for (final doc in snapshot.docs) {
      try {
        cycles.add(FoodCycle.fromMap(doc.data() as Map<String, dynamic>));
      } catch (error, stackTrace) {
        debugPrint(
            '[FoodRepository] cycle parse failed doc=${doc.id} error=$error');
        debugPrint('$stackTrace');
      }
    }

    return cycles;
  }

  @override
  Future<void> updateCycle(FoodCycle cycle) async {
    await firebaseService.foodCyclesRef.doc(cycle.id).update({
      'title': cycle.title,
      'note': cycle.note,
      'startDate': Timestamp.fromDate(cycle.startDate),
      'endDate': Timestamp.fromDate(cycle.endDate),
      'mealPrice': cycle.mealPrice,
      'monthlyAmount': cycle.monthlyAmount,
      'monthlyFee': cycle.monthlyFee,
      'totalTiffin': cycle.totalTiffin,
      'totalEaten': cycle.totalEaten,
      'remainingTiffin': cycle.remainingTiffin,
      'includeSunday': cycle.includeSunday,
      'sundayRule': cycle.sundayRule.name,
      'status': cycle.status.name,
      'updatedAt': Timestamp.now(),
      'version': cycle.version + 1,
    });

    await foodSyncService.syncTrackingModule();
  }

  @override
  Future<void> deleteCycle(String cycleId) async {
    await firebaseService.foodCyclesRef.doc(cycleId).update({
      'isDeleted': true,
      'updatedAt': Timestamp.now(),
    });

    await foodSyncService.syncTrackingModule();
  }

  @override
  Future<FoodCycle?> getCycleById(String cycleId) async {
    return null;
  }

  @override
  Future<void> syncPendingData() async {}
}
