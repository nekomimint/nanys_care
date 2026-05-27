class ChildrenModel {
  final String uid;
  final String uidFather;
  final String name;
  final int age;
  final String description;
  final bool active;

  const ChildrenModel({
    required this.uid,
    required this.uidFather,
    required this.name,
    required this.age,
    required this.description,
    this.active = true,
  });

  factory ChildrenModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return ChildrenModel(
      uid: uid,
      uidFather: data['uid_father'] ?? '',
      name: data['name'] ?? '',
      age: data['age'] ?? 1,
      description: data['description'] ?? '',
      active: data['active'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid_father': uidFather,
      'name': name,
      'age': age,
      'description': description,
      'active': active,
    };
  }
}
