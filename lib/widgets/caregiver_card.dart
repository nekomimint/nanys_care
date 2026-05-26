import 'package:flutter/material.dart';
import '../models/caregiver_model.dart';
import '../screens/home/caregiver/caregiver_detail_screen.dart';
import 'package:flutter/gestures.dart';

class CaregiverCard extends StatelessWidget {
  final CaregiverModel caregiver;

  const CaregiverCard({super.key, required this.caregiver});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,

      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) => CaregiverDetailScreen(caregiver: caregiver),
            ),
          );
        },

        child: Container(
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,

                backgroundImage: NetworkImage(caregiver.imageUrl),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      caregiver.name,

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(caregiver.experience),

                    const SizedBox(height: 5),

                    Text('\$${caregiver.price} por cita'),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),

                        const SizedBox(width: 5),

                        Text(caregiver.rating.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
