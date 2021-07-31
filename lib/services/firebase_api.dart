import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FireBaseApi {
  static UploadTask uploadFile(String destenation, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destenation);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }
}
