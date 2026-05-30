import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/agenda/agenda_screen.dart';
import '../screens/notifications/notifications_screen.dart';

class ScreensByRole {
  static List<Widget> get({
    required UserModel user,
    required Widget homeContent,
    int notificationsKey = 0, // ← parámetro opcional para no romper otros usos
  }) {
    return switch (user.role) {
      'caregiver' => [
        homeContent,
        NotificationsScreen(
          key: ValueKey(notificationsKey), // ← key aquí
          user: user,
        ),

        ProfileScreen(user: user),
      ],
      'parent' => [
        homeContent,
        NotificationsScreen(key: ValueKey(notificationsKey), user: user),

        ProfileScreen(user: user),
      ],
      _ => [
        homeContent,
        NotificationsScreen(key: ValueKey(notificationsKey), user: user),

        ProfileScreen(user: user),
      ],
    };
  }
}
