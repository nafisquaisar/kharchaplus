String getKey(DateTime date) => "${date.year}-${date.month}-${date.day}";

DateTime? dateFromKey(String key) {
  final parts = key.split('-');
  if (parts.length != 3) {
    return null;
  }

  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);

  if (year == null || month == null || day == null) {
    return null;
  }

  return DateTime(year, month, day);
}

Map<String, bool> mealState(Map<String, Map<String, bool>> data, String key) {
  final day = data[key];
  return {
    'lunch': day?['lunch'] ?? false,
    'dinner': day?['dinner'] ?? false,
  };
}

DateTime normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime clampDateToCycle(DateTime date, DateTime start, DateTime? end) {
  final normalizedDate = normalizeDate(date);
  final normalizedStart = normalizeDate(start);
  final normalizedEnd = end == null ? null : normalizeDate(end);

  if (normalizedDate.isBefore(normalizedStart)) {
    return normalizedStart;
  }

  if (normalizedEnd != null && normalizedDate.isAfter(normalizedEnd)) {
    return normalizedEnd;
  }

  return normalizedDate;
}

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

