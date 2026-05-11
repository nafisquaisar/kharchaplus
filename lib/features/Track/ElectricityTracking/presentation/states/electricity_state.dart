import '../../domain/entities/electricity_entity.dart';

enum ElectricityAction {
  idle,
  loading,
  addSuccess,
  updateSuccess,
  deleteSuccess,
  fetchSuccess,
  error,
}

class ElectricityState {

  final bool isLoading;
  final bool isSearching;
  final bool isSyncing;

  final List<ElectricityEntity> list;
  final List<ElectricityEntity> searchResults;

  final String? error;

  final int actionId;
  final int consumedActionId;
  final ElectricityAction lastAction;
  final bool actionSuccess;
  final String? actionMessage;
  final String? actionError;

  const ElectricityState({
    required this.isLoading,
    required this.isSearching,
    required this.isSyncing,
    required this.list,
    required this.searchResults,
    this.error,
    required this.actionId,
    required this.consumedActionId,
    required this.lastAction,
    required this.actionSuccess,
    required this.actionMessage,
    required this.actionError,
  });

  factory ElectricityState.initial() {

    return const ElectricityState(
      isLoading: false,
      isSearching: false,
      isSyncing: false,
      list: [],
      searchResults: [],
      error: null,
      actionId: 0,
      consumedActionId: -1,
      lastAction: ElectricityAction.idle,
      actionSuccess: false,
      actionMessage: null,
      actionError: null,
    );
  }

  ElectricityState copyWith({
    bool? isLoading,
    bool? isSearching,
    bool? isSyncing,
    List<ElectricityEntity>? list,
    List<ElectricityEntity>? searchResults,
    String? error,
    bool clearError = false,
    int? actionId,
    int? consumedActionId,
    ElectricityAction? lastAction,
    bool? actionSuccess,
    String? actionMessage,
    String? actionError,
    bool clearActionMessage = false,
    bool clearActionError = false,
  }) {

    return ElectricityState(
      isLoading:
      isLoading ?? this.isLoading,

      isSearching:
      isSearching ?? this.isSearching,

      isSyncing:
      isSyncing ?? this.isSyncing,

      list: list ?? this.list,

      searchResults:
      searchResults ?? this.searchResults,

      error: clearError ? null : error ?? this.error,

      actionId: actionId ?? this.actionId,

      consumedActionId: consumedActionId ?? this.consumedActionId,

      lastAction: lastAction ?? this.lastAction,

      actionSuccess: actionSuccess ?? this.actionSuccess,

      actionMessage: clearActionMessage ? null : actionMessage ?? this.actionMessage,

      actionError: clearActionError ? null : actionError ?? this.actionError,
    );
  }
}