enum AchievementCategory {
  water,
  electricity,
  expense,
  savings,
  streak,
}

class AchievementDefinition {
  final String id;
  final AchievementCategory category;
  final String title;
  final String description;
  final String iconKey;
  final double goal;

  const AchievementDefinition({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.goal,
  });
}

class AchievementCatalog {
  static const List<AchievementDefinition> definitions = [
    AchievementDefinition(
      id: 'streak_master',
      category: AchievementCategory.streak,
      title: 'Streak Master',
      description: 'Maintain a 7-day streak.',
      iconKey: 'fire',
      goal: 7,
    ),
    AchievementDefinition(
      id: 'water_saver',
      category: AchievementCategory.water,
      title: 'Water Saver',
      description: 'Hit your weekly water goal 5 days.',
      iconKey: 'water',
      goal: 5,
    ),
    AchievementDefinition(
      id: 'goal_achiever',
      category: AchievementCategory.water,
      title: 'Goal Achiever',
      description: 'Reach 90% of your monthly water goal.',
      iconKey: 'target',
      goal: 0.9,
    ),
    AchievementDefinition(
      id: 'electric_saver',
      category: AchievementCategory.electricity,
      title: 'Electric Saver',
      description: 'Stay under 120 units this cycle.',
      iconKey: 'bolt',
      goal: 120,
    ),
    AchievementDefinition(
      id: 'gas_saver',
      category: AchievementCategory.electricity,
      title: 'Gas Saver',
      description: 'Stay under 60 units this cycle.',
      iconKey: 'leaf',
      goal: 60,
    ),
    AchievementDefinition(
      id: 'expense_tracker',
      category: AchievementCategory.expense,
      title: 'Expense Tracker',
      description: 'Log 5 transactions.',
      iconKey: 'receipt',
      goal: 5,
    ),
    AchievementDefinition(
      id: 'budget_king',
      category: AchievementCategory.savings,
      title: 'Budget King',
      description: 'Keep a positive balance.',
      iconKey: 'crown',
      goal: 1,
    ),
    AchievementDefinition(
      id: 'finance_ninja',
      category: AchievementCategory.savings,
      title: 'Finance Ninja',
      description: 'Log 50 transactions.',
      iconKey: 'shield',
      goal: 50,
    ),
  ];

  static AchievementDefinition? byId(String id) {
    for (final definition in definitions) {
      if (definition.id == id) {
        return definition;
      }
    }
    return null;
  }
}

