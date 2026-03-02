import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

import 'location_service.dart';

class TrackingService {
  static TrackingService? _instance;

  factory TrackingService({
    FirebaseDatabase? rtdb,
    LocationService? locationService,
  }) {
    return _instance ??= TrackingService._internal(
      rtdb: rtdb,
      locationService: locationService,
    );
  }

  final FirebaseDatabase _rtdb;
  final LocationService _locationService;

  StreamSubscription<Position>? _sub;

  TrackingService._internal({
    FirebaseDatabase? rtdb,
    LocationService? locationService,
  })  : _rtdb = rtdb ?? FirebaseDatabase.instance,
        _locationService = locationService ?? LocationService();

  DatabaseReference _locationRef(String uid) {
    return _rtdb.ref('locations/$uid');
  }

  bool get isTracking => _sub != null;

  Future<void> startTracking({
    required String uid,
    bool isRunMode = false,
  }) async {
    if (_sub != null) {
      return;
    }

    await _locationRef(uid).update({
      'isTracking': true,
      'isRunMode': isRunMode,
      'updatedAt': ServerValue.timestamp,
    });

    _sub = _locationService.positionStream().listen((pos) {
      _locationRef(uid).update({
        'lat': pos.latitude,
        'lng': pos.longitude,
        'accuracy': pos.accuracy,
        'speed': pos.speed,
        'heading': pos.heading,
        'updatedAt': ServerValue.timestamp,
      });
    });
  }

  Future<void> stopTracking({
    required String uid,
  }) async {
    await _sub?.cancel();
    _sub = null;

    await _locationRef(uid).update({
      'isTracking': false,
      'isRunMode': false,
      'updatedAt': ServerValue.timestamp,
    });
  }

  Stream<DatabaseEvent> watchLocation(String uid) {
    return _locationRef(uid).onValue;
  }

  Future<void> setSosState({
    required String uid,
    required bool isSosActive,
    String? activeSosId,
  }) async {
    await _locationRef(uid).update({
      'isSosActive': isSosActive,
      'activeSosId': activeSosId,
      'updatedAt': ServerValue.timestamp,
    });
  }
}
