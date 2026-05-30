import 'package:flutter/material.dart';
import '../models/caregiver_model.dart';

class CaregiverCard extends StatelessWidget {
  final CaregiverModel caregiver;
  final VoidCallback? onTap;

  const CaregiverCard({super.key, required this.caregiver, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Foto
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: caregiver.imageUrl.isNotEmpty
                  ? Image.network(
                      caregiver.imageUrl,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        // ← agrega esto
                        width: 110,
                        height: 110,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(
                      width: 110,
                      height: 110,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      caregiver.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Rating con estrellas
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          caregiver.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          ' (${caregiver.reviews.length})',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Precio
                    Row(
                      children: [
                        const Icon(
                          Icons.payments_outlined,
                          size: 16,
                          color: Colors.black45,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '\$${caregiver.price} / bloque',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
