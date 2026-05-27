import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/booking_model.dart';
import '../../models/user_model.dart';
import '../../services/booking_service.dart';

class AgendaScreen extends StatefulWidget {
  final UserModel user;
  const AgendaScreen({super.key, required this.user});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  late Future<List<BookingModel>> _bookings;

  @override
  Widget build(BuildContext context) {
    const headerColor = Color(0xFFAC7099);
    const backgroundColor = Color(0xFFF3F8F7);

    return Scaffold();
  }
}
