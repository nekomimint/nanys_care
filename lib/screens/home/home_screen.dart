import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/screens_by_role_.dart';
import 'parent/parent_home_screen.dart';
import 'caregiver/caregiver_home_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  int _homeRefreshKey = 0;
  int _notificationsRefreshKey = 0;
  void _onItemTapped(int index) {
    setState(() {
      if (index == 0 && _selectedIndex == 0) {
        _homeRefreshKey++;
      }
      if (index == 1)
        _notificationsRefreshKey++; // ← siempre refresca al tocar notis
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeContent = switch (widget.user.role) {
      'parent' => ParentHomeScreen(
        user: widget.user,
        onProfileTap: () => _onItemTapped(3),
      ),
      'caregiver' => CaregiverHomeScreen(
        key: ValueKey(_homeRefreshKey), // ← fuerza rebuild
        user: widget.user,
        onProfileTap: () => _onItemTapped(3),
      ),
      _ => const Center(child: Text('Rol desconocido')),
    };

    final screens = ScreensByRole.get(
      user: widget.user,
      homeContent: homeContent,
      notificationsKey: _notificationsRefreshKey, // ← pásalo
    );

    return Scaffold(
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        role: widget.user.role,
      ),
      body: IndexedStack(index: _selectedIndex, children: screens),
    );
  }
}
