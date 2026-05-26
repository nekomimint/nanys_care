import 'package:flutter/material.dart';
import '../../../services/booking_service.dart';
import '../../../models/booking_model.dart';
import 'package:intl/intl.dart';
import '../../booking/booking_request_screen.dart';
import '../../agenda/agenda_screen.dart';

class CaregiverHomeScreen extends StatefulWidget {
  const CaregiverHomeScreen({super.key});

  @override
  State<CaregiverHomeScreen> createState() => _CaregiverHomeScreenState();
}

class _CaregiverHomeScreenState extends State<CaregiverHomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFFAC7099);

    final screens = [
      _buildHomeContent(),

      const Center(child: Text('Notificaciones')),

      const Center(child: Text('Perfil cuidador')),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,

        onTap: _onItemTapped,

        type: BottomNavigationBarType.fixed,

        selectedItemColor: primaryPurple,

        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notis',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Agenda',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),

      body: IndexedStack(index: _selectedIndex, children: screens),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
            padding: const EdgeInsets.all(20),

            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,

                  backgroundColor: Colors.pink.withOpacity(0.2),

                  child: const Icon(Icons.person, color: Colors.pink),
                ),

                const Spacer(),

                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Text(
                      'Hola, María',

                      style: TextStyle(
                        fontWeight: FontWeight.bold,

                        fontSize: 18,
                      ),
                    ),

                    Text(
                      'Solicitudes recibidas',

                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 15),

            child: Text(
              'Solicitudes pendientes',

              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
