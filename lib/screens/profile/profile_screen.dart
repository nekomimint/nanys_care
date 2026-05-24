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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 15, 134, 57),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _cambiarFoto,
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: AppColors.primary,
                      backgroundImage: _photoUrl.isNotEmpty
                          ? NetworkImage(_photoUrl)
                          : null,
                      child: _photoUrl.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        switch (widget.user.role) {
                          'admin' => 'Admin: ${widget.user.name}',
                          'caregiver' => 'Cuidador: ${widget.user.name}',
                          _ => 'Tutor: ${widget.user.name}',
                        },
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.user.email,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
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
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
