import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  Future<String> getCurrentUserId() async {
    final current = _auth.currentUser;
    if (current != null) return current.uid;

    final credential = await _auth.signInAnonymously();
    final user = credential.user;
    if (user == null) {
      throw StateError('Unable to authenticate user');
    }
    return user.uid;
  }
}

