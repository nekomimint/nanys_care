import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // ─── LOGIN CON GOOGLE ───────────────────────────────────────
  Future<User?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null; // usuario canceló

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result = await _auth.signInWithCredential(credential);
    await _handleUserProfile(
      result.user,
      result.additionalUserInfo?.isNewUser ?? false,
    );
    return result.user;
  }

  // ─── REGISTRO CON EMAIL ─────────────────────────────────────
  Future<User?> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Actualizar displayName en Auth también
    await result.user?.updateDisplayName(name);

    await _handleUserProfile(
      result.user,
      true, // siempre es nuevo
      overrideName: name,
    );
    return result.user;
  }

  // ─── LOGIN CON EMAIL ────────────────────────────────────────
  Future<User?> signInWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // No recreamos perfil, solo lo actualizamos si falta algo
    await _handleUserProfile(result.user, false);
    return result.user;
  }

  // ─── LÓGICA CENTRAL DE PERFILES ─────────────────────────────
  Future<void> _handleUserProfile(
    User? user,
    bool isNewUser, {
    String? overrideName,
  }) async {
    if (user == null) return;

    final docRef = _db.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists || isNewUser) {
      // Construir perfil con lo que Firebase nos da
      // Google llena todo; email deja vacíos que tú llenaste
      await docRef.set({
        'uid': user.uid,
        'email': user.email,
        'name': overrideName ?? user.displayName ?? '',
        'photoUrl': user.photoURL ?? '',
        'provider':
            user.providerData.first.providerId, // 'google.com' o 'password'
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        // Campos extra que tú manejas
        'bio': '',
        'username': '',
      }, SetOptions(merge: true)); // merge: true para no pisar datos existentes
    }
  }
}
