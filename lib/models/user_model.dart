// models/user_model.dart
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role; // 'admin', 'parent', 'caregiver'
  final String photoUrl;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.photoUrl,
  });

  // Convierte el documento de Firestore a UserModel
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'parent',
      photoUrl: data['photoUrl'] ?? '',
    );
  }
}
