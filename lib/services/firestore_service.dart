import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addNote(String uid, String text) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('notes')
        .add({
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getNotes(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('notes')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> deleteNote(String uid, String docId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('notes')
        .doc(docId)
        .delete();
  }
}
