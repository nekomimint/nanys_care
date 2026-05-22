import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import './models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<UserModel> _cargarUsuario(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    return UserModel.fromFirestore(doc.data()!);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth Demo',
      theme: AppTheme.light,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<UserModel>(
              future: _cargarUsuario(snapshot.data!.uid),
              builder: (context, userSnap) {
                // Error — muestra qué falló
                if (userSnap.hasError) {
                  return Scaffold(
                    body: Center(child: Text('Error: ${userSnap.error}')),
                  );
                }
                // Cargando
                if (!userSnap.hasData) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                // Listo
                return HomeScreen(user: userSnap.data!);
              },
            );
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
