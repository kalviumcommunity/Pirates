import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/tracking_service.dart';

class SosMapArgs {
  final String trackUid;

  const SosMapArgs({required this.trackUid});
}

class SosMapScreen extends StatefulWidget {
  static const routeName = '/track';

  final SosMapArgs args;

  const SosMapScreen({super.key, required this.args});

  @override
  State<SosMapScreen> createState() => _SosMapScreenState();
}

class _SosMapScreenState extends State<SosMapScreen> {
  final _tracking = TrackingService();

  StreamSubscription<DatabaseEvent>? _sub;
  LatLng? _last;

  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();

    _sub = _tracking.watchLocation(widget.args.trackUid).listen((event) {
      final value = event.snapshot.value;
      if (value is! Map) return;

      final lat = (value['lat'] as num?)?.toDouble();
      final lng = (value['lng'] as num?)?.toDouble();
      if (lat == null || lng == null) return;

      final pos = LatLng(lat, lng);
      setState(() => _last = pos);
      _controller?.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initial = _last ?? const LatLng(0, 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Live Location')),
      body: _last == null
          ? const Center(
              child: Text('Waiting for location updates...'),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(target: initial, zoom: 16),
              onMapCreated: (c) => _controller = c,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              markers: {
                Marker(
                  markerId: const MarkerId('tracked'),
                  position: _last!,
                  infoWindow: InfoWindow(title: widget.args.trackUid),
                ),
              },
            ),
    );
  }
}
