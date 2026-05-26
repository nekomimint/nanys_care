import 'package:flutter/material.dart';
import '../models/user_model.dart';

import '../widgets/search_button.dart';
import '../widgets/greetin_header.dart';

class AgendaPendentCard extends StatefulWidget {
  final UserModel user;
  const AgendaPendentCard({super.key, required this.user});

  @override
  State<AgendaPendentCard> createState() => _AgendaPendedCard();
}

class _AgendaPendedCard extends State<AgendaPendentCard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: Column(
        children: [
          //* Header de perfil y busqueda
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // ← separa los hijos
              children: [
                // ← sin Spacer
              ],
            ),
          ),
          //* Aqui termina el header
        ],
      ),
    ));
  }
}
