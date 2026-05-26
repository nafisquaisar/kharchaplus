import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthDataSource({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Stream<User?> userChanges() => _auth.userChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    if (displayName != null) {
      await user.updateDisplayName(displayName);
    }

    if (photoUrl != null) {
      await user.updatePhotoURL(photoUrl);
    }

    await user.reload();
  }

  Future<AuthCredential?> getGoogleCredential() async {
    debugPrint('[Auth] Google sign-in started');

    GoogleSignInAccount? googleUser;
    try {
      googleUser = await _googleSignIn.signIn();
    } catch (e) {
      debugPrint('[Auth] Google sign-in exception: $e');
      rethrow;
    }

    if (googleUser == null) {
      debugPrint('[Auth] Google sign-in cancelled');
      return null;
    }

    final googleAuth = await googleUser.authentication;
    if (googleAuth.idToken == null || googleAuth.accessToken == null) {
      debugPrint('[Auth] Google sign-in missing tokens');
      throw FirebaseAuthException(
        code: 'missing-google-tokens',
        message:
            'Missing Google tokens. Check SHA-1/256 and OAuth client config.',
      );
    }

    return GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) {
    return _auth.signInWithCredential(credential);
  }

  Future<UserCredential> linkWithCredential(AuthCredential credential) {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user for linking');
    }
    return user.linkWithCredential(credential);
  }


  Future<OtpSessionResult> sendOtp(
    String phoneNumber, {
    bool isLinking = false,
  }) async {
    final completer = Completer<OtpSessionResult>();
    debugPrint('[Auth] OTP send requested for ${_maskPhone(phoneNumber)}');

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) {
        debugPrint('[Auth] OTP auto verification completed');
        if (!completer.isCompleted) {
          completer.complete(OtpSessionResult.autoVerified(credential));
        }
      },
      verificationFailed: (e) {
        debugPrint('[Auth] OTP verification failed: ${e.code} ${e.message}');
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      },
      codeSent: (id, token) {
        debugPrint('[Auth] OTP code sent');
        if (!completer.isCompleted) {
          completer.complete(OtpSessionResult.codeSent(id));
        }
      },
      codeAutoRetrievalTimeout: (id) {
        debugPrint('[Auth] OTP auto retrieval timeout');
        if (!completer.isCompleted) {
          completer.complete(OtpSessionResult.codeSent(id));
        }
      },
    );

    return completer.future;
  }

  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String otp,
  }) {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    return _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  static String _maskPhone(String phoneNumber) {
    if (phoneNumber.length < 4) return '****';
    final suffix = phoneNumber.substring(phoneNumber.length - 4);
    return '****$suffix';
  }
}

class OtpSessionResult {
  final String? verificationId;
  final AuthCredential? credential;
  final bool isAutoVerified;

  const OtpSessionResult._({
    required this.verificationId,
    required this.credential,
    required this.isAutoVerified,
  });

  factory OtpSessionResult.codeSent(String verificationId) {
    return OtpSessionResult._(
      verificationId: verificationId,
      credential: null,
      isAutoVerified: false,
    );
  }

  factory OtpSessionResult.autoVerified(AuthCredential credential) {
    return OtpSessionResult._(
      verificationId: null,
      credential: credential,
      isAutoVerified: true,
    );
  }
}
