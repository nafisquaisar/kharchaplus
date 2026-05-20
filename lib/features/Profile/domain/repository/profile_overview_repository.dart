import '../../data/models/profile_overview_model.dart';

abstract class ProfileOverviewRepository {
  Future<ProfileOverviewModel> getOverview(
    String uid, {
    bool forceRefresh = false,
  });

  Future<ProfileOverviewModel?> getCachedOverview(String uid);

  Future<void> clearCache(String uid);
}

