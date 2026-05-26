import 'package:flutter/material.dart';

import '../models/caregiver_model.dart';

class BookingScreen extends StatefulWidget {
  final CaregiverModel caregiver;

  const BookingScreen({super.key, required this.caregiver});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agendar cita')),

      body: Center(child: Text(widget.caregiver.name)),
    );
  }
}
