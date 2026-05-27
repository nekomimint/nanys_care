import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'citas_proximas_screen.dart';
import 'citas_pasadas_screen.dart';

class NotificationsScreen extends StatelessWidget {
  final UserModel user;
  const NotificationsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    const headerColor     = Color(0xFF0F8639);
    const backgroundColor = Color(0xFFF5EDE8);
    const accentPurple    = Color(0xFFAC7099);
    const pendingRed      = Color(0xFFC93B3B);

    final List<Map<String, dynamic>> solicitudes = [
      {'nombre': 'Sarah B.', 'rating': 4.5},
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: headerColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Notificaciones',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            tabs: [
              Tab(text: 'Mis solicitudes'),
              Tab(text: 'Citas próximas'),
              Tab(text: 'Citas pasadas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSolicitudesList(solicitudes, pendingRed, accentPurple, backgroundColor),
            CitasProximasScreen(user: user),
            CitasPasadasScreen(user: user),
          ],
        ),
      ),
    );
  }

  Widget _buildSolicitudesList(
    List<Map<String, dynamic>> items,
    Color badgeColor,
    Color accentPurple,
    Color backgroundColor,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final double rating = item['rating'];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Avatar genérico
                CircleAvatar(
                  radius: 37,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.person, size: 38, color: Colors.grey),
                ),
                const SizedBox(width: 16),

                // Nombre y estrellas
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['nombre'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ...List.generate(5, (i) => Icon(
                            Icons.star,
                            size: 16,
                            color: i < rating.floor()
                                ? Colors.amber
                                : Colors.grey.shade300,
                          )),
                          const SizedBox(width: 4),
                          Text(
                            '($rating)',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Badge PENDIENTE
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'PENDIENTE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}