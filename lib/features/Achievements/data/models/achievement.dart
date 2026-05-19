// Minimal achievement model
class Achievement {
  final String id;
  final String title;
  final String description;
  final String assetPath; // path to SVG asset under assets/achievements/svg_medals/
  final String category;
  final bool unlocked;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.assetPath,
    required this.category,
    this.unlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? assetPath,
    String? category,
    bool? unlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      assetPath: assetPath ?? this.assetPath,
      category: category ?? this.category,
      unlocked: unlocked ?? this.unlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

