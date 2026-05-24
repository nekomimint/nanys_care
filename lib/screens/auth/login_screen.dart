import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // Iniciar sesion con email
  Future<void> signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await _authService.guardarPerfilSiEsNuevo(result.user!);
    } on FirebaseAuthException catch (e) {
      String message = 'Error al iniciar sesión';
      if (e.code == 'user-not-found') message = 'Usuario no encontrado';
      if (e.code == 'wrong-password') message = 'Contraseña incorrecta';
      if (e.code == 'invalid-email') message = 'Correo inválido';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  // Iniciar sesion con Google
  Future<void> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        final result = await FirebaseAuth.instance.signInWithPopup(provider);
        await _authService.guardarPerfilSiEsNuevo(result.user!);
        return;
      }

      // Flujo móvil
      final googleUser = await GoogleSignIn.instance.authenticate();
      final idToken = googleUser.authentication.idToken;
      final authorization = await googleUser.authorizationClient
          .authorizationForScopes(['email', 'profile']);
      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: authorization?.accessToken,
      );
      final result = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      await _authService.guardarPerfilSiEsNuevo(result.user!);
    } on GoogleSignInException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error Google: ${e.code}')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Correo'),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: signInWithEmail,
                      child: const Text('Entrar'),
                    ),

                    const SizedBox(height: 16),

                    OutlinedButton.icon(
                      onPressed: signInWithGoogle,
                      icon: const Icon(Icons.login),
                      label: const Text('Iniciar con Google'),
                    ),
                    // Dentro del Column del Form, después del botón de Google:
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      ),
                      child: const Text('¿No tienes cuenta? Regístrate'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
