// models/user_model.dart
class UserModel {
  final String uidFather;
  final String name;
  final int age;
  final String description;

  const UserModel({
    required this.uidFather,
    required this.name,
    required this.age,
    required this.description,
  });

  // Convierte el documento de Firestore a UserModel
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uidFather: data['uid_father'] ?? '',
      name: data['name'] ?? '',
      age: data['age'] ?? 1,
      description: data['role'] ?? 'Nada',
    );
  }
}
