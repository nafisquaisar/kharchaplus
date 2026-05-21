import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_profile.dart';

class FirestoreUserDataSource {
  final FirebaseFirestore _firestore;

  FirestoreUserDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserProfile?> getUserProfile(String uid) async {
    final docRef = _firestore.collection('users').doc(uid);
    final snapshot = await docRef.get();
    if (!snapshot.exists) {
      return null;
    }

    final data = snapshot.data();
    if (data == null) {
      return null;
    }

    return UserProfile.fromJson(data);
  }

  Future<void> saveUserProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String? photoUrl
  }) async {
    final docRef = _firestore.collection('users').doc(uid);
    final snapshot = await docRef.get();

    final payload = {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      "photoUrl": photoUrl,
      'lastLoginAt': FieldValue.serverTimestamp(),
    };

    if (!snapshot.exists) {
      await docRef.set({
        ...payload,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return;
    }

    await docRef.update(payload);
  }

  Future<void> upsertUserProfile({
    required User user,
    required List<String> providers,
  }) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final snapshot = await docRef.get();

    final baseData = {
      'uid': user.uid,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
      'name': user.displayName,
      'phone': user.phoneNumber,
    };

    if (!snapshot.exists) {
      await docRef.set({
        ...baseData,
        'providers': providers,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
      return;
    }

    await docRef.update({
      ...baseData,
      'providers': FieldValue.arrayUnion(providers),
      'lastLoginAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> mergeUserProfiles({
    required String fromUid,
    required String toUid,
  }) async {
    if (fromUid == toUid) {
      return;
    }

    final fromRef = _firestore.collection('users').doc(fromUid);
    final toRef = _firestore.collection('users').doc(toUid);

    await _firestore.runTransaction((transaction) async {
      final fromSnapshot = await transaction.get(fromRef);
      if (!fromSnapshot.exists) {
        return;
      }

      final toSnapshot = await transaction.get(toRef);
      final fromData = fromSnapshot.data();
      final toData = toSnapshot.data();

      final mergedProviders = <String>{
        ..._readStringList(toData?['providers']),
        ..._readStringList(fromData?['providers']),
      }.toList();

      final mergedData = {
        'uid': toUid,
        'email': _pickValue(toData?['email'], fromData?['email']),
        'phoneNumber':
            _pickValue(toData?['phoneNumber'], fromData?['phoneNumber']),
        'displayName':
            _pickValue(toData?['displayName'], fromData?['displayName']),
        'photoUrl': _pickValue(toData?['photoUrl'], fromData?['photoUrl']),
        'name': _pickValue(toData?['name'], fromData?['name']),
        'phone': _pickValue(toData?['phone'], fromData?['phone']),
        'providers': mergedProviders,
        'lastLoginAt': FieldValue.serverTimestamp(),
      };

      if (toData == null || !toData.containsKey('createdAt')) {
        mergedData['createdAt'] =
            fromData?['createdAt'] ?? FieldValue.serverTimestamp();
      }

      transaction.set(toRef, mergedData, SetOptions(merge: true));
      transaction.delete(fromRef);
    });
  }

  List<String> _readStringList(Object? value) {
    if (value is List) {
      return value.whereType<String>().toList();
    }
    return const [];
  }

  T? _pickValue<T>(Object? primary, Object? fallback) {
    if (primary is T && primary.toString().isNotEmpty) {
      return primary;
    }
    if (fallback is T && fallback.toString().isNotEmpty) {
      return fallback;
    }
    return null;
  }
}
