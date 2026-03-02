class SosEvent {
  final String id;
  final String uid;
  final String userName;
  final String? userPhone;
  final double lat;
  final double lng;
  final DateTime createdAt;

  const SosEvent({
    required this.id,
    required this.uid,
    required this.userName,
    required this.lat,
    required this.lng,
    required this.createdAt,
    this.userPhone,
  });

  String get googleMapsUrl => 'https://www.google.com/maps?q=$lat,$lng';
}
