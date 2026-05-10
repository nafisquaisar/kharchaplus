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

  // =========================
  // SAVE MEAL ENTRY
  // =========================

  @override
  Future<void> saveMealEntry(MealEntry entry) async {
    try {
      await firebaseService.mealEntriesRef.doc(entry.id).set({
        "id": entry.id,

        "cycleId": entry.cycleId,

        "date": entry.date,

        "breakfast": entry.breakfast,

        "lunch": entry.lunch,

        "dinner": entry.dinner,

        "skipped": entry.skipped,

        "extraCharge": entry.extraCharge,

        "note": entry.note,

        "extraMealType": entry.extraMealType?.name,

        "createdAt": entry.createdAt,

        "updatedAt": entry.updatedAt,

        "isDeleted": entry.isDeleted,

        "isSynced": entry.isSynced,

        "version": entry.version,
      });
    } catch (e) {
      rethrow;
    }
  }

  // =========================
  // GET MEALS
  // =========================

  @override
  Future<List<MealEntry>> getMealEntries(String cycleId) async {
    try {
      final snapshot = await firebaseService.mealEntriesRef
          .where("cycleId", isEqualTo: cycleId)
          .where("isDeleted", isEqualTo: false)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return MealEntry(
          id: data["id"],

          cycleId: data["cycleId"],

          date: (data["date"] as Timestamp).toDate(),

          breakfast: data["breakfast"],

          lunch: data["lunch"],

          dinner: data["dinner"],

          skipped: data["skipped"],

          extraCharge: (data["extraCharge"] as num).toDouble(),

          note: data["note"],

          createdAt: (data["createdAt"] as Timestamp).toDate(),

          updatedAt: (data["updatedAt"] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateMealEntry(MealEntry entry) async {}

  @override
  Future<void> deleteMealEntry(String entryId) async {}

  @override
  Future<MealEntry?> getMealByDate(String cycleId, DateTime date) async {
    return null;
  }

  @override
  Future<FoodCycle?> getCycleById(String cycleId) async {
    return null;
  }

  @override
  Future<void> syncPendingData() async {}
}
