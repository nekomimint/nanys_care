import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/caregiver_model.dart';
import '../../models/user_model.dart';
import '../../models/booking_model.dart';
import '../../models/children_model.dart';
import '../../services/booking_service.dart';
import '../../services/children_service.dart';

class CaregiverProfileScreen extends StatefulWidget {
  final CaregiverModel caregiver;
  final UserModel tutor;

  const CaregiverProfileScreen({
    super.key,
    required this.caregiver,
    required this.tutor,
  });

  @override
  State<CaregiverProfileScreen> createState() => _CaregiverProfileScreenState();
}

class _CaregiverProfileScreenState extends State<CaregiverProfileScreen> {
  static const _purple = Color(0xFFAC7099);

  @override
  Widget build(BuildContext context) {
    final c = widget.caregiver;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F8),
      body: CustomScrollView(
        slivers: [
          // ── Header con foto ──────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: _purple,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: c.imageUrl.isNotEmpty
                  ? Image.network(
                      c.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: _purple.withOpacity(0.3),
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container(
                      color: _purple.withOpacity(0.3),
                      child: const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Nombre y experiencia ─────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          c.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          c.experience,
                          style: const TextStyle(
                            color: _purple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Rating ───────────────────────────
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        c.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '  (${c.reviews.length} reseñas)',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Precio ───────────────────────────
                  Row(
                    children: [
                      const Icon(
                        Icons.payments_outlined,
                        color: Colors.black45,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '\$${c.price} por bloque',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Reviews ──────────────────────────
                  if (c.reviews.isNotEmpty) ...[
                    const Text(
                      'Reseñas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...c.reviews.map(
                      (r) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                (i) => Icon(
                                  Icons.star,
                                  size: 14,
                                  color: i < r.rating.round()
                                      ? Colors.amber
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              r.comment,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ── Botón agendar ────────────────────
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
                      onPressed: () => _openBookingSheet(),
                      child: const Text(
                        'Agendar cita',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openBookingSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: _BookingSheet(caregiver: widget.caregiver, tutor: widget.tutor),
      ),
    );
  }
}

// ── Booking Sheet ────────────────────────────────────────────

class _BookingSheet extends StatefulWidget {
  final CaregiverModel caregiver;
  final UserModel tutor;

  const _BookingSheet({required this.caregiver, required this.tutor});

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  static const _purple = Color(0xFFAC7099);

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedBlock;
  List<String> _occupiedBlocks = [];
  List<ChildrenModel> _children = [];
  List<String> _selectedChildrenUids = [];
  final _notesController = TextEditingController();
  bool _loading = false;
  bool _saving = false;

  final Map<String, String> _blockLabels = {
    'manana': 'Mañana',
    'mediodia': 'Mediodía',
    'tarde': 'Tarde',
    'noche': 'Noche',
  };

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadChildren() async {
    final children = await ChildrenService.getChildrenByTutor(widget.tutor.uid);
    setState(() => _children = children);
  }

  Future<void> _onDaySelected(DateTime selected, DateTime focused) async {
    setState(() {
      _selectedDay = selected;
      _focusedDay = focused;
      _selectedBlock = null;
      _occupiedBlocks = [];
      _loading = true;
    });

    final occupied = await BookingService.getOccupiedBlocks(
      caregiverUid: widget.caregiver.uid,
      date: selected,
    );

    setState(() {
      _occupiedBlocks = occupied;
      _loading = false;
    });
  }

  Future<void> _save() async {
    if (_selectedDay == null || _selectedBlock == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona fecha y bloque')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final booking = BookingModel(
        uid: '',
        caregiverUid: widget.caregiver.uid,
        caregiverName: widget.caregiver.name,
        caregiverPhoto: widget.caregiver.imageUrl,
        tutorUid: widget.tutor.uid,
        tutorName: widget.tutor.name,
        childrenUids: _selectedChildrenUids,
        date: _selectedDay!,
        timeBlock: _selectedBlock!,
        priceSnapshot: widget.caregiver.price,
        notes: _notesController.text.trim(),
        status: 'pendiente',
        createdAt: DateTime.now(),
      );

      await BookingService.createBooking(booking);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Cita solicitada exitosamente!')),
        );
      }
    } on Exception catch (e) {
      if (e.toString().contains('block_unavailable')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Este bloque ya no está disponible')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Agendar con ${widget.caregiver.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${widget.caregiver.price} por bloque',
              style: const TextStyle(color: Colors.black45, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // ── Calendario ──────────────────────────────
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 60)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
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
            const SizedBox(height: 16),

            // ── Bloques ──────────────────────────────────
            const Text(
              'Bloque de horario',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                children: _blockLabels.entries.map((entry) {
                  final isOccupied = _occupiedBlocks.contains(entry.key);
                  final isSelected = _selectedBlock == entry.key;
                  return Expanded(
                    child: GestureDetector(
                      onTap: isOccupied
                          ? null
                          : () => setState(() => _selectedBlock = entry.key),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isOccupied
                              ? Colors.grey.shade200
                              : isSelected
                              ? _purple
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isOccupied
                                ? Colors.grey.shade300
                                : isSelected
                                ? _purple
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Text(
                          entry.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isOccupied
                                ? Colors.grey
                                : isSelected
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),

            // ── Niños ────────────────────────────────────
            if (_children.isNotEmpty) ...[
              const Text(
                '¿Qué niños irán?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: _children.map((child) {
                  final selected = _selectedChildrenUids.contains(child.uid);
                  return FilterChip(
                    label: Text(child.name),
                    selected: selected,
                    selectedColor: _purple.withOpacity(0.2),
                    checkmarkColor: _purple,
                    onSelected: (_) {
                      setState(() {
                        selected
                            ? _selectedChildrenUids.remove(child.uid)
                            : _selectedChildrenUids.add(child.uid);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],

            // ── Notas ────────────────────────────────────
            const Text(
              'Notas (opcional)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Alergias, indicaciones especiales, dirección...',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Botón confirmar ──────────────────────────
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
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Confirmar reservación',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
