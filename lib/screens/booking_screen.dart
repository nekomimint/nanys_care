import 'package:flutter/material.dart';
import '../models/caregiver_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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

      body: Padding(

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

            SizedBox(

              width: double.infinity,

              child: ElevatedButton.icon(

                style: ElevatedButton.styleFrom(

                  backgroundColor: Colors.white,

                  foregroundColor: Colors.black,

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 18,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),

                onPressed: () async {

                  final pickedDate =
                      await showDatePicker(

                    context: context,

                    initialDate: DateTime.now(),

                    firstDate: DateTime.now(),

                    lastDate:
                        DateTime.now().add(
                      const Duration(days: 365),
                    ),
                  );

                  if (pickedDate != null) {

                    setState(() {

                      selectedDate = pickedDate;

                      selectedSlot = null;
                    });
                  }
                },

                icon: const Icon(
                  Icons.calendar_month,
                ),

                label: Text(

                  selectedDate == null

                      ? "Elegir fecha"

                      : DateFormat(
                          'dd/MM/yyyy',
                        ).format(selectedDate!),
                ),
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

            const Spacer(),

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
    );
  }
}