import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../models/user_model.dart';

class EditProfileSheet extends StatefulWidget {
  final UserModel user;
  const EditProfileSheet({super.key, required this.user});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _passwordController;
  bool _loading = false;
  bool _showPassword = false;
  XFile? _fotoTemporal;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (picked == null) return;
    setState(() => _fotoTemporal = picked);
  }

  Future<void> _save() async {
    if (_nameController.text.isEmpty) return;
    setState(() => _loading = true);

    try {
      final uid = widget.user.uid;
      String photoUrl = widget.user.photoUrl;

      // 1. Subir nueva foto si seleccionó una
      if (_fotoTemporal != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child('$uid.jpg');

        if (kIsWeb) {
          final bytes = await _fotoTemporal!.readAsBytes();
          await ref.putData(bytes);
        } else {
          await ref.putFile(File(_fotoTemporal!.path));
        }
        photoUrl = await ref.getDownloadURL();
        await FirebaseAuth.instance.currentUser?.updatePhotoURL(photoUrl);
      }

      // 2. Actualizar nombre en Auth
      await FirebaseAuth.instance.currentUser?.updateDisplayName(
        _nameController.text.trim(),
      );

      // 3. Actualizar contraseña si escribió una nueva
      if (_passwordController.text.isNotEmpty) {
        if (_passwordController.text.length < 6) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Mínimo 6 caracteres')));
          setState(() => _loading = false);
          return;
        }
        await FirebaseAuth.instance.currentUser?.updatePassword(
          _passwordController.text.trim(),
        );
      }

      // 4. Actualizar Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': _nameController.text.trim(),
        'photoUrl': photoUrl,
      });

      if (mounted) Navigator.of(context).pop(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Sesión expirada'),
            content: const Text(
              'Para cambiar la contraseña necesitas volver a iniciar sesión.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
        if (confirm == true) {
          await FirebaseAuth.instance.signOut();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Error al actualizar')),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Editar perfil',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Foto de perfil
          Center(
            child: GestureDetector(
              onTap: _seleccionarFoto,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: _fotoTemporal != null
                        ? kIsWeb
                              ? NetworkImage(_fotoTemporal!.path)
                              : FileImage(File(_fotoTemporal!.path))
                                    as ImageProvider
                        : widget.user.photoUrl.isNotEmpty
                        ? NetworkImage(widget.user.photoUrl)
                        : null,
                    child: _fotoTemporal == null && widget.user.photoUrl.isEmpty
                        ? const Icon(Icons.person, size: 45)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Nombre
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          const SizedBox(height: 12),

          // Email — solo lectura
          TextField(
            enabled: false,
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
              hintText: widget.user.email,
              suffixIcon: const Icon(Icons.lock_outline, size: 16),
            ),
          ),
          const SizedBox(height: 12),

          // Contraseña
          TextField(
            controller: _passwordController,
            obscureText: !_showPassword,
            decoration: InputDecoration(
              labelText: 'Nueva contraseña',
              hintText: 'Dejar vacío para no cambiar',
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => setState(() => _showPassword = !_showPassword),
              ),
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _save,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar cambios'),
            ),
          ),
        ],
      ),
    );
  }
}
