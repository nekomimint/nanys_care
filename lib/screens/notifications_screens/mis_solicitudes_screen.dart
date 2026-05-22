import 'package:flutter/material.dart';

import 'citas_proximas_screen.dart';
import 'citas_pasadas_screen.dart';




class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colores basados en tu imagen de referencia
    const headerColor = Color(0xFFAC7099); // ESTE ES LA CABECERA
    const backgroundColor = Color(0xFFF3F8F7); // Fondo claro del contenido
    const pendingColor = Color(0xFFC93B3B); // Rojo del botón "PENDIENTE"

    // Datos simulados para las tarjetas
    final List<Map<String, dynamic>> solicitudes = [
      {'nombre': 'Sarah B.', 'rating': '4.5', 'foto': 'https://i.pravatar.cc/150?img=47'},
      {'nombre': 'Michael K.', 'rating': '4.3', 'foto': 'https://i.pravatar.cc/150?img=33'},
      {'nombre': 'Olivia P.', 'rating': '4.5', 'foto': 'https://i.pravatar.cc/150?img=49'},
    ];

    return DefaultTabController(
      length: 3, // Tres secciones: Mis solicitudes, citas próximas, citas pasadas
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: headerColor,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Notificaciones',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          // Aquí va la barra de pestañas superior personalizada
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            tabs: [
              Tab(text: 'Mis solicitudes'),
              Tab(text: 'citas próximas'),
              Tab(text: 'citas pasadas'),
            ],
          ),
        ),
        
        // ###################################################
        // EN ESTA PARTE SE CONECTAN LAS OTRAS PANTALLAS
        // ####################################################
        body: TabBarView(
          children: [
            // Mis solicitures (la actual)
            _buildSolicitudesList(solicitudes, pendingColor),
            
            // Mis citas proximas 
            const CitasProximasScreen(),
            
            // Mis citas passadas
            const CitasPasadasScreen(),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para construir la lista de solicitudes (tarjetas)
  Widget _buildSolicitudesList(List<Map<String, dynamic>> items, Color badgeColor) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
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
                // Imagen de perfil con el mini-avatar superpuesto abajo a la derecha
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        item['foto']!,
                        width: 75,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1.5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage(item['foto']!),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 16),
                
                // Detalles: Nombre, Estrellas y Calificación
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['nombre']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.grey.shade300, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '(${item['rating']})',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Botón "PENDIENTE"
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'PENDIENTE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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