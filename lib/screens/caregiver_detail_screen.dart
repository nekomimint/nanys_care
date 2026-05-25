import 'package:flutter/material.dart';
import '../models/caregiver_model.dart';
import 'booking_screen.dart';

class CaregiverDetailScreen extends StatelessWidget {

  final CaregiverModel caregiver;

  const CaregiverDetailScreen({
    super.key,
    required this.caregiver,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF4F9F8),

      appBar: AppBar(

        title: Text(caregiver.name),

        backgroundColor:
            const Color(0xFFAC7099),

        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Center(
              child: CircleAvatar(

                radius: 60,

                backgroundImage:
                    NetworkImage(
                  caregiver.imageUrl,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(

              caregiver.name,

              style: const TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              caregiver.experience,
              style:
                  const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              '\$${caregiver.price} por cita',
              style:
                  const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [

                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),

                const SizedBox(width: 5),

                Text(
                  caregiver.rating
                      .toString(),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Disponibilidad",

              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Wrap(

              spacing: 10,
              runSpacing: 10,

              children:
                  caregiver.availability
                      .map((slot) {

                return Chip(
                  label: Text(slot),

                  backgroundColor:
                      const Color(
                    0xFFAC7099,
                  ),
                  labelStyle:
                      const TextStyle(
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            const Text(
              "Reseñas",

              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ...caregiver.reviews.map((review) {

              return Container(

                width: double.infinity,

                margin: const EdgeInsets.only(
                  bottom: 10,
                ),

                padding: const EdgeInsets.all(15),

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(15),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Row(
                      children: [

                        ...List.generate(

                          review.rating.floor(),

                          (index) {

                            return const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            );
                          },
                        ),

                        const SizedBox(width: 5),

                        Text(
                          review.rating.toString(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(review.comment),
                  ],
                ),
              );
            }),

            const SizedBox(height: 40),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      const Color(
                    0xFFAC7099,
                  ),

                  padding:
                      const EdgeInsets.all(
                    18,
                  ),
                ),

                onPressed: () {Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        BookingScreen(
                      caregiver: caregiver,
                    ),
                  ),
                );
                },
                

                child: const Text(

                  "Agendar cita",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}