import 'package:flutter/material.dart';

class AddChildBottomSheet extends StatefulWidget {
  const AddChildBottomSheet({super.key});

  @override
  State<AddChildBottomSheet> createState() => _AddChildBottomSheetState();
}

class _AddChildBottomSheetState extends State<AddChildBottomSheet> {
  // Controlador para capturar el nombre del niño
  final TextEditingController _nameController = TextEditingController();

  // Variables de control de estado con tipado explícito
  String _selectedAgeRange = 'Pekes (1-3a)';
  final List<String> _selectedNeeds = <String>['Mascotas'];
  String _selectedPlace = 'Casa Familia';

  // Matriz interactiva para la tabla de horarios (4 filas de turnos x 7 días de la semana)
  final List<List<bool>> _schedule = [
    [false, false, true, false, true, false, false], // Mañana
    [true, true, true, true, true, false, false], // Mediodía
    [false, true, false, true, false, true, false], // Tarde
    [false, false, false, false, false, false, false], // Noche
  ];

  // Listas de datos estáticos para renderizar las opciones
  final List<String> _ageRanges = [
    'Bebé (0-12m)',
    'Pekes (1-3a)',
    'Preesc. (3-5a)',
    'Primaria (6-12a)',
    'Adolesc. (12-17a)',
  ];

  final List<String> _needsOptions = [
    'Mascotas',
    'Cocinar',
    'Quehaceres',
    'Tareas',
  ];

  final List<String> _placesOptions = ['Casa Familia', 'Casa Niñera'];

  final List<String> _days = ['L', 'M', 'Mi', 'J', 'V', 'S', 'D'];

  // Nombres de turnos actualizados con prefijos AM y PM
  final List<String> _shifts = [
    'Mañana\n(8:00 AM - 12:00 PM)',
    'Mediodía\n(12:00 PM - 5:00 PM)',
    'Tarde\n(5:00 PM - 10:00 PM)',
    'Noche\n(10:00 PM - 3:00 AM)',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const customPurple = Color(0xFFAC7099);
    const softPurpleLight = Color(
      0xFFCBA1BD,
    ); // Tono suavizado/pastel para fondos

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // -----------------------------------------
          // CABECERA DEL BOTTOM SHEET
          // -----------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Agregar niño',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: customPurple,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),

          // -----------------------------------------
          // CUERPO CONFIGURABLE CON SCROLL
          // -----------------------------------------
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. SECCIÓN: NOMBRE DEL NIÑO
                  const SizedBox(height: 10),
                  const Text(
                    'Nombre del niño',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Ej. Liam Jesús',
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: customPurple,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: customPurple,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    ),
                  ),

                  // 2. SECCIÓN: EDAD
                  const SizedBox(height: 20),
                  const Text(
                    'Edad del niño',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _ageRanges.map((age) {
                      final isSelected = _selectedAgeRange == age;
                      return ChoiceChip(
                        label: Text(age),
                        selected: isSelected,
                        selectedColor: softPurpleLight,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black87 : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        onSelected: (selected) => setState(
                          () => _selectedAgeRange = selected ? age : '',
                        ),
                      );
                    }).toList(),
                  ),

                  // 3. SECCIÓN: NIÑERA CÓMODA CON
                  const SizedBox(height: 20),
                  const Text(
                    'Niñera cómoda con',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _needsOptions.map((need) {
                      final isSelected = _selectedNeeds.contains(need);
                      return FilterChip(
                        label: Text(need),
                        selected: isSelected,
                        selectedColor: softPurpleLight,
                        checkmarkColor: customPurple,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black87 : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedNeeds.add(need);
                            } else {
                              _selectedNeeds.remove(need);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  // 4. SECCIÓN: PREFERENCIA DEL LUGAR
                  const SizedBox(height: 20),
                  const Text(
                    'Preferencia del lugar',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _placesOptions.map((place) {
                      final isSelected = _selectedPlace == place;
                      return ChoiceChip(
                        label: Text(place),
                        selected: isSelected,
                        selectedColor: softPurpleLight,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black87 : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        onSelected: (selected) => setState(
                          () => _selectedPlace = selected ? place : '',
                        ),
                      );
                    }).toList(),
                  ),

                  // 5. SECCIÓN: TABLA DE HORARIOS INTERACTIVA
                  const SizedBox(height: 20),
                  const Text(
                    'Cuándo necesitamos a la niñera',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  Table(
                    border: TableBorder.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    columnWidths: const {0: FlexColumnWidth(2.2)},
                    children: [
                      // Fila superior: Encabezados de los Días
                      TableRow(
                        decoration: BoxDecoration(
                          color: softPurpleLight.withValues(
                            alpha: 0.15,
                          ), // Un sutil fondo pastel
                        ),
                        children: [
                          const Padding(padding: EdgeInsets.all(6)),
                          ..._days.map(
                            (d) => Center(
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  d,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Filas de Turnos con Checkboxes simétricos
                      ...List.generate(4, (rowIndex) {
                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                _shifts[rowIndex],
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                            ),

                            ...List.generate(7, (colIndex) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _schedule[rowIndex][colIndex] =
                                        !_schedule[rowIndex][colIndex];
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4.0),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    _schedule[rowIndex][colIndex]
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: _schedule[rowIndex][colIndex]
                                        ? customPurple
                                        : Colors.grey.shade400,
                                    size: 22,
                                  ),
                                ),
                              );
                            }),
                          ],
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // -----------------------------------------
          // ACCIÓN: BOTÓN CONTINUAR FIJO EN LA BASE
          // -----------------------------------------
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: customPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Continuar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
