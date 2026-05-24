import 'package:flutter/material.dart';



// la ventana de califcar:
import '../../widgets/calificator_dialog.dart';

class CitasPasadasScreen extends StatelessWidget {
  const CitasPasadasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Color para el botón "Calificar" (Rojo/Rosa fuerte según la imagen)
    const rateButtonColor = Color(0xFFC93B3B);

    // Datos simulados para las citas pasadas
    final List<Map<String, dynamic>> citasPasadas = [
      {
        'nombre': 'Sarah B.',
        'rating': '4.5',
        'fecha': 'Finalizo: 12 Mayo 2024',
        'foto': 'https://i.pravatar.cc/150?img=47'
      },
      {
        'nombre': 'Michael K.',
        'rating': '4.3',
        'fecha': 'Finalizo: 10 Mayo 2024',
        'foto': 'https://i.pravatar.cc/150?img=33'
      },
      {
        'nombre': 'Olivia P.',
        'rating': '4.5',
        'fecha': 'Finalizo: 08 Mayo 2024',
        'foto': 'https://i.pravatar.cc/150?img=49'
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: citasPasadas.length,
      itemBuilder: (context, index) {
        final item = citasPasadas[index];
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
              children: [
                // Imagen con el mini avatar superpuesto
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        item['foto'],
                        width: 80,
                        height: 80,
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
                          radius: 11,
                          backgroundImage: NetworkImage(item['foto']),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                
                // Información Central
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
                          Text(
                            " (${item['rating']})",
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Fecha de finalización
                      Text(
                        item['fecha'],
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Botón Calificado / Calificar
                      // En la imagen se ve que al presionar se vuelve "Calificado"
                      GestureDetector(
                        onTap: () {
                          CalificarDialog.mostrar(context, item['nombre']);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                          decoration: BoxDecoration(
                            color: rateButtonColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Calificar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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