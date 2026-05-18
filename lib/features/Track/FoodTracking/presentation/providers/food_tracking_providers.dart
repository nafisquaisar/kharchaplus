import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../Home/presentation/providers/recent/recent_activity_providers.dart';
import '../../data/datasource/remote/meal_remote_datasource_impl.dart';
import '../../domain/repository/MealRepositoryImpl.dart';
import '../../domain/repository/MealRepository.dart';
import '../../domain/repository/food_repository_impl.dart';
import '../../domain/repository/food_repository.dart';
import '../../presentation/viewmodel/meal_entry_viewmodel.dart';
import '../../presentation/viewmodel/food_cycle_viewmodel.dart';
import '../../services/FirebaseFoodService.dart';

final foodServiceProvider = Provider<FirebaseFoodService>((ref) {
  return FirebaseFoodService(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

final mealRemoteDataSourceProvider = Provider<MealRemoteDataSourceImpl>((ref) {
  return MealRemoteDataSourceImpl(
    service: ref.read(foodServiceProvider),
  );
});

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepositoryImpl(
    remote: ref.read(mealRemoteDataSourceProvider),
  );
});

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepositoryImpl(
    firebaseService: ref.read(foodServiceProvider),
  );
});

final mealEntryViewModelProvider = ChangeNotifierProvider<MealEntryViewModel>((ref) {
  return MealEntryViewModel(
    ref.read(mealRepositoryProvider),
    addRecentActivityUseCase: ref.read(addRecentActivityUseCaseProvider),
    updateRecentActivityUseCase: ref.read(updateRecentActivityUseCaseProvider),
    deleteRecentActivityUseCase: ref.read(deleteRecentActivityUseCaseProvider),
  );
});

final foodCycleViewModelProvider = ChangeNotifierProvider<FoodCycleViewModel>((ref) {
  return FoodCycleViewModel(
    ref.read(foodRepositoryProvider),
    ref.read(mealRepositoryProvider),
    addRecentActivityUseCase: ref.read(addRecentActivityUseCaseProvider),
    updateRecentActivityUseCase: ref.read(updateRecentActivityUseCaseProvider),
    deleteRecentActivityUseCase: ref.read(deleteRecentActivityUseCaseProvider),
  );
});
