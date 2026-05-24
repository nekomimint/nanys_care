import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../../../models/user_model.dart';

class AdminProfile extends StatelessWidget {
  final UserModel user;
  const AdminProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(user.photoUrl)),
          const SizedBox(width: 12),
          Text(user.name),
          Text("Esto es de admins"),
        ],
      ),
    );
  }
}
