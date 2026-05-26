import 'package:flutter/material.dart';
import '../services/booking_service.dart';
import '../models/booking_model.dart';
import 'package:intl/intl.dart';
import 'booking_request_screen.dart';

class AgendaScreen extends StatefulWidget {

  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() =>
      _AgendaScreenState();
}

class _AgendaScreenState
    extends State<AgendaScreen> {

  @override
  Widget build(BuildContext context) {

    final acceptedBookings =
        BookingService.bookings
            .where((booking) =>
                booking.status == 'Aceptada')
            .toList();

    return Scaffold(

      backgroundColor:
          const Color(0xFFF4F9F8),

      body: acceptedBookings.isEmpty

          ? const Center(
              child: Text(
                'No hay citas agendadas',
                style: TextStyle(fontSize: 18),
              ),
            )

          : ListView.builder(

              padding: const EdgeInsets.all(20),

              itemCount:
                  acceptedBookings.length,

              itemBuilder: (context, index) {

                final booking =
                    acceptedBookings[index];

                MouseRegion(

                  cursor: SystemMouseCursors.click,

                  child: GestureDetector(

                    onTap: () async {

                      await Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) => BookingRequestScreen(
                            booking: booking,
                          ),
                        ),
                      );

                      setState(() {});
                    },

                    child: Container(

                      margin: const EdgeInsets.only(
                        bottom: 20,
                      ),

                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(

                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(20),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Text(
                            booking.tutorName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Fecha: ${DateFormat('dd/MM/yyyy').format(booking.date)}',
                          ),

                          Text(
                            'Horario: ${booking.timeSlot}',
                          ),

                          Text(
                            'Estado: ${booking.status}',
                          ),

                          const SizedBox(height: 8),

                          const Text(

                            'Click para ver detalles',

                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}