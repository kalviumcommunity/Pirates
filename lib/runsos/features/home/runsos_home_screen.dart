import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/emergency_contacts_service.dart';
import '../../services/permission_service.dart';
import '../../services/sos_service.dart';
import '../../services/tracking_service.dart';
import '../../services/user_profile_service.dart';
import '../../utils/sms_launcher.dart';
import '../../widgets/sos_button.dart';
import '../../models/user_profile.dart';

class RunSosHomeScreen extends StatefulWidget {
  const RunSosHomeScreen({super.key});

  @override
  State<RunSosHomeScreen> createState() => _RunSosHomeScreenState();
}

class _RunSosHomeScreenState extends State<RunSosHomeScreen> {
  final _tracking = TrackingService();
  final _permissions = PermissionService();
  final _sos = SosService();
  final _profiles = UserProfileService();
  final _contacts = EmergencyContactsService();

  bool _busy = false;

  Future<void> _toggleTracking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _busy = true);

    final ok = await _permissions.ensureLocationPermission();
    if (!ok) {
      setState(() => _busy = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required.')),
      );
      return;
    }

    if (_tracking.isTracking) {
      await _tracking.stopTracking(uid: user.uid);
    } else {
      await _tracking.startTracking(uid: user.uid);
    }

    setState(() => _busy = false);
  }

  Future<void> _triggerSos(String userName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _busy = true);

    final ok = await _permissions.ensureLocationPermission();
    if (!ok) {
      setState(() => _busy = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required for SOS.')),
      );
      return;
    }

    try {
      final event = await _sos.triggerSos(userName: userName);
      final contacts = await _contacts.listContactsOnce(user.uid);

      setState(() => _busy = false);
      if (!mounted) return;

      final msg = SmsLauncher.buildSosMessage(
        userName: userName,
        mapsUrl: event.googleMapsUrl,
        timeUtc: event.createdAt,
      );

      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('SOS sent'),
            content: Text(
              'Your SOS was created.\n\nGoogle Maps link:\n${event.googleMapsUrl}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              FilledButton(
                onPressed: () async {
                  await SmsLauncher.openMultiSmsComposer(
                    phoneNumbers: contacts.map((c) => c.phoneNumber).toList(),
                    message: msg,
                  );
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('SMS Fallback'),
              ),
            ],
          );
        },
      );
    } catch (_) {
      setState(() => _busy = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send SOS.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Not signed in.')));
    }

    return StreamBuilder<UserProfile?>(
      stream: _profiles.watchProfile(user.uid),
      builder: (context, snapshot) {
        final profile = snapshot.data;
        final name = profile?.name.trim().isNotEmpty == true
            ? profile!.name
            : 'Runner';

        return Scaffold(
          appBar: AppBar(
            title: const Text('RunSOS'),
            actions: [
              IconButton(
                onPressed: _busy
                    ? null
                    : () => Navigator.pushNamed(context, '/profile'),
                icon: const Icon(Icons.person),
                tooltip: 'Profile',
              ),
              IconButton(
                onPressed: _busy
                    ? null
                    : () async {
                        await FirebaseAuth.instance.signOut();
                      },
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
              ),
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Stay safe, $name',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SosButton(
                    onPressed: _busy ? null : () => _triggerSos(name),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: _busy ? null : _toggleTracking,
                      icon: Icon(_tracking.isTracking
                          ? Icons.stop_circle_outlined
                          : Icons.play_circle_outline),
                      label: Text(
                        _tracking.isTracking
                            ? 'Stop Tracking'
                            : 'Start Tracking',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: _busy
                          ? null
                          : () => Navigator.pushNamed(context, '/run'),
                      icon: const Icon(Icons.directions_run),
                      label: const Text('Run Mode'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_busy) const LinearProgressIndicator(minHeight: 2),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
