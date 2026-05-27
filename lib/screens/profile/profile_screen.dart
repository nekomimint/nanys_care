import 'package:flutter/material.dart';
//* Paquetes de Firebase
import '../../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/storage_service.dart';
//* Importar screens
import './admin/admin_profile.dart';
import './caregiver/caregiver_profile.dart';
import './parent/parent_profile.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/greetin_header.dart';
import '../../widgets/profile_options/option_profile.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _photoUrl;
  final _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _photoUrl = widget.user.photoUrl; // ← ya viene de Firestore
  }

  Future<void> _cambiarFoto() async {
    try {
      final url = await _storageService.subirFotoPerfil(widget.user.uid);
      if (url.isEmpty) return;

      // Guardar URL en Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({'photoUrl': url});

      // Actualizar Auth también
      await FirebaseAuth.instance.currentUser?.updatePhotoURL(url);

      // Actualizar UI
      setState(() {
        _photoUrl = url;
      });
    } catch (e) {
      print('Error cambiando foto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // ← separa los hijos
                children: [
                  // En home_screen.dart o donde uses GreetingHeader
                  GreetingHeader(
                    name: widget.user.name, // ← solo el nombre, sin rol
                    photoUrl: widget.user.photoUrl,
                    onPhotoTap: () => _cambiarFoto(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            switch (widget.user.role) {
              'admin' => AdminProfile(user: widget.user),
              'parent' => ParentProfile(user: widget.user),
              'caregiver' => CaregiverProfile(user: widget.user),
              _ => const Center(child: Text('Rol desconocido')),
            },
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: OptionProfile(
                user: widget.user,
                icon: Icons.logout,
                titleButton: 'Cerrar sesión',
                color: Colors.white,
                backgroundColor: Color.fromARGB(255, 255, 79, 79),
                onTap: () async => await FirebaseAuth.instance.signOut(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
