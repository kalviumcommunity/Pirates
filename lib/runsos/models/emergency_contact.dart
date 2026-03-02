class EmergencyContact {
  final String id;
  final String name;
  final String phoneNumber;
  final String? relationship;

  const EmergencyContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.relationship,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };
  }

  static EmergencyContact fromJson(String id, Map<String, dynamic> json) {
    return EmergencyContact(
      id: id,
      name: (json['name'] ?? '').toString(),
      phoneNumber: (json['phoneNumber'] ?? '').toString(),
      relationship: json['relationship']?.toString(),
    );
  }
}
