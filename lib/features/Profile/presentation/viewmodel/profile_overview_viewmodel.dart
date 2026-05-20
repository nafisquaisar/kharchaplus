import 'package:flutter/foundation.dart';

import '../../data/models/profile_overview_model.dart';
import '../../domain/usecase/get_profile_overview.dart';

@immutable
class ProfileOverviewState {
  final bool isLoading;
  final bool isRefreshing;
  final ProfileOverviewModel? data;
  final String? errorMessage;

  const ProfileOverviewState({
    required this.isLoading,
    required this.isRefreshing,
    required this.data,
    required this.errorMessage,
  });

  const ProfileOverviewState.initial()
      : isLoading = true,
        isRefreshing = false,
        data = null,
        errorMessage = null;

  bool get isEmpty => data == null || data!.isEmpty;

  ProfileOverviewState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    ProfileOverviewModel? data,
    String? errorMessage,
  }) {
    return ProfileOverviewState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ProfileOverviewState &&
            runtimeType == other.runtimeType &&
            isLoading == other.isLoading &&
            isRefreshing == other.isRefreshing &&
            data == other.data &&
            errorMessage == other.errorMessage;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        isRefreshing.hashCode ^
        data.hashCode ^
        errorMessage.hashCode;
  }
}

class ProfileOverviewViewModel extends ChangeNotifier {
  final GetProfileOverview _getProfileOverview;

  ProfileOverviewState _state = const ProfileOverviewState.initial();
  String? _userId;

  ProfileOverviewViewModel({
    required GetProfileOverview getProfileOverview,
  }) : _getProfileOverview = getProfileOverview;

  ProfileOverviewState get state => _state;

  void bindUser(String? uid) {
    if (_userId == uid) {
      return;
    }
    _userId = uid;
    _setState(const ProfileOverviewState.initial());

    if (uid == null || uid.isEmpty) {
      return;
    }

    load();
  }

  Future<void> load({bool forceRefresh = false}) async {
    final uid = _userId;
    if (uid == null || uid.isEmpty) {
      return;
    }

    if (_state.isLoading && !forceRefresh) {
      return;
    }

    _setState(
      _state.copyWith(
        isLoading: !forceRefresh,
        isRefreshing: forceRefresh,
        errorMessage: null,
      ),
    );

    try {
      final overview =
          await _getProfileOverview(uid, forceRefresh: forceRefresh);
      _setState(
        _state.copyWith(
          isLoading: false,
          isRefreshing: false,
          data: overview,
          errorMessage: null,
        ),
      );
    } catch (e) {
      _setState(
        _state.copyWith(
          isLoading: false,
          isRefreshing: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> refresh() async {
    await load(forceRefresh: true);
  }

  void _setState(ProfileOverviewState next) {
    if (_state == next) {
      return;
    }
    _state = next;
    notifyListeners();
  }
}

