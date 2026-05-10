import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/FirebaseFoodService.dart';
import '../entities/FoodCycle.dart';
import '../entities/MealEntry.dart';
import 'food_repository.dart';

class FoodRepositoryImpl implements FoodRepository {
  final FirebaseFoodService firebaseService;

  FoodRepositoryImpl({required this.firebaseService});

  // =========================
  // CREATE CYCLE
  // =========================

  @override
  Future<void> createCycle(FoodCycle cycle) async {
    try {
      await firebaseService.foodCyclesRef.doc(cycle.id).set(cycle.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // =========================
  // GET ALL CYCLES
  // =========================

  @override
  Future<List<FoodCycle>> getAllCycles() async {
    try {
      final snapshot = await firebaseService.foodCyclesRef
          .where("isDeleted", isEqualTo: false)
          .orderBy("createdAt", descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      // =========================
      // PARSE DATA
      // =========================

      final List<FoodCycle> cycles = [];

      for (final doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          final cycle = FoodCycle.fromMap(data);

          cycles.add(cycle);
        } catch (parseError, stackTrace) {
          print("❌ PARSE ERROR");
        }
      }

      return cycles;
    } catch (e, stackTrace) {
      print("");
      print("❌ GET ALL CYCLES ERROR ❌");
      print(e);
      print(stackTrace);

      rethrow;
    }
  }

  // =========================
  // UPDATE CYCLE
  // =========================

  @override
  Future<void> updateCycle(FoodCycle cycle) async {
    try {
      await firebaseService.foodCyclesRef.doc(cycle.id).update({
        // BASIC
        "title": cycle.title,

        "note": cycle.note,

        // DATE
        "startDate": cycle.startDate,

        "endDate": cycle.endDate,

        // PRICE
        "mealPrice": cycle.mealPrice,

        "monthlyAmount": cycle.monthlyAmount,

        "monthlyFee": cycle.monthlyFee,

        // TIFFIN
        "totalTiffin": cycle.totalTiffin,

        "totalEaten": cycle.totalEaten,

        "remainingTiffin": cycle.remainingTiffin,

        // RULES
        "includeSunday": cycle.includeSunday,

        "sundayRule": cycle.sundayRule.name,

        // STATUS
        "status": cycle.status.name,

        // META
        "updatedAt": DateTime.now(),

        "version": cycle.version + 1,
      });
    } catch (e) {
      rethrow;
    }
  }

  // =========================
  // DELETE CYCLE
  // =========================

  @override
  Future<void> deleteCycle(String cycleId) async {
    try {
      await firebaseService.foodCyclesRef.doc(cycleId).update({
        "isDeleted": true,

        "updatedAt": DateTime.now(),
      });
    } catch (e) {
      rethrow;
    }
  }



  @override
  Future<FoodCycle?> getCycleById(String cycleId) async {
    return null;
  }

  @override
  Future<void> syncPendingData() async {}
}
