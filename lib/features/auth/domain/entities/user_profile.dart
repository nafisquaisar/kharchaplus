class UserProfile {
  final String uid;
  final String? name;
  final String? email;
  final String? phone;
  final String? photoUrl; // ✅ NEW

  const UserProfile({
    required this.uid,
    this.name,
    this.email,
    this.phone,
    this.photoUrl,
  });

  /// 🔥 Convert Firestore → Model
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photoUrl: json['photoUrl'], // ✅ NEW
    );
  }

  /// 🔥 Convert Model → Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl, // ✅ NEW
    };
  }

  /// 🔥 Copy (useful for updates)
  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) {
    return UserProfile(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}