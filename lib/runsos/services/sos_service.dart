import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/sos_event.dart';
import 'location_service.dart';
import 'tracking_service.dart';

class SosService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final LocationService _locationService;
  final TrackingService _trackingService;

  SosService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    LocationService? locationService,
    TrackingService? trackingService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _locationService = locationService ?? LocationService(),
        _trackingService = trackingService ?? TrackingService();

  Future<SosEvent> triggerSos({
    required String userName,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Not authenticated');
    }

    final pos = await _locationService.getCurrentPosition();
    final createdAt = DateTime.now().toUtc();

    final doc = await _firestore.collection('sos_events').add({
      'uid': user.uid,
      'userName': userName,
      'userPhone': user.phoneNumber,
      'lat': pos.latitude,
      'lng': pos.longitude,
      'mapsUrl': 'https://www.google.com/maps?q=${pos.latitude},${pos.longitude}',
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _trackingService.setSosState(
      uid: user.uid,
      isSosActive: true,
      activeSosId: doc.id,
    );

    return SosEvent(
      id: doc.id,
      uid: user.uid,
      userName: userName,
      userPhone: user.phoneNumber,
      lat: pos.latitude,
      lng: pos.longitude,
      createdAt: createdAt,
    );
  }

  Future<void> clearSos() async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    await _trackingService.setSosState(
      uid: user.uid,
      isSosActive: false,
      activeSosId: null,
    );
  }
}
