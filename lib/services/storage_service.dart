import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class StorageService {
  Future<String> subirFotoPerfil(String uid) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (picked == null) return '';

      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('$uid.jpg'); // ← mismo uid = sobreescribe automático

      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        await ref.putData(bytes); // ← web usa bytes
      } else {
        await ref.putFile(File(picked.path)); // ← móvil usa File
      }

      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error subiendo foto: $e');
      return '';
    }
  }
}
