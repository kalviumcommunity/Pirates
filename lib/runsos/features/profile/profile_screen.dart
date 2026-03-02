import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/emergency_contact.dart';
import '../../models/user_profile.dart';
import '../../services/emergency_contacts_service.dart';
import '../../services/storage_service.dart';
import '../../services/user_profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profiles = UserProfileService();
  final _contacts = EmergencyContactsService();
  final _storage = StorageService();

  final _nameController = TextEditingController();
  final _bloodController = TextEditingController();

  bool _saving = false;
  String? _photoUrl;

  @override
  void dispose() {
    _nameController.dispose();
    _bloodController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile(String uid, String? phone) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name is required.')),
      );
      return;
    }

    setState(() => _saving = true);

    final profile = UserProfile(
      uid: uid,
      name: name,
      phoneNumber: phone,
      bloodGroup: _bloodController.text.trim().isEmpty
          ? null
          : _bloodController.text.trim(),
      photoUrl: _photoUrl,
    );

    await _profiles.upsertProfile(profile: profile);

    setState(() => _saving = false);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> _pickAndUploadPhoto(String uid) async {
    final picker = ImagePicker();
    final img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (img == null) {
      return;
    }

    setState(() => _saving = true);

    final url = await _storage.uploadProfilePhoto(
      uid: uid,
      file: File(img.path),
    );

    setState(() {
      _photoUrl = url;
      _saving = false;
    });
  }

  Future<void> _showContactDialog({
    required String uid,
    EmergencyContact? existing,
  }) async {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final phoneController =
        TextEditingController(text: existing?.phoneNumber ?? '');
    final relController =
        TextEditingController(text: existing?.relationship ?? '');

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existing == null ? 'Add Contact' : 'Edit Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  hintText: '+15551234567',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: relController,
                decoration: const InputDecoration(
                  labelText: 'Relationship (optional)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (saved != true) {
      return;
    }

    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final rel = relController.text.trim().isEmpty ? null : relController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and phone are required.')),
      );
      return;
    }

    if (existing == null) {
      await _contacts.addContact(
        uid: uid,
        name: name,
        phoneNumber: phone,
        relationship: rel,
      );
    } else {
      await _contacts.updateContact(
        uid: uid,
        contactId: existing.id,
        name: name,
        phoneNumber: phone,
        relationship: rel,
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

        if (profile != null && _nameController.text.isEmpty) {
          _nameController.text = profile.name;
          _bloodController.text = profile.bloodGroup ?? '';
          _photoUrl ??= profile.photoUrl;
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Your Profile')),
          body: AbsorbPointer(
            absorbing: _saving,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: InkWell(
                    onTap: () => _pickAndUploadPhoto(user.uid),
                    child: CircleAvatar(
                      radius: 44,
                      backgroundImage:
                          _photoUrl == null ? null : NetworkImage(_photoUrl!),
                      child: _photoUrl == null
                          ? const Icon(Icons.person, size: 44)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    user.phoneNumber ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _bloodController,
                  decoration: const InputDecoration(
                    labelText: 'Blood group (optional)',
                    hintText: 'O+, A-, ...',
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () => _saveProfile(user.uid, user.phoneNumber),
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Continue'),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Emergency Contacts',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      onPressed: () => _showContactDialog(uid: user.uid),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                StreamBuilder<List<EmergencyContact>>(
                  stream: _contacts.watchContacts(user.uid),
                  builder: (context, contactsSnap) {
                    final contacts = contactsSnap.data ?? const [];
                    if (contacts.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text('Add at least one contact for SOS alerts.'),
                      );
                    }

                    return Column(
                      children: contacts.map((c) {
                        return ListTile(
                          title: Text(c.name),
                          subtitle: Text(
                            [c.phoneNumber, if (c.relationship != null) c.relationship!]
                                .join(' • '),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () =>
                                    _showContactDialog(uid: user.uid, existing: c),
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () => _contacts.deleteContact(
                                  uid: user.uid,
                                  contactId: c.id,
                                ),
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
