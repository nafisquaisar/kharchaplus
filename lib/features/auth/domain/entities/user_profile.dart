class UserProfile {
  final String uid;
  final String? name;
  final String? email;
  final String? phone;

  const UserProfile({
    required this.uid,
    this.name,
    this.email,
    this.phone,
  });
}

