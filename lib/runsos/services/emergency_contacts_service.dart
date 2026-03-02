import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/emergency_contact.dart';

class EmergencyContactsService {
  final FirebaseFirestore _firestore;

  EmergencyContactsService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _contactsCol(String uid) {
    return _firestore.collection('users').doc(uid).collection('emergencyContacts');
  }

  Stream<List<EmergencyContact>> watchContacts(String uid) {
    return _contactsCol(uid).orderBy('name').snapshots().map((snapshot) {
      return snapshot.docs
          .map((d) => EmergencyContact.fromJson(d.id, d.data()))
          .toList(growable: false);
    });
  }

  Future<void> addContact({
    required String uid,
    required String name,
    required String phoneNumber,
    String? relationship,
  }) async {
    await _contactsCol(uid).add({
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateContact({
    required String uid,
    required String contactId,
    required String name,
    required String phoneNumber,
    String? relationship,
  }) async {
    await _contactsCol(uid).doc(contactId).set({
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteContact({
    required String uid,
    required String contactId,
  }) async {
    await _contactsCol(uid).doc(contactId).delete();
  }

  Future<List<EmergencyContact>> listContactsOnce(String uid) async {
    final snapshot = await _contactsCol(uid).get();
    return snapshot.docs
        .map((d) => EmergencyContact.fromJson(d.id, d.data()))
        .toList(growable: false);
  }
}
