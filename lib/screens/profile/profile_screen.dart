import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';

import './admin/admin_profile.dart';
import './caregiver/caregiver_profile.dart';
import './parent/parent_profile.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user; // le pasas el usuario ya cargado

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            switch (user.role) {
              'admin' => AdminProfile(user: user),
              'parent' => ParentProfile(user: user),
              'caregiver' => CaregiverProfile(user: user),
              _ => const Center(child: Text('Rol desconocido')),
            },
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                // El StreamBuilder en app.dart detecta que no hay usuario
                // y regresa al LoginScreen automáticamente
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
