// models/user_model.dart
class ChildrenModel {
  final String uidFather;
  final String name;
  final int age;
  final String description;

  const ChildrenModel({
    required this.uidFather,
    required this.name,
    required this.age,
    required this.description,
  });

  // Convierte el documento de Firestore a UserModel
  factory ChildrenModel.fromFirestore(Map<String, dynamic> data) {
    return ChildrenModel(
      uidFather: data['uid_father'] ?? '',
      name: data['name'] ?? '',
      age: data['age'] ?? 1,
      description: data['description'] ?? 'Nada',
    );
  }
}
