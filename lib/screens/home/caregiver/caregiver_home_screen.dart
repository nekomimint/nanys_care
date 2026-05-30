import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/user_model.dart';
import '../../../models/booking_model.dart';
import '../../../services/booking_service.dart';

class CaregiverHomeScreen extends StatefulWidget {
  final UserModel user;
  final VoidCallback onProfileTap;

  const CaregiverHomeScreen({
    super.key,
    required this.user,
    required this.onProfileTap,
  });

  @override
  State<CaregiverHomeScreen> createState() => _CaregiverHomeScreenState();
}

class _CaregiverHomeScreenState extends State<CaregiverHomeScreen> {
  static const _purple = Color(0xFFAC7099);

  late Future<List<BookingModel>> _pendingFuture;
  late Future<BookingModel?> _nextBookingFuture;

  final Map<String, String> _blockLabels = {
    'manana': 'Mañana',
    'mediodia': 'Mediodía',
    'tarde': 'Tarde',
    'noche': 'Noche',
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _pendingFuture = BookingService.getPendingByCaregiver(widget.user.uid);
    _nextBookingFuture = BookingService.getNextBooking(widget.user.uid);
    print('Cargando datos para: ${widget.user.uid}');
    _pendingFuture = BookingService.getPendingByCaregiver(widget.user.uid);
    _nextBookingFuture = BookingService.getNextBooking(widget.user.uid);
  }

  Future<void> _confirm(String bookingUid) async {
    await BookingService.confirmBooking(bookingUid);
    setState(() => _loadData());
  }

  Future<void> _reject(String bookingUid) async {
    final reasonController = TextEditingController();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rechazar solicitud'),
        content: TextField(
          controller: reasonController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Motivo (opcional)...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Rechazar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final reason = reasonController.text.trim().isEmpty
          ? 'No se especificó el motivo'
          : reasonController.text.trim();
      await BookingService.rejectBooking(
        bookingUid: bookingUid,
        reason: reason,
      );
      setState(() => _loadData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onProfileTap,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: widget.user.photoUrl.isNotEmpty
                        ? NetworkImage(widget.user.photoUrl)
                        : null,
                    onBackgroundImageError: (_, __) {},
                    child: widget.user.photoUrl.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola, ${widget.user.name.split(' ').first}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      'Cuidador',
                      style: TextStyle(color: Colors.black45, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),

            // ── Próxima cita ─────────────────────────────
            const Text(
              'Próxima cita',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            FutureBuilder<BookingModel?>(
              future: _nextBookingFuture,
              builder: (context, snap) {
                if (!snap.hasData) {
                  return snap.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              'No tienes citas próximas',
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                        );
                }
                final b = snap.data!;
                return _NextBookingCard(booking: b, blockLabels: _blockLabels);
              },
            ),
            const SizedBox(height: 28),

            // ── Solicitudes pendientes ───────────────────
            const Text(
              'Solicitudes pendientes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<BookingModel>>(
              future: _pendingFuture,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snap.hasData || snap.data!.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'No hay solicitudes pendientes',
                        style: TextStyle(color: Colors.black45),
                      ),
                    ),
                  );
                }
                return Column(
                  children: snap.data!
                      .map(
                        (b) => _PendingCard(
                          booking: b,
                          blockLabels: _blockLabels,
                          onConfirm: () => _confirm(b.uid),
                          onReject: () => _reject(b.uid),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Próxima cita card ────────────────────────────────────────

class _NextBookingCard extends StatelessWidget {
  final BookingModel booking;
  final Map<String, String> blockLabels;

  const _NextBookingCard({required this.booking, required this.blockLabels});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFAC7099),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAC7099).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                DateFormat('EEEE d MMMM, yyyy', 'es_ES').format(booking.date),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                blockLabels[booking.timeBlock] ?? booking.timeBlock,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                booking.tutorName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (booking.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.note, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    booking.notes,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '\$${booking.priceSnapshot} · ${booking.childrenUids.length} niño(s)',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pending card ─────────────────────────────────────────────

class _PendingCard extends StatelessWidget {
  final BookingModel booking;
  final Map<String, String> blockLabels;
  final VoidCallback onConfirm;
  final VoidCallback onReject;

  const _PendingCard({
    required this.booking,
    required this.blockLabels,
    required this.onConfirm,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tutor info
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: Colors.black45),
              const SizedBox(width: 6),
              Text(
                booking.tutorName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Fecha
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.black45),
              const SizedBox(width: 6),
              Text(
                DateFormat('EEEE d MMMM, yyyy', 'es_ES').format(booking.date),
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Bloque
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.black45),
              const SizedBox(width: 6),
              Text(
                blockLabels[booking.timeBlock] ?? booking.timeBlock,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Precio y niños
          Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                size: 14,
                color: Colors.black45,
              ),
              const SizedBox(width: 6),
              Text(
                '\$${booking.priceSnapshot} · ${booking.childrenUids.length} niño(s)',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          if (booking.notes.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.note, size: 14, color: Colors.black45),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    booking.notes,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          // Botones
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Rechazar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAC7099),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Aceptar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
