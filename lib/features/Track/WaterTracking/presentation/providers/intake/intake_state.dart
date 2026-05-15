import '../../../domain/entities/water_intake_entity.dart';

class IntakeState {

  final bool isLoading;

  final List<WaterIntakeEntity>
  todayIntake;

  final List<WaterIntakeEntity>
  weeklyIntake;

  final List<WaterIntakeEntity>
  monthlyIntake;

  final String? error;

  const IntakeState({

    required this.isLoading,

    required this.todayIntake,

    required this.weeklyIntake,

    required this.monthlyIntake,

    this.error,
  });

  factory IntakeState.initial() {

    return const IntakeState(

      isLoading: false,

      todayIntake: [],

      weeklyIntake: [],

      monthlyIntake: [],

      error: null,
    );
  }

  IntakeState copyWith({

    bool? isLoading,

    List<WaterIntakeEntity>?
    todayIntake,

    List<WaterIntakeEntity>?
    weeklyIntake,

    List<WaterIntakeEntity>?
    monthlyIntake,

    String? error,
  }) {

    return IntakeState(

      isLoading:
      isLoading ??
          this.isLoading,

      todayIntake:
      todayIntake ??
          this.todayIntake,

      weeklyIntake:
      weeklyIntake ??
          this.weeklyIntake,

      monthlyIntake:
      monthlyIntake ??
          this.monthlyIntake,

      error: error,
    );
  }
}