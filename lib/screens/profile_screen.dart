import 'package:flutter/material.dart';

//import '../OtherScreens/addChild_screen.dart';

import '../widgets/addChild_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // colores
    const customGreen = Color(0xFFAC7099); // Color(0xFF2E7D73) anteriro
    const backgroundLight = Color(0xFFF4F9F8);

    return Scaffold(
      backgroundColor: backgroundLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. CABECERA VERDE CON PERFIL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 40,
                left: 20,
                right: 20,
                bottom: 30,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFAC7099), // customGreen (anterior)
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    // Aquí puedes usar NetworkImage o AssetImage más adelante
                    child: Icon(Icons.person, size: 40, color: customGreen),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tutor: [Tutor\'s Name]',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '[Tutor\'s Email]',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. OPCIONES DEL PERFIL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Botón Dirección
                  _buildProfileButton(
                    icon: Icons.location_on_outlined,
                    title: 'Dirección',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),

                  // Botón Tarifa por hora
                  _buildProfileButton(
                    icon: Icons.payments_outlined,
                    title: 'Tarifa por hora',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),

                  // Tarjeta Agregar Niño + Lista Horizontal
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.add, color: Colors.black54),
                          title: const Text(
                            'Agregar niño',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.black54,
                          ),
                          onTap: () {
                            // Aqui se abre el formulario para agregar a los mocosos
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled:
                                  true, // Esto permite que el modal tome la altura personalizada
                              backgroundColor: Colors
                                  .transparent, // Deja que el Container controle los bordes redondeados
                              builder: (BuildContext context) {
                                return const AddChildBottomSheet();
                              },
                            );
                          },
                        ),
                        // Carrusel de niños en la parte inferior de la tarjeta
                        SizedBox(
                          height: 130,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 16,
                            ),
                            children: [
                              _buildChildCard('Leo M.'),
                              _buildChildCard('Mia G.'),
                              _buildChildCard('Santiago P.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para crear los botones simples de opciones
  Widget _buildProfileButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.black54,
        ),
        onTap: onTap,
      ),
    );
  }

  // Widget auxiliar para las tarjetas del carrusel de niños
  Widget _buildChildCard(String name) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.child_care, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
