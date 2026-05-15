import '../../../domain/entities/water_goal_entity.dart';

class GoalState {

  final bool isLoading;

  final WaterGoalEntity? goal;

  final String? error;

  const GoalState({

    required this.isLoading,

    required this.goal,

    this.error,
  });

  factory GoalState.initial() {

    return const GoalState(

      isLoading: false,

      goal: null,

      error: null,
    );
  }

  GoalState copyWith({

    bool? isLoading,

    WaterGoalEntity? goal,

    String? error,
  }) {

    return GoalState(

      isLoading:
      isLoading ??
          this.isLoading,

      goal:
      goal ??
          this.goal,

      error: error,
    );
  }
}