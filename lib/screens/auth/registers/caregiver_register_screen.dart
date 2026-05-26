import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../../../services/storage_service.dart';

import '../../../models/user_model.dart';

import '../../home_screen.dart';

class CaregiverRegisterScreen extends StatefulWidget {
  const CaregiverRegisterScreen({super.key});

  @override
  State<CaregiverRegisterScreen> createState() =>
      _CaregiverRegisterScreenState();
}

class _CaregiverRegisterScreenState extends State<CaregiverRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _experienciaSeleccionada;
  // UserModel fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // CaregiverModel fields
  final _experienceController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _experienceController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  XFile? _fotoTemporal; // ← guarda la foto seleccionada
  String _photoUrl = '';
  final _storageService = StorageService();

  Future<void> _seleccionarFoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (picked == null) return;

    setState(() {
      _fotoTemporal = picked; // ← solo guardamos, no subimos aún
    });
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final uid = result.user!.uid;

      // Subir foto si seleccionó una
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

        _photoUrl = await ref.getDownloadURL();
      }

      // Ahora sí guardar en Firestore con la URL
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': 'caregiver',
        'photoUrl': _photoUrl, // ← ya tiene la URL o vacío si no subió foto
      });

      // 2. Documento en 'caregivers'
      await FirebaseFirestore.instance.collection('caregivers').doc(uid).set({
        'uid': uid,
        'name': _nameController.text.trim(),
        'experience': _experienciaSeleccionada ?? '',
        'price': int.tryParse(_priceController.text.trim()) ?? 0,
        'rating': 0.0, // empieza en 0
        'availability': [], // se llena después
        'reviews': [], // se llena después
      });

      final userModel = UserModel(
        uid: uid,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        role: 'caregiver',
        photoUrl: '',
      );

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: userModel)),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      print('ERROR FirebaseAuth: ${e.code} - ${e.message}');

      String mensaje;
      switch (e.code) {
        case 'email-already-in-use':
          mensaje = 'Este correo ya está registrado';
          break;
        case 'invalid-email':
          mensaje = 'El correo no es válido';
          break;
        case 'weak-password':
          mensaje = 'La contraseña es muy débil';
          break;
        default:
          mensaje = e.message ?? 'Error al crear cuenta';
      }

      // El showDialog va FUERA del switch, siempre se ejecuta
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Advertencia'),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Validator genérico reutilizable
  String? _validator(String? value) {
    if (value == null || value.isEmpty) return 'Este campo es requerido';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Información')),
      body: SingleChildScrollView(
        // ← sin crossAxisAlignment
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // ← aquí
            children: [
              GestureDetector(
                onTap: _seleccionarFoto,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _fotoTemporal != null
                      ? kIsWeb
                            ? NetworkImage(_fotoTemporal!.path) // web
                            : FileImage(File(_fotoTemporal!.path))
                                  as ImageProvider // móvil
                      : null,
                  child: _fotoTemporal == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              Text("Nombre:", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                validator: _validator,
                decoration: const InputDecoration(
                  hintText: 'Nombre completo...',
                ),
              ),

              const SizedBox(height: 16),
              Text("Correo electrónico:", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: _validator,
                decoration: const InputDecoration(hintText: 'user@name.domain'),
              ),
              const SizedBox(height: 16),
              Text("Contraseña:", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (v) =>
                    v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
                decoration: const InputDecoration(hintText: 'Escribe aqui...'),
              ),
              const SizedBox(height: 16),
              Text("Experiencia:", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _experienciaSeleccionada,
                validator: (v) =>
                    v == null ? 'Selecciona tu experiencia' : null,
                decoration: const InputDecoration(hintText: 'Selecciona...'),
                items: const [
                  DropdownMenuItem(value: '1+ años', child: Text('1+ años')),
                  DropdownMenuItem(value: '3+ años', child: Text('3+ años')),
                  DropdownMenuItem(value: '5+ años', child: Text('5+ años')),
                ],
                onChanged: (value) =>
                    setState(() => _experienciaSeleccionada = value),
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
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => _createAccount(),
                      child: const Text('Crear cuenta'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
