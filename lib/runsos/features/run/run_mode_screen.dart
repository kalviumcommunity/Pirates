import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/permission_service.dart';
import '../../services/tracking_service.dart';
import '../sos/sos_map_screen.dart';

class RunModeScreen extends StatefulWidget {
  const RunModeScreen({super.key});

  @override
  State<RunModeScreen> createState() => _RunModeScreenState();
}

class _RunModeScreenState extends State<RunModeScreen> {
  final _tracking = TrackingService();
  final _permissions = PermissionService();

  DateTime? _startedAt;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ok = await _permissions.ensureLocationPermission();
    if (!ok) return;

    await _tracking.startTracking(uid: user.uid, isRunMode: true);

    setState(() => _startedAt ??= DateTime.now());
    _ticker ??= Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _stop() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _tracking.stopTracking(uid: user.uid);
    _ticker?.cancel();
    _ticker = null;

    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _shareLink() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // MVP: share a tracking code (UID). V1 can upgrade this to Dynamic Links.
    final msg =
        'RunSOS Live Tracking\n\nOpen RunSOS and view tracking for this code:\n${user.uid}';

    await Share.share(msg);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _startedAt == null
        ? const Duration(seconds: 0)
        : DateTime.now().difference(_startedAt!);

    final mm = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(title: const Text('Run Mode')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Session time',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '$mm:$ss',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: _shareLink,
                icon: const Icon(Icons.share),
                label: const Text('Share Live Tracking'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) return;
                  Navigator.pushNamed(
                    context,
                    SosMapScreen.routeName,
                    arguments: SosMapArgs(trackUid: user.uid),
                  );
                },
                icon: const Icon(Icons.map_outlined),
                label: const Text('Preview My Live Map'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: _stop,
                icon: const Icon(Icons.stop_circle_outlined),
                label: const Text('Stop Run'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
