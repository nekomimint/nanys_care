import 'package:flutter/material.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Paleta de colores consistente con tus otros módulos (Cambiado al tono lila/rosa de tu AppBar)
    const headerColor = Color(0xFFAC7099); 
    const backgroundColor = Color(0xFFF3F8F7); 

    // Estructura de datos simulada con 4 elementos para permitir scroll vertical
    final List<Map<String, dynamic>> agendaItems = [
      {
        'nombre': 'Sarah B.',
        'rating': '4.5',
        'foto': 'https://i.pravatar.cc/150?img=47',
        'horarios': [
          'Lunes: Mañana (8am - 12pm)',
          'Miércoles: Tarde (5pm - 10pm)',
        ],
        // Añadidos más niños aquí para probar el deslizamiento hacia la derecha (Horizontal)
        'ninos': [
          {'nombre': 'Leo (8 meses)', 'foto': 'https://i.pravatar.cc/150?img=11'},
          {'nombre': 'Mía (2 años)', 'foto': 'https://i.pravatar.cc/150?img=10'},
          {'nombre': 'Hugo (1 año)', 'foto': 'https://i.pravatar.cc/150?img=12'},
          {'nombre': 'Emma (3 años)', 'foto': 'https://i.pravatar.cc/150?img=21'},
        ]
      },
      {
        'nombre': 'Michael K.',
        'rating': '4.3',
        'foto': 'https://i.pravatar.cc/150?img=33',
        'horarios': [
          'Martes: Mañana (8am - 12pm)',
          'Jueves: Tarde (5pm - 10pm)',
        ],
        'ninos': [
          {'nombre': 'Mía (4 años)', 'foto': 'https://i.pravatar.cc/150?img=26'},
        ]
      },
      {
        'nombre': 'Olivia P.',
        'rating': '4.8',
        'foto': 'https://i.pravatar.cc/150?img=49',
        'horarios': [
          'Viernes: Todo el día (9am - 6pm)',
        ],
        'ninos': [
          {'nombre': 'Santi (5 años)', 'foto': 'https://i.pravatar.cc/150?img=15'},
        ]
      },
      {
        'nombre': 'David L.',
        'rating': '4.6',
        'foto': 'https://i.pravatar.cc/150?img=68',
        'horarios': [
          'Sábado: Noche (7pm - 1am)',
        ],
        'ninos': [
          {'nombre': 'Sofía (6 meses)', 'foto': 'https://i.pravatar.cc/150?img=30'},
          {'nombre': 'Lucas (4 años)', 'foto': 'https://i.pravatar.cc/150?img=14'},
        ]
      },
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: headerColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Agenda',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: agendaItems.length,
        itemBuilder: (context, index) {
          final item = agendaItems[index];
          
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. FILA SUPERIOR: Perfil de la niñera (Foto, Nombre, Rating)
                  Row(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              item['foto'],
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
                                backgroundImage: NetworkImage(item['foto']),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
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
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '(${item['rating']})',
                                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 2. SECCIÓN DE HORARIOS
                  ...List.generate(item['horarios'].length, (indexHorario) {
                    final horario = item['horarios'][indexHorario];
                    final partes = horario.split(':');
                    final dia = partes[0];
                    final horas = partes.length > 1 ? partes[1] : '';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black87, fontSize: 14),
                          children: [
                            TextSpan(
                              text: '$dia:', 
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: horas),
                          ],
                        ),
                      ),
                    );
                  }),
                  
                  // Línea divisoria entre horarios y niños
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(color: Colors.black12, height: 1),
                  ),

                  // 3. SECCIÓN REDISEÑADA: Al cuidado de (Horizontal)
                  const Text(
                    'Al cuidado de:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Contenedor con scroll horizontal para los niños
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: List.generate(item['ninos'].length, (indexNino) {
                        final nino = item['ninos'][indexNino];
                        return Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: NetworkImage(nino['foto']!),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nino['nombre']!.split(' ')[0], 
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    nino['nombre']!.contains('(') 
                                        ? nino['nombre']!.substring(nino['nombre']!.indexOf('('))
                                        : '', 
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ), // Fin de Column
            ), // Fin de Padding del Container
          ); // Fin de Container
        }, // Fin de itemBuilder
      ), // Fin de ListView.builder
    ); // Fin de Scaffold
  }
}