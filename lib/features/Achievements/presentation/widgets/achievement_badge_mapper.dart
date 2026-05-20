import 'dart:developer' as developer;

/// Production-ready registry for achievement badges.
///
/// Responsibilities:
/// - Centralized mapping of achievementId -> asset filename
/// - Category lookup
/// - Candidate asset generation (locked/unlocked variants)
/// - Small debug logging surface
enum BadgeCategory { streak, water, electricity, expense, savings, unknown }

class AchievementBadgeMapper {
  AchievementBadgeMapper._();

  static const String _basePath = 'assets/achievements/svg_medals';

  // Canonical mapping of achievement id -> SVG filename.
  static const Map<String, String> _fileMap = {
    'streak_master': 'streak_master.svg',
    'goal_achiever': 'goal_achiever.svg',
    'water_saver': 'water_saver.svg',
    'electric_saver': 'electric_saver.svg',
    'gas_saver': 'gas_saver.svg',
    'expense_tracker': 'expense_tracker.svg',
    'budget_king': 'budget_king.svg',
    'finance_ninja': 'finance_ninja.svg',
  };

  // Category mapping for each id (keeps category knowledge centralized).
  static const Map<String, BadgeCategory> _categoryMap = {
    'streak_master': BadgeCategory.streak,
    'goal_achiever': BadgeCategory.water,
    'water_saver': BadgeCategory.water,
    'electric_saver': BadgeCategory.electricity,
    'gas_saver': BadgeCategory.electricity,
    'expense_tracker': BadgeCategory.expense,
    'budget_king': BadgeCategory.savings,
    'finance_ninja': BadgeCategory.savings,
  };

  /// Returns whether the mapper knows about this id (compile-time canonical list)
  static bool isKnown(String id) => _fileMap.containsKey(_normalizeId(id));

  /// Returns canonical asset path (unlocked). Falls back to `<id>.svg` if not mapped.
  static String assetPathFor(String id) {
    final normalized = _normalizeId(id);
    final file = _fileMap[normalized] ?? '$normalized.svg';
    final path = '$_basePath/$file';
    debugLog('Mapping id="$id" -> "$path"');
    return path;
  }

  /// Returns the category for the given id. Unknown ids return [BadgeCategory.unknown].
  static BadgeCategory categoryFor(String id) => _categoryMap[_normalizeId(id)] ?? BadgeCategory.unknown;

  /// Generates candidate asset paths for an id depending on locked/unlocked preference.
  ///
  /// Order is important: callers should try candidates in order and pick the first
  /// that actually exists (e.g. `<id>_locked.svg` then `<id>.svg`).
  static List<String> assetCandidatesFor(String id, {bool preferLockedVariant = false}) {
    final normalized = _normalizeId(id);
    final baseFile = _fileMap[normalized] ?? '$normalized.svg';
    final baseName = baseFile.replaceAll('.svg', '');

    final lockedCandidate = '$_basePath/${baseName}_locked.svg';
    final unlockedCandidate = '$_basePath/$baseFile';

    final candidates = preferLockedVariant
        ? <String>[lockedCandidate, unlockedCandidate]
        : <String>[unlockedCandidate, lockedCandidate];

    debugLog('Candidates for id="$id": $candidates');
    return candidates;
  }

  /// Utility: list of known IDs
  static List<String> knownIds() => _fileMap.keys.toList(growable: false);

  static String _normalizeId(String id) {
    return id.trim().toLowerCase().replaceAll(' ', '_').replaceAll('.svg', '');
  }

  /// Small debug surface
  static void debugLog(String message, {String name = 'AchievementBadgeMapper'}) {
    developer.log(message, name: name);
  }
}
