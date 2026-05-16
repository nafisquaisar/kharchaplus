import '../domain/entities/water_intake_entity.dart';
import '../domain/entities/water_purchase_entity.dart';
import '../domain/enum/purchase_type.dart';

class WaterCalculationService {
  int dayKey(DateTime date) {
	return date.year * 10000 + date.month * 100 + date.day;
  }

  DateTime dateOnly(DateTime date) {
	return DateTime(date.year, date.month, date.day);
  }

  int totalIntakeMl(List<WaterIntakeEntity> intake) {
	var total = 0;
	for (final item in intake) {
	  total += item.amountMl;
	}
	return total;
  }

  Map<int, double> groupWeeklyLitersByWeekday({
	required List<WaterIntakeEntity> intake,
	DateTime? now,
  }) {
	final reference = now ?? DateTime.now();
	final start = dateOnly(reference).subtract(
	  const Duration(days: 6),
	);
	final end = dateOnly(reference).add(
	  const Duration(days: 1),
	);

	final map = {
	  1: 0.0,
	  2: 0.0,
	  3: 0.0,
	  4: 0.0,
	  5: 0.0,
	  6: 0.0,
	  7: 0.0,
	};

	for (final item in intake) {
	  if (item.dateTime.isBefore(start) || item.dateTime.isAfter(end)) {
		continue;
	  }
	  final weekday = item.dateTime.weekday;
	  map[weekday] = (map[weekday] ?? 0.0) + (item.amountMl / 1000);
	}

	return map;
  }

  StreakResult calculateStreaks(List<WaterIntakeEntity> intake, {DateTime? now}) {
	if (intake.isEmpty) {
	  return const StreakResult(
		uniqueDays: 0,
		currentStreak: 0,
		bestStreak: 0,
	  );
	}

	final uniqueDates = <DateTime>{};
	for (final item in intake) {
	  uniqueDates.add(dateOnly(item.dateTime));
	}

	final sortedDates = uniqueDates.toList()
	  ..sort((a, b) => a.compareTo(b));

	var best = 1;
	var currentRun = 1;
	for (var i = 1; i < sortedDates.length; i++) {
	  final diff = sortedDates[i].difference(sortedDates[i - 1]).inDays;
	  if (diff == 1) {
		currentRun += 1;
	  } else {
		if (currentRun > best) {
		  best = currentRun;
		}
		currentRun = 1;
	  }
	}
	if (currentRun > best) {
	  best = currentRun;
	}

	final today = dateOnly(now ?? DateTime.now());
	var currentStreak = 0;
	var cursor = today;
	while (uniqueDates.contains(cursor)) {
	  currentStreak += 1;
	  cursor = cursor.subtract(const Duration(days: 1));
	}

	return StreakResult(
	  uniqueDays: uniqueDates.length,
	  currentStreak: currentStreak,
	  bestStreak: best,
	);
  }

  PurchaseBreakdown calculatePurchaseBreakdown(List<WaterPurchaseEntity> purchases) {
	final countByType = <PurchaseType, int>{};
	final costByType = <PurchaseType, double>{};

	for (final item in purchases) {
	  countByType[item.type] = (countByType[item.type] ?? 0) + 1;
	  costByType[item.type] = (costByType[item.type] ?? 0) + item.price;
	}

	return PurchaseBreakdown(
	  countByType: countByType,
	  costByType: costByType,
	);
  }
}

class StreakResult {
  final int uniqueDays;
  final int currentStreak;
  final int bestStreak;

  const StreakResult({
	required this.uniqueDays,
	required this.currentStreak,
	required this.bestStreak,
  });
}

class PurchaseBreakdown {
	final Map<PurchaseType, int> countByType;
	final Map<PurchaseType, double> costByType;

  const PurchaseBreakdown({
	required this.countByType,
	required this.costByType,
  });
}

