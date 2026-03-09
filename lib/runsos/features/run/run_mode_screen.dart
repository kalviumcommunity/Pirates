import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/permission_service.dart';
import '../../services/tracking_service.dart';
import '../../utils/app_config.dart';
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

    final link = AppConfig.buildTrackingLink(user.uid);
    final msg = 'RunSOS Live Tracking\n\n'
        'Open this live tracking link in RunSOS:\n$link\n\n'
        'Tracking code: ${user.uid}';

    await Share.share(msg);
  }

  Future<void> _copyLink() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await Clipboard.setData(
      ClipboardData(text: AppConfig.buildTrackingLink(user.uid)),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tracking link copied.')),
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final elapsed = _startedAt == null
        ? const Duration(seconds: 0)
        : DateTime.now().difference(_startedAt!);
    final hh = elapsed.inHours.toString().padLeft(2, '0');

    final mm = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    final trackingLink = user == null ? '' : AppConfig.buildTrackingLink(user.uid);

    return Scaffold(
      appBar: AppBar(title: const Text('Run Mode')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A1834), Color(0xFF050B16)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Run session active',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Share your live tracking link with family or preview your route in real time.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '$hh:$mm:$ss',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tracking link',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      trackingLink,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _shareLink,
                      icon: const Icon(Icons.share),
                      label: const Text('Share Live Tracking'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _copyLink,
                      icon: const Icon(Icons.copy_all_outlined),
                      label: const Text('Copy Link'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
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
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _stop,
              icon: const Icon(Icons.stop_circle_outlined),
              label: const Text('Stop Run'),
            ),
          ],
        ),
      ),
    );
  }
}
