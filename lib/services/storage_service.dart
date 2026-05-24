import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart'; // kIsWeb

class StorageService {
  static const _cloudName = 'dcdnebce5';
  static const _uploadPreset = 'nanyscarephotos';

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

      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
      );
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = 'nanyscarephotos'
        ..fields['folder'] = 'profile_pictures'
        ..fields['public_id'] = '${uid}_$timestamp';

      if (kIsWeb) {
        // Web — leer como bytes
        final bytes = await picked.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes('file', bytes, filename: '$uid.jpg'),
        );
      } else {
        // Móvil — usar path
        request.files.add(
          await http.MultipartFile.fromPath('file', picked.path),
        );
      }

      final response = await request.send();
      final body = await response.stream.bytesToString();
      final json = jsonDecode(body);

      if (response.statusCode != 200) {
        print('Error Cloudinary: $body');
        return '';
      }

      return json['secure_url'] ?? '';
    } catch (e) {
      print('Error subiendo foto: $e');
      return '';
    }
  }
}
