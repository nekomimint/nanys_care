import 'package:flutter/material.dart';
import '../models/caregiver_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingScreen extends StatefulWidget {

  final CaregiverModel caregiver;

  const BookingScreen({
    super.key,
    required this.caregiver,
  });

  @override
  State<BookingScreen> createState() =>
      _BookingScreenState();
}

class _BookingScreenState
    extends State<BookingScreen> {
  
  @override
void initState() {

  super.initState();

  initializeDateFormatting('es_ES');
}

  DateTime? selectedDate;
  DateTime focusedDay = DateTime.now();

  String? selectedSlot;

  final notesController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF4F9F8),

      appBar: AppBar(

        title:
            const Text("Agendar cita"),

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

              widget.caregiver.name,

              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              '\$${widget.caregiver.price} por cita',
            ),

            const SizedBox(height: 30),

            const Text(
              "Selecciona una fecha",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

           TableCalendar(
            
            availableCalendarFormats: const {
              CalendarFormat.month: 'Mes',
            },

            firstDay: DateTime.now(),

            lastDay:
                DateTime.now().add(
              const Duration(days: 365),
            ),

            focusedDay: focusedDay,

            selectedDayPredicate: (day) {

              return isSameDay(
                selectedDate,
                day,
              );
            },

            onDaySelected:
                (selectedDayValue, focusedDayValue) {

              final dayName =

                  DateFormat(
                    'EEEE',
                    'es_ES',
                  )

                  .format(selectedDayValue)
                  .toLowerCase();

              final hasAvailability =

                  widget.caregiver.availability
                      .any((availability) {

                return availability
                    .toLowerCase()
                    .startsWith(dayName);
              });

              if (!hasAvailability) {

                ScaffoldMessenger.of(context)
                    .showSnackBar(

                  const SnackBar(

                    content: Text(
                      "No hay horarios disponibles este día",
                    ),
                  ),
                );

                return;
              }

              setState(() {

                selectedDate =
                    selectedDayValue;

                focusedDay =
                    focusedDayValue;

                selectedSlot = null;
              });
            },

            calendarStyle: CalendarStyle(

              selectedDecoration:
                  const BoxDecoration(

                color: Color(0xFFAC7099),

                shape: BoxShape.circle,
              ),

              todayDecoration:
                  BoxDecoration(

                color: Colors.pink.shade200,

                shape: BoxShape.circle,
              ),
            ),

            calendarBuilders:
                CalendarBuilders(

              defaultBuilder:
                  (context, day, focusedDay) {

                final dayName =

                    DateFormat(
                      'EEEE',
                      'es_ES',
                    )

                    .format(day)
                    .toLowerCase();

                final hasAvailability =

                    widget.caregiver.availability
                        .any((availability) {

                  return availability
                      .toLowerCase()
                      .startsWith(dayName);
                });

                if (!hasAvailability) {

                  return MouseRegion(

                    cursor:
                        SystemMouseCursors.forbidden,

                    child: Center(

                      child: Text(

                        '${day.day}',

                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }

                return MouseRegion(

                  cursor: SystemMouseCursors.click,

                  child: Container(

                    margin: const EdgeInsets.all(6),

                    decoration: BoxDecoration(

                      color:
                          Colors.green.shade100,

                      shape: BoxShape.circle,
                    ),

                    child: Center(

                      child: Text(
                        '${day.day}',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

            const SizedBox(height: 25),

            const Text(
              "Selecciona horario",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            if (selectedDate != null)

              Wrap(

                spacing: 10,

                runSpacing: 10,

                children:
                    widget.caregiver.availability

                        .where((availability) {

                          final selectedDayName =

                            DateFormat(
                              'EEEE',
                              'es_ES',
                            ).format(selectedDate!);

                        return availability
                            .toLowerCase()
                            .startsWith(
                              selectedDayName.toLowerCase(),
                            );
                        })

                        .map((availability) {

                          final slot =
                              availability.split('-')[1];

                  final isSelected =
                      selectedSlot == slot;

                  return ChoiceChip(

                    label: Text(slot),

                    selected: isSelected,

                    selectedColor:
                        const Color(0xFFAC7099),

                    onSelected: (_) {

                      setState(() {

                        selectedSlot = slot;
                      });
                    },
                  );
                }).toList(),
              ),

            const SizedBox(height: 30),

            TextField(

              controller: notesController,

              maxLines: 4,

              decoration: InputDecoration(

                labelText:
                    "Notas adicionales",

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(

                  backgroundColor:
                      const Color(0xFFAC7099),

                  foregroundColor: Colors.white,

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                ),

                onPressed: () {

                  if (selectedDate == null ||
                      selectedSlot == null) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      const SnackBar(
                        content: Text(
                          "Selecciona día y horario",
                        ),
                      ),
                    );

                    return;
                  }

                  final booking = BookingModel(

                    caregiverName: widget.caregiver.name,

                    tutorName: "Krystina",

                    date: selectedDate!,

                    timeSlot: selectedSlot!,

                    notes: notesController.text,

                    status: "Pendiente",
                  );

                  BookingService.addBooking(
                    booking,
                  );

                  ScaffoldMessenger.of(context)
                      .showSnackBar(

                    const SnackBar(
                      content: Text(
                        "Solicitud enviada correctamente",
                      ),
                    ),
                  );

                  Navigator.pop(context);
                },

                child: const Text(
                  "Confirmar cita",
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}