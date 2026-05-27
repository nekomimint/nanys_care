import 'package:flutter/material.dart';

class GreetingHeader extends StatelessWidget {
  final String name;
  final String subtitle;
  final String photoUrl;
  final VoidCallback? onPhotoTap;

  const GreetingHeader({
    super.key,
    required this.name,
    required this.photoUrl,
    this.subtitle = 'Encuentra a tu cuidador ideal',
    this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200), // ← ancho máximo
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Hola, $name', // ← usar name directamente, no widget.user.name
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                subtitle, // ← usar subtitle directamente
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onPhotoTap,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.pink.withOpacity(0.2),
            backgroundImage: photoUrl.isNotEmpty
                ? NetworkImage(photoUrl)
                : null,
            child: photoUrl.isEmpty
                ? const Icon(Icons.person, color: Colors.pink)
                : null,
          ),
        ),
      ],
    );
  }
}
