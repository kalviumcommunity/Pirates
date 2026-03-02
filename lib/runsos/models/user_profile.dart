class UserProfile {
  final String uid;
  final String? phoneNumber;
  final String name;
  final String? photoUrl;
  final String? bloodGroup;

  const UserProfile({
    required this.uid,
    required this.name,
    this.phoneNumber,
    this.photoUrl,
    this.bloodGroup,
  });

  bool get isComplete => name.trim().isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'name': name,
      'photoUrl': photoUrl,
      'bloodGroup': bloodGroup,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };
  }

  static UserProfile fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: (json['uid'] ?? '').toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      name: (json['name'] ?? '').toString(),
      photoUrl: json['photoUrl']?.toString(),
      bloodGroup: json['bloodGroup']?.toString(),
    );
  }
}
