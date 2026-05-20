import '../../data/models/profile_overview_model.dart';
import '../repository/profile_overview_repository.dart';

class GetProfileOverview {
  final ProfileOverviewRepository repository;

  const GetProfileOverview(this.repository);

  Future<ProfileOverviewModel> call(
    String uid, {
    bool forceRefresh = false,
  }) {
    return repository.getOverview(uid, forceRefresh: forceRefresh);
  }
}

