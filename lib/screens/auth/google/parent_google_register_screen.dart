import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/user_model.dart';
import '../../home_screen.dart';

class ParentGoogleRegisterScreen extends StatefulWidget {
  final UserModel user;
  const ParentGoogleRegisterScreen({super.key, required this.user});

  @override
  State<ParentGoogleRegisterScreen> createState() =>
      _ParentGoogleRegisterScreenState();
}

class _ParentGoogleRegisterScreenState
    extends State<ParentGoogleRegisterScreen> {
  bool _isLoading = false;
  late final _nameController = TextEditingController(
    text: widget.user.name,
  ); // ← agregar

  @override
  void dispose() {
    _nameController.dispose(); // ← agregar
    super.dispose();
  }

  Future<void> _completarPerfil() async {
    setState(() => _isLoading = true);
    try {
      final nombre = _nameController.text.trim(); // ← usar el controller

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({
            'role': 'parent',
            'name': nombre, // ← actualizar nombre también
          });

      final userModel = UserModel(
        uid: widget.user.uid,
        name: nombre, // ← usar el nombre editado
        email: widget.user.email,
        role: 'parent',
        photoUrl: widget.user.photoUrl,
      );

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(user: userModel)),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar perfil')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: widget.user.photoUrl.isNotEmpty
                  ? NetworkImage(widget.user.photoUrl)
                  : null,
              child: widget.user.photoUrl.isEmpty
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 24),
            TextFormField(
              // ← campo editable de nombre
              controller: _nameController,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Tu nombre',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.user.email,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 40),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _completarPerfil,
                    child: const Text('Confirmar como Tutor'),
                  ),
          ],
        ),
      ),
    );
  }
}
