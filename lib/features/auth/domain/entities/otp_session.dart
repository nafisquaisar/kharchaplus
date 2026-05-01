import 'auth_user.dart';

class OtpSession {
  final String? verificationId;
  final bool isAutoVerified;
  final AuthUser? user;

  const OtpSession._({
    required this.verificationId,
    required this.isAutoVerified,
    required this.user,
  });

  const OtpSession.codeSent(String verificationId)
      : this._(
          verificationId: verificationId,
          isAutoVerified: false,
          user: null,
        );

  const OtpSession.autoVerified(AuthUser user)
      : this._(
          verificationId: null,
          isAutoVerified: true,
          user: user,
        );
}

