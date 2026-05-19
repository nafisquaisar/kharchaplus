import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileStatsRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProfileStatsRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> upsertStats({
    required String uid,
    required int currentStreak,
    required DateTime lastOpenedAt,
    required int lastOpenedDayKey,
    required int timezoneOffsetMinutes,
    required int monthlyGoalDaysCompleted,
    required int monthlyGoalDaysInMonth,
    required double monthlyGoalPercent,
    required DateTime updatedAt,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('profile')
        .doc('stats');

    await docRef.set(
      {
        'currentStreak': currentStreak,
        'lastOpenedAt': Timestamp.fromDate(lastOpenedAt),
        'lastOpenedDayKey': lastOpenedDayKey,
        'timezoneOffsetMinutes': timezoneOffsetMinutes,
        'monthlyGoalDaysCompleted': monthlyGoalDaysCompleted,
        'monthlyGoalDaysInMonth': monthlyGoalDaysInMonth,
        'monthlyGoalPercent': monthlyGoalPercent,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedAtLocal': Timestamp.fromDate(updatedAt),
      },
      SetOptions(merge: true),
    );
  }
}
