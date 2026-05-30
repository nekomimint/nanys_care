import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../models/caregiver_model.dart';
import '../../../models/user_model.dart';
import '../../../services/caregiver_service.dart';
import '../../../services/booking_service.dart';
import '../../../widgets/caregiver_card.dart';
import '../../../widgets/caregiver_profile_screen.dart';

class SearchCaregiverScreen extends StatefulWidget {
  final UserModel user;
  const SearchCaregiverScreen({super.key, required this.user});

  @override
  State<SearchCaregiverScreen> createState() => _SearchCaregiverScreenState();
}

class _SearchCaregiverScreenState extends State<SearchCaregiverScreen> {
  static const _purple = Color(0xFFAC7099);

  // Calendario
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Bloque
  String? _selectedBlock;
  final List<String> _blocks = ['manana', 'mediodia', 'tarde', 'noche'];
  final Map<String, String> _blockLabels = {
    'manana': 'Mañana',
    'mediodia': 'Mediodía',
    'tarde': 'Tarde',
    'noche': 'Noche',
  };

  // Precio
  RangeValues _priceRange = const RangeValues(100, 500);

  // Resultados
  List<CaregiverModel> _results = [];
  bool _loading = false;
  bool _searched = false;

  Future<void> _search() async {
    if (_selectedDay == null || _selectedBlock == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una fecha y un bloque')),
      );
      return;
    }

    setState(() {
      _loading = true;
      _searched = true;
    });

    try {
      // 1. Trae todos los caregivers dentro del rango de precio
      final all = await CaregiverService.getCaregiversByPrice(
        minPrice: _priceRange.start.toInt(),
        maxPrice: _priceRange.end.toInt(),
      );

      // 2. Filtra los que tienen el bloque disponible en esa fecha
      final available = <CaregiverModel>[];
      await Future.wait(
        all.map((c) async {
          final isAvailable = await BookingService.isBlockAvailable(
            caregiverUid: c.uid,
            date: _selectedDay!,
            timeBlock: _selectedBlock!,
          );
          if (isAvailable) available.add(c);
        }),
      );

      // 3. Ordena por rating
      available.sort((a, b) => b.rating.compareTo(a.rating));

      setState(() => _results = available);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F8),
      appBar: AppBar(
        title: const Text('Buscar cuidadores'),
        backgroundColor: _purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Calendario ──────────────────────────────
            const Text(
              'Selecciona una fecha',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 60)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selected, focused) {
                  setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                  });
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(
                    color: _purple,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: _purple.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  outsideDaysVisible: false,
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Bloques ──────────────────────────────────
            const Text(
              'Bloque de horario',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              children: _blocks.map((block) {
                final selected = _selectedBlock == block;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedBlock = block),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selected ? _purple : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        _blockLabels[block]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : Colors.black54,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // ── Precio ───────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rango de precio',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '\$${_priceRange.start.round()} — \$${_priceRange.end.round()}',
                  style: const TextStyle(color: Colors.black45, fontSize: 14),
                ),
              ],
            ),
            RangeSlider(
              values: _priceRange,
              min: 50,
              max: 1000,
              divisions: 19,
              activeColor: _purple,
              labels: RangeLabels(
                '\$${_priceRange.start.round()}',
                '\$${_priceRange.end.round()}',
              ),
              onChanged: (values) => setState(() => _priceRange = values),
            ),
            const SizedBox(height: 24),

            // ── Botón buscar ─────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: _loading ? null : _search,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Buscar cuidadores',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Resultados ───────────────────────────────
            if (_searched) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cuidadores disponibles',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    '${_results.length} resultados',
                    style: const TextStyle(color: Colors.black45, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_results.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'No hay cuidadores disponibles',
                      style: TextStyle(color: Colors.black45),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    return CaregiverCard(
                      caregiver: _results[index],
                      onTap: () => Navigator.push(
                        // ← reemplaza el onTap vacío
                        context,
                        MaterialPageRoute(
                          builder: (_) => CaregiverProfileScreen(
                            caregiver: _results[index],
                            tutor: widget.user,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }
}
