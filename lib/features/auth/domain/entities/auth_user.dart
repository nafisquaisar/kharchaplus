class AuthUser {
  final String uid;
  final String? email;
  final String? phoneNumber;
  final String? displayName;
  final String? photoUrl;
  final List<String> providers;

  const AuthUser({
    required this.uid,
    required this.providers,
    this.email,
    this.phoneNumber,
    this.displayName,
    this.photoUrl,
  });
}

