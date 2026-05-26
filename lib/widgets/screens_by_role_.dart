import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/agenda/agenda_screen.dart';

class ScreensByRole {
  static List<Widget> get({
    required UserModel user,
    required Widget homeContent,
  }) {
    return switch (user.role) {
      'caregiver' => [
        homeContent,
        const Center(child: Text('Notificaciones')),
        AgendaScreen(user: user),
        ProfileScreen(user: user),
      ],
      'admin' => [
        homeContent,
        const Center(child: Text('Usuarios')),
        const Center(child: Text('Stats')),
        ProfileScreen(user: user),
      ],
      _ => [
        // parent
        homeContent,
        const Center(child: Text('Notificaciones')),
        AgendaScreen(user: user),
        ProfileScreen(user: user),
      ],
    };
  }
}
