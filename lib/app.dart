import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/google/create_user_route_screen.dart'; // ← import correcto
import 'screens/home_screen.dart';
import 'screens/caregiver_home_screen.dart';
import './models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  //* Obtener la info si hay sesion anterior
  Future<UserModel?> _cargarUsuario(String uid) async {
    // Intentar hasta 5 veces con delay entre cada intento
    for (int i = 0; i < 5; i++) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromFirestore(doc.data()!);
      }

      // Esperar antes del siguiente intento
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return null; // después de 5 intentos, rendirse
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
            return FutureBuilder<UserModel?>(
              // ← UserModel? con signo de interrogación
              future: _cargarUsuario(snapshot.data!.uid),
              builder: (context, userSnap) {
                if (userSnap.hasError) {
                  return Scaffold(
                    body: Center(child: Text('Error: ${userSnap.error}')),
                  );
                }
                if (!userSnap.hasData) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                final user = userSnap.data; // ← sin ! porque puede ser null

                if (user == null) {
                  // Doc aún no existe en Firestore, mostrar loading
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (user.role.isEmpty) {
                  return CreateUserRouteScreen();
                }
                return HomeScreen(user: user);
              },
            );
          }
          //* Si no existe ninguna sesion previa, o bien primera vez que abren:
          return const LoginScreen();
        },
      ),
    );
  }
}
