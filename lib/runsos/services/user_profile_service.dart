import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';

class UserProfileService {
  final FirebaseFirestore _firestore;

  UserProfileService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  Future<UserProfile?> getProfile(String uid) async {
    final snapshot = await _userDoc(uid).get();
    if (!snapshot.exists) {
      return null;
    }
    final data = snapshot.data();
    if (data == null) {
      return null;
    }
    return UserProfile.fromJson(data);
  }

  Stream<UserProfile?> watchProfile(String uid) {
    return _userDoc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      final data = snapshot.data();
      if (data == null) {
        return null;
      }
      return UserProfile.fromJson(data);
    });
  }

  Future<void> upsertProfile({
    required UserProfile profile,
  }) async {
    await _userDoc(profile.uid).set(
      {
        ...profile.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'lastSeenAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> updateLastSeen(String uid) async {
    await _userDoc(uid).set(
      {'lastSeenAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  Future<void> upsertPhoneIndex({
    required String e164Phone,
    required String uid,
  }) async {
    await _firestore.collection('phone_index').doc(e164Phone).set({
      'uid': uid,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
