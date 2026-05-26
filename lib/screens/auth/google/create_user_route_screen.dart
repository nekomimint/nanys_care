import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './caregiver_google_register_screen.dart';
import './parent_google_register_screen.dart';

import '../../../models/user_model.dart';

class CreateUserRouteScreen extends StatefulWidget {
  const CreateUserRouteScreen({super.key});

  @override
  State<CreateUserRouteScreen> createState() => _CreateUserRouteScreen();
}

class _CreateUserRouteScreen extends State<CreateUserRouteScreen> {
  // Obtienes el usuario actual de Firebase directo
  final _user = FirebaseAuth.instance.currentUser!;
  UserModel get _userModel => UserModel(
    uid: _user.uid,
    email: _user.email ?? '',
    name: _user.displayName ?? '',
    photoUrl: _user.photoURL ?? '',
    role: '',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrarse')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //* Titulo de seleccionar tipo de rol:
                  Text("¿Qué planeas hacer?"),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CaregiverGoogleRegisterScreen(user: _userModel),
                        ),
                      );
                    },
                    child: const Text("Cuidador"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ParentGoogleRegisterScreen(user: _userModel),
                        ),
                      );
                    },
                    child: const Text("Tutor"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
