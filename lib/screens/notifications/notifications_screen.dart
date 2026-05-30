import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../notifications/parent/parent_notifications_screen.dart';
import '../notifications/caregiver/caregiver_notifications_screen.dart';

class NotificationsScreen extends StatelessWidget {
  final UserModel user;
  const NotificationsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return switch (user.role) {
      'parent' => ParentNotificationsScreen(user: user),
      'caregiver' => CaregiverNotificationsScreen(user: user),
      _ => const Scaffold(body: Center(child: Text('Rol desconocido'))),
    };
  }
}
