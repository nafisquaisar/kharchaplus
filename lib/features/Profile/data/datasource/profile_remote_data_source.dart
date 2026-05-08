import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:expense_tracker/features/auth/domain/entities/user_profile.dart';

class ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProfileRemoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  Stream<UserProfile?> watchProfile(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }
      return UserProfile.fromJson(snapshot.data()!);
    });
  }

  Future<void> saveProfile(UserProfile profile) async {
    final docRef = _firestore.collection('users').doc(profile.uid);
    final snapshot = await docRef.get();

    final payload = {
      ...profile.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (!snapshot.exists) {
      await docRef.set({
        ...payload,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return;
    }

    await docRef.set(payload, SetOptions(merge: true));
  }

  Reference profileImageRef(String uid, String fileName) {
    return _storage.ref().child('profile_images/$uid/$fileName');
  }

  UploadTask uploadProfileImage(Reference ref, File file) {
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      cacheControl: 'public,max-age=3600',
    );
    return ref.putFile(file, metadata);
  }

  Future<String> getDownloadUrl(Reference ref) {
    return ref.getDownloadURL();
  }

  Future<void> deleteImageByUrl(String url) async {
    await _storage.refFromURL(url).delete();
  }
}