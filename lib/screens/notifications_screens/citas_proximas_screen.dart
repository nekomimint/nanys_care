import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
 
class CitasProximasScreen extends StatelessWidget {
  final UserModel user;
  const CitasProximasScreen({super.key, required this.user});
 
  @override
  Widget build(BuildContext context) {
    const detailLinkColor = Color(0xFF2E7D73);
 
    final List<Map<String, dynamic>> citasProximas = [
      {
        'nombre': 'Sarah B.',
        'rating': 4.5,
        'exp': 'Exp: 4 años con bebés',
        'tarifa': 'Tarifa: \$135 MXN/h',
      },
    ];
 
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: citasProximas.length,
      itemBuilder: (context, index) {
        final item = citasProximas[index];
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar genérico
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
 
                // Información central
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre y estrellas
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
                            children: List.generate(5, (i) => Icon(
                              Icons.star,
                              size: 16,
                              color: i < rating.floor()
                                  ? Colors.amber
                                  : Colors.grey.shade300,
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
 
                      Text(
                        item['exp'],
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                      ),
                      Text(
                        item['tarifa'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
 
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {},
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