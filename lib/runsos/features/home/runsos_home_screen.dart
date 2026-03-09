import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../models/emergency_contact.dart';
import '../../services/emergency_contacts_service.dart';
import '../../services/permission_service.dart';
import '../../services/sos_service.dart';
import '../../services/tracking_service.dart';
import '../../services/user_profile_service.dart';
import '../sos/sos_map_screen.dart';
import '../../utils/app_config.dart';
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
  final _trackingCodeController = TextEditingController();

  bool _busy = false;

  @override
  void dispose() {
    _trackingCodeController.dispose();
    super.dispose();
  }

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

      await _showSosResult(
        userName: userName,
        contacts: contacts,
        mapsUrl: event.googleMapsUrl,
        createdAt: event.createdAt,
        trackUid: user.uid,
      );
    } catch (_) {
      setState(() => _busy = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send SOS.')),
      );
    }
  }

  Future<void> _showSosResult({
    required String userName,
    required List<EmergencyContact> contacts,
    required String mapsUrl,
    required DateTime createdAt,
    required String trackUid,
  }) async {
    final msg = SmsLauncher.buildSosMessage(
      userName: userName,
      mapsUrl: mapsUrl,
      timeUtc: createdAt,
    );

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('SOS sent'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your live alert is now active.'),
              const SizedBox(height: 12),
              SelectableText(mapsUrl),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  this.context,
                  '/track',
                  arguments: SosMapArgs(trackUid: trackUid),
                );
              },
              child: const Text('View Map'),
            ),
            FilledButton(
              onPressed: () async {
                await SmsLauncher.openMultiSmsComposer(
                  phoneNumbers: contacts.map((c) => c.phoneNumber).toList(),
                  message: msg,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('SMS Fallback'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _startSosCountdown(String userName) async {
    var remaining = 5;
    var shouldSend = true;
    Timer? timer;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            timer ??= Timer.periodic(const Duration(seconds: 1), (value) {
              if (remaining <= 1) {
                value.cancel();
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
                return;
              }

              setDialogState(() {
                remaining -= 1;
              });
            });

            return AlertDialog(
              title: const Text('Emergency countdown'),
              content: Text(
                'Sending SOS in $remaining seconds. Cancel if this was accidental.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    shouldSend = false;
                    timer?.cancel();
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );

    timer?.cancel();
    if (!shouldSend || !mounted) {
      return;
    }

    await _triggerSos(userName);
  }

  Future<void> _openTrackingLink() async {
    final uid = AppConfig.extractTrackingUid(_trackingCodeController.text);
    if (uid == null || uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a tracking code or shared link.')),
      );
      return;
    }

    await Navigator.pushNamed(
      context,
      '/track',
      arguments: SosMapArgs(trackUid: uid),
    );
  }

  Widget _buildStatusPill({
    required IconData icon,
    required String label,
    required bool active,
  }) {
    final color = active ? const Color(0xFF71D6C9) : const Color(0xFF8DA3BF);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: active ? 0.18 : 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Map<String, dynamic> _trackingData(DatabaseEvent? event) {
    final value = event?.snapshot.value;
    if (value is Map) {
      return value.map(
        (key, entry) => MapEntry(key.toString(), entry),
      );
    }
    return const {};
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
        final trackingLink = AppConfig.buildTrackingLink(user.uid);

        return StreamBuilder<DatabaseEvent>(
          stream: _tracking.watchLocation(user.uid),
          builder: (context, trackingSnap) {
            final trackingData = _trackingData(trackingSnap.data);
            final isTracking = trackingData['isTracking'] == true ||
                (_tracking.isTracking && _tracking.activeUid == user.uid);
            final isRunMode = trackingData['isRunMode'] == true;
            final isSosActive = trackingData['isSosActive'] == true;
            final updatedAt = trackingData['updatedAt'];

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
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF07111E), Color(0xFF12324A), Color(0xFF2B1520)],
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
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0x33F4B942),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'Live Safety Dashboard',
                                style: TextStyle(
                                  color: Color(0xFFF4D089),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Stay safe, $name',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'One tap activates live location sharing for your emergency network and the RunSOS community.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _buildStatusPill(
                                  icon: Icons.gps_fixed,
                                  label: isTracking ? 'Tracking on' : 'Tracking off',
                                  active: isTracking,
                                ),
                                _buildStatusPill(
                                  icon: Icons.directions_run,
                                  label: isRunMode ? 'Run mode' : 'Idle mode',
                                  active: isRunMode,
                                ),
                                _buildStatusPill(
                                  icon: Icons.warning_amber_rounded,
                                  label: isSosActive ? 'SOS active' : 'SOS ready',
                                  active: isSosActive,
                                ),
                              ],
                            ),
                            if (updatedAt != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                'Last location update: ${DateTime.fromMillisecondsSinceEpoch((updatedAt as num).toInt()).toLocal()}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SosButton(
                        onPressed: _busy ? null : () => _startSosCountdown(name),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'A 5-second countdown will appear before the alert is sent.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: _busy ? null : _toggleTracking,
                      icon: Icon(isTracking
                          ? Icons.stop_circle_outlined
                          : Icons.play_circle_outline),
                      label: Text(
                        isTracking ? 'Stop Tracking' : 'Start Tracking',
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed:
                          _busy ? null : () => Navigator.pushNamed(context, '/run'),
                      icon: const Icon(Icons.directions_run),
                      label: const Text('Run Mode'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/track',
                          arguments: SosMapArgs(trackUid: user.uid),
                        );
                      },
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('Open My Live Map'),
                    ),
                    if (isSosActive) ...[
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: _busy
                            ? null
                            : () async {
                                final messenger = ScaffoldMessenger.of(context);
                                await _sos.clearSos();
                                if (!mounted) return;
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('SOS state cleared.'),
                                  ),
                                );
                              },
                        icon: const Icon(Icons.shield_outlined),
                        label: const Text('Mark SOS Resolved'),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Live tracking access',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            SelectableText(
                              trackingLink,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _trackingCodeController,
                              decoration: const InputDecoration(
                                labelText: 'Open a shared tracking link or code',
                                hintText: 'Paste uid or https://runsos.app/track?uid=...',
                              ),
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: _openTrackingLink,
                              icon: const Icon(Icons.travel_explore),
                              label: const Text('Open Shared Tracking'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_busy) const LinearProgressIndicator(minHeight: 2),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
