import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingRequestScreen extends StatefulWidget {

  final BookingModel booking;

  const BookingRequestScreen({
    super.key,
    required this.booking,
  });

  @override
  State<BookingRequestScreen> createState() =>
      _BookingRequestScreenState();
}

class _BookingRequestScreenState
    extends State<BookingRequestScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF4F9F8),

      appBar: AppBar(

        title:
            const Text("Solicitud de cita"),

        backgroundColor:
            const Color(0xFFAC7099),

        foregroundColor: Colors.white,
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(

                widget.booking.tutorName,

                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Horario: ${widget.booking.timeSlot}',
              ),

              Text(
                'Estado: ${widget.booking.status}',
              ),

              const SizedBox(height: 25),

              const Text(
                "Fecha seleccionada",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              IgnorePointer(

                child: TableCalendar(

                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Mes',
                  },

                  firstDay:
                      DateTime.now().subtract(
                    const Duration(days: 365),
                  ),

                  lastDay:
                      DateTime.now().add(
                    const Duration(days: 365),
                  ),

                  focusedDay:
                      widget.booking.date,

                  selectedDayPredicate: (day) {

                    return isSameDay(
                      day,
                      widget.booking.date,
                    );
                  },

                  calendarStyle: CalendarStyle(

                    selectedDecoration:
                        const BoxDecoration(

                      color:
                          Color(0xFFAC7099),

                      shape: BoxShape.circle,
                    ),

                    todayDecoration:
                        BoxDecoration(

                      color:
                          Colors.pink.shade200,

                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Notas",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              Container(

                width: double.infinity,

                padding: const EdgeInsets.all(15),

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(15),
                ),

                child: Text(

                  widget.booking.notes.isEmpty

                      ? "Sin notas"

                      : widget.booking.notes,
                ),
              ),

              const SizedBox(height: 40),

              if (widget.booking.status == "Pendiente")

                Row(

                  children: [

                    Expanded(

                      child: ElevatedButton(

                        style:
                            ElevatedButton.styleFrom(

                          backgroundColor:
                              Colors.green,

                          foregroundColor:
                              Colors.white,

                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 18,
                          ),
                        ),

                        onPressed: () {

                          BookingService
                              .updateBookingStatus(

                            widget.booking,
                            "Aceptada",
                          );

                          setState(() {});
                        },

                        child: const Text(
                          "Aceptar",
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(

                      child: ElevatedButton(

                        style:
                            ElevatedButton.styleFrom(

                          backgroundColor:
                              Colors.red,

                          foregroundColor:
                              Colors.white,

                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 18,
                          ),
                        ),

                        onPressed: () {

                          BookingService
                              .updateBookingStatus(

                            widget.booking,
                            "Rechazada",
                          );

                          setState(() {});
                        },

                        child: const Text(
                          "Rechazar",
                        ),
                      ),
                    ),
                  ],
                ),

              if (widget.booking.status != "Pendiente")

                Column(

                  children: [

                    Center(

                      child: Text(

                        widget.booking.status,

                        style: TextStyle(

                          fontSize: 22,

                          fontWeight: FontWeight.bold,

                          color:
                              widget.booking.status ==
                                      "Aceptada"

                                  ? Colors.green

                                  : Colors.red,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    if (widget.booking.status ==
                        "Aceptada")

                      SizedBox(

                        width: double.infinity,

                        child: ElevatedButton(

                          style:
                              ElevatedButton.styleFrom(

                            backgroundColor:
                                Colors.red,

                            foregroundColor:
                                Colors.white,

                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 18,
                            ),
                          ),

                          onPressed: () {

                            BookingService
                                .updateBookingStatus(

                              widget.booking,
                              "Cancelada",
                            );

                            setState(() {});
                          },

                          child: const Text(
                            "Cancelar cita",
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}