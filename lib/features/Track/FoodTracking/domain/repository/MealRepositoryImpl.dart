import '../../data/datasource/remote/meal_remote_datasource.dart';
import '../../domain/entities/MealEntry.dart';
import 'MealRepository.dart';


class MealRepositoryImpl
    implements MealRepository {

  final MealRemoteDataSource remote;

  MealRepositoryImpl({

    required this.remote,
  });

  // =========================
  // SAVE
  // =========================

  @override
  Future<void> saveMealEntry(
      MealEntry entry,
      ) {

    return remote.saveMealEntry(
      entry,
    );
  }

  // =========================
  // GET ALL
  // =========================

  @override
  Future<List<MealEntry>>
  getMealEntries(
      String cycleId,
      ) {

    return remote.getMealEntries(
      cycleId,
    );
  }

  // =========================
  // GET SINGLE
  // =========================

  @override
  Future<MealEntry?> getMealByDate({

    required String cycleId,

    required DateTime date,
  }) async {

    final meals =
    await remote.getMealEntries(
      cycleId,
    );

    try {

      return meals.firstWhere(

            (e) =>

        e.date.year ==
            date.year &&

            e.date.month ==
                date.month &&

            e.date.day ==
                date.day,
      );

    } catch (_) {

      return null;
    }
  }

  // =========================
  // DELETE
  // =========================

  @override
  Future<void> deleteMealEntry(
      String entryId,
      ) async {

    // optional
  }

  @override
  Stream<List<MealEntry>>
  watchMealEntries(
      String cycleId,
      ) {

    return remote.watchMealEntries(
      cycleId,
    );
  }

}