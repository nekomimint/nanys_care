import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final String role;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFFAC7099);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryPurple,
      unselectedItemColor: Colors.grey,
      items: _itemsByRole(role),
    );
  }

  List<BottomNavigationBarItem> _itemsByRole(String role) {
    return switch (role) {
      'caregiver' => const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notis',
        ),

        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
      'admin' => const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Usuarios'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
      _ => const [
        // parent por defecto
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notis',
        ),

        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    };
  }
}
