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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: headerColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Agenda',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
      body: FutureBuilder<List>(
        future: _bookings,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.data!.isEmpty) {
            return const Center(child: Text('No tienes citas agendadas'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: snap.data!.length,
            itemBuilder: (context, index) {
              return _BookingCard(
                booking: snap.data![index],
                isCaregiver: widget.user.role == 'caregiver',
              );
            },
          );
        },
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final bool isCaregiver;

  const _BookingCard({required this.booking, required this.isCaregiver});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header — foto y nombre
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: booking.caregiverPhoto.isNotEmpty
                      ? NetworkImage(booking.caregiverPhoto)
                      : null,
                  child: booking.caregiverPhoto.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCaregiver ? booking.tutorName : booking.caregiverName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _StatusChip(status: booking.status),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // Fecha y horario
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  DateFormat('EEEE d MMMM, yyyy', 'es_ES').format(booking.date),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(booking.timeBlock, style: const TextStyle(fontSize: 14)),
              ],
            ),
            if (booking.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.note, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.notes,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'confirmada' => Colors.green,
      'cancelada' => Colors.red,
      _ => Colors.orange, // pendiente
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
