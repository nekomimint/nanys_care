import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  //* Iniciar sesion con google sin guardar el rol
  Future<void> guardarPerfilSiEsNuevo(User user, {String? nombre}) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final existe = await doc.get();

    if (!existe.exists) {
      await doc.set({
        'uid': user.uid,
        'email': user.email,
        'name': nombre ?? user.displayName ?? '',
        'photoUrl': user.photoURL ?? '',
        'role': '', // ← vacío, se llena después
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
