import 'package:flutter/material.dart';

class CitasProximasScreen extends StatelessWidget {
  const CitasProximasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colores de la interfaz
    const detailLinkColor = Color(0xFF2E7D73); // Verde para "Ver detalles"

    // Datos simulados para las tarjetas de citas próximas
    final List<Map<String, dynamic>> citasProximas = [
      {
        'nombre': 'Sarah B.',
        'rating': '4.5',
        'exp': 'Exp: 4 años con bebés',
        'tarifa': 'Tarifa: \$135 MXN/h',
        'foto': 'https://i.pravatar.cc/150?img=47'
      },
      {
        'nombre': 'Michael K.',
        'rating': '4.3',
        'exp': 'Exp: 6 años, certificada',
        'tarifa': 'Tarifa: \$150 MXN/h',
        'foto': 'https://i.pravatar.cc/150?img=33'
      },
      {
        'nombre': 'Olivia P.',
        'rating': '4.5',
        'exp': 'Exp: 3 años, bilingüe',
        'tarifa': 'Tarifa: \$110 MXN/h',
        'foto': 'https://i.pravatar.cc/150?img=49'
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: citasProximas.length,
      itemBuilder: (context, index) {
        final item = citasProximas[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen con el mini avatar superpuesto
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        item['foto'],
                        width: 85,
                        height: 85,
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
                          radius: 12,
                          backgroundImage: NetworkImage(item['foto']),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                
                // Información Central de la tarjeta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre y Estrellas alineados arriba
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['nombre'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              Text(
                                " (${item['rating']})",
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      
                      // Texto de Experiencia
                      Text(
                        item['exp'],
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                      ),
                      
                      // Texto de Tarifa
                      Text(
                        item['tarifa'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Enlace centrado para "Ver detalles"
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            // Aquí manejarás la navegación o acción al presionar
                          },
                          child: const Text(
                            'Ver detalles',
                            style: TextStyle(
                              color: detailLinkColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
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