import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../widgets/calificator_dialog.dart';

class CitasPasadasScreen extends StatelessWidget {
  final UserModel user;
  const CitasPasadasScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    const rateButtonColor = Color(0xFFC93B3B);

    final List<Map<String, dynamic>> citasPasadas = [
      {
        'nombre': 'Sarah B.',
        'rating': 4.5,
        'fecha': 'Finalizó: 12 Mayo 2024',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: citasPasadas.length,
      itemBuilder: (context, index) {
        final item = citasPasadas[index];
        final double rating = item['rating'];

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
                // Avatar genérico
                CircleAvatar(
                  radius: 37,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.person, size: 38, color: Colors.grey),
                ),
                const SizedBox(width: 16),

                // Información central
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
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['fecha'],
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
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