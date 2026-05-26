import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/caregiver_model.dart';
import 'booking_screen.dart';

class CaregiverListScreen extends StatelessWidget {
  const CaregiverListScreen({super.key});

  Future<List<CaregiverModel>> getCaregivers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'caregiver')
        .get();

    return snapshot.docs.map((doc) {
      return CaregiverModel.fromFirestore(doc.data());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cuidadores disponibles')),

      body: FutureBuilder<List<CaregiverModel>>(
        future: getCaregivers(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final caregivers = snapshot.data ?? [];

          if (caregivers.isEmpty) {
            return const Center(child: Text('No hay cuidadores disponibles'));
          }

          return ListView.builder(
            itemCount: caregivers.length,

            itemBuilder: (context, index) {
              final caregiver = caregivers[index];

              return Card(
                margin: const EdgeInsets.all(10),

                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(caregiver.imageUrl),
                  ),

                  title: Text(caregiver.name),

                  subtitle: Text('\$${caregiver.price}'),

                  trailing: const Icon(Icons.arrow_forward_ios),

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => BookingScreen(caregiver: caregiver),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
