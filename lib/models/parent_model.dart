// models/user_model.dart
class ParentModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String role;
  const ParentModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.photoUrl,
  });

  // Convierte el documento de Firestore a UserModel
  factory ParentModel.fromFirestore(Map<String, dynamic> data) {
    return ParentModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'parent',
      photoUrl: data['photoUrl'] ?? '',
    );
  }
}
