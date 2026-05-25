import 'package:flutter/material.dart';

import '../models/caregiver_model.dart';

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

  String? selectedDay;

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
              "Selecciona un día",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(

              value: selectedDay,

              decoration: InputDecoration(

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),

              items:

                widget.caregiver.availability

                    .map((availability) {

                      final day =
                          availability.split('-')[0];

                      return DropdownMenuItem(

                        value: day,

                        child: Text(day),
                      );

                    }).toSet().toList(),

              onChanged: (value) {

                setState(() {

                  selectedDay = value;

                  selectedSlot = null;
                });
              },
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

            if (selectedDay != null)

              Wrap(

                spacing: 10,

                runSpacing: 10,

                children:
                    widget.caregiver.availability

                        .where((availability) {

                          return availability
                              .startsWith(selectedDay!);
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

                  if (selectedDay == null ||
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