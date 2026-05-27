import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final Color color;
  final VoidCallback onTap; // ← parámetro que faltaba

  const SearchButton({
    super.key,
    required this.onTap, // ← requerido
    this.color = Colors.pink,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap, // ← ahora sí usa el parámetro
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.search, color: color),
        ),
      ),
    );
  }
}
