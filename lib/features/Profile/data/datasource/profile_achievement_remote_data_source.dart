import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileAchievementRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProfileAchievementRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('profile')
        .doc('achievements')
        .collection('items');
  }

  Future<void> upsertAchievement({
    required String uid,
    required String achievementId,
    required Map<String, dynamic> payload,
  }) async {
    await _collection(uid).doc(achievementId).set(
      {
        ...payload,
        'unlockedAt': _asTimestamp(payload['unlockedAt']),
        'updatedAtLocal': _asTimestamp(payload['updatedAtLocal']),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<List<Map<String, dynamic>>> fetchAchievements(String uid) async {
    final snapshot = await _collection(uid).get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
  }

  Future<Map<String, dynamic>?> fetchExpenseSummary(String uid) async {
    final summaryRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('summary')
        .doc('main');

    final snapshot = await summaryRef.get();
    return snapshot.data();
  }

  Timestamp? _asTimestamp(Object? value) {
    if (value is Timestamp) {
      return value;
    }
    if (value is DateTime) {
      return Timestamp.fromDate(value);
    }
    return null;
  }
}
