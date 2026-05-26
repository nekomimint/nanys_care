import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/user_model.dart';
import '../../home_screen.dart';

class CaregiverGoogleRegisterScreen extends StatefulWidget {
  final UserModel user;
  const CaregiverGoogleRegisterScreen({super.key, required this.user});

  @override
  State<CaregiverGoogleRegisterScreen> createState() =>
      _CaregiverGoogleRegisterScreenState();
}

class _CaregiverGoogleRegisterScreenState
    extends State<CaregiverGoogleRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  late final _nameController = TextEditingController(
    text: widget.user.name,
  ); // ← autocompletado
  final _experienceController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _experienceController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) return 'Este campo es requerido';
    return null;
  }

  Future<void> _completarPerfil() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final uid = widget.user.uid;
      final nombre = _nameController.text.trim();

      // 1. Actualizar documento en 'users'
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': nombre,
        'role': 'caregiver',
      });

      // 2. Crear documento en 'caregivers'
      await FirebaseFirestore.instance.collection('caregivers').doc(uid).set({
        'uid': uid,
        'name': nombre,
        'experience': _experienceController.text.trim(),
        'price': int.tryParse(_priceController.text.trim()) ?? 0,
        'rating': 0.0,
        'availability': [],
        'reviews': [],
      });

      // 3. Construir userModel ← esto faltaba
      final userModel = UserModel(
        uid: uid,
        name: nombre,
        email: widget.user.email,
        role: 'caregiver',
        photoUrl: widget.user.photoUrl,
      );

      // 4. Navegar
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(user: userModel)),
          (route) => false,
        );
      }
      // app.dart detecta role != '' y manda a HomeScreen solo
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: userModel)),
        (route) => false,
      );
    } on FirebaseException catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.message ?? 'Error al guardar'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Completa tu perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Email bloqueado
              Text("Correo electrónico:", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: widget.user.email,
                enabled: false, // ← bloqueado
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),

              const SizedBox(height: 16),
              Text("Nombre:", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController, // ← autocompletado y editable
                validator: _validator,
                decoration: const InputDecoration(hintText: 'Nombre completo'),
              ),

              const SizedBox(height: 16),
              Text("Experiencia:", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _experienceController,
                validator: _validator,
                decoration: const InputDecoration(hintText: 'Escribe aquí...'),
              ),

              const SizedBox(height: 16),
              Text("Precio / Hora:", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null
                    ? 'Ingresa un número válido'
                    : null,
                decoration: const InputDecoration(hintText: '150, 250, 300...'),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _completarPerfil,
                        child: const Text('Guardar perfil'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
