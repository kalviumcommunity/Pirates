import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage;

  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadProfilePhoto({
    required String uid,
    required File file,
  }) async {
    final ref = _storage.ref('users/$uid/profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}
