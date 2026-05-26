import 'package:flutter/material.dart';
import '../../../services/caregiver_service.dart';
import '../../../widgets/caregiver_card.dart';

class SearchCaregiverScreen extends StatefulWidget {
  const SearchCaregiverScreen({super.key});

  @override
  State<SearchCaregiverScreen> createState() => _SearchCaregiverScreenState();
}

class _SearchCaregiverScreenState extends State<SearchCaregiverScreen> {
  RangeValues priceRange = const RangeValues(100, 500);

  final List<String> selectedAvailability = [];

  final List<String> timeSlots = ['Mañana', 'Mediodía', 'Tarde', 'Noche'];

  final List<String> days = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  void toggleAvailability(String slot) {
    setState(() {
      if (selectedAvailability.contains(slot)) {
        selectedAvailability.remove(slot);
      } else {
        selectedAvailability.add(slot);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F8),

      appBar: AppBar(
        title: const Text("Buscar cuidadores"),
        backgroundColor: const Color(0xFFAC7099),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // EXPERIENCIA
            const Text(
              "Experiencia mínima",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              items: const [
                DropdownMenuItem(value: "1", child: Text("1+ años")),

                DropdownMenuItem(value: "3", child: Text("3+ años")),

                DropdownMenuItem(value: "5", child: Text("5+ años")),
              ],

              onChanged: (value) {},
            ),

            const SizedBox(height: 25),

            // PRECIO
            const Text(
              "Rango de precio",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  '\$${priceRange.start.round()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                Text(
                  '\$${priceRange.end.round()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            RangeSlider(
              values: priceRange,
              min: 50,
              max: 1000,

              divisions: 19,

              labels: RangeLabels(
                '\$${priceRange.start.round()}',
                '\$${priceRange.end.round()}',
              ),

              onChanged: (values) {
                setState(() {
                  priceRange = values;
                });
              },
            ),

            const SizedBox(height: 25),

            const Text(
              "Disponibilidad",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 10),

            Column(
              children: days.map((day) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),

                  padding: const EdgeInsets.all(15),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(15),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),

                        blurRadius: 8,

                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        day,

                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,

                        children: timeSlots.map((slot) {
                          final key = '$day-$slot';

                          final isSelected = selectedAvailability.contains(key);

                          return FilterChip(
                            label: Text(slot),

                            selected: isSelected,

                            selectedColor: const Color(0xFFAC7099),

                            onSelected: (_) {
                              setState(() {
                                if (isSelected) {
                                  selectedAvailability.remove(key);
                                } else {
                                  selectedAvailability.add(key);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            const Text(
              "Cuidadores disponibles",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            const SizedBox(height: 15),

            ListView.builder(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              itemCount: CaregiverService.caregivers.length,

              itemBuilder: (context, index) {
                final caregiver = CaregiverService.caregivers[index];

                return CaregiverCard(caregiver: caregiver);
              },
            ),
          ],
        ),
      ),
    );
  }
}
