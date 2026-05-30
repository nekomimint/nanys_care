import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';

class BookingService {
  // ── Consultas ──────────────────────────────────────────

  static Future<List<BookingModel>> getBookingsByTutor(String tutorUid) async {
    final snap = await FirebaseFirestore.instance
        .collection('bookings')
        .where('tutor_uid', isEqualTo: tutorUid)
        .orderBy('date', descending: true)
        .get(const GetOptions(source: Source.server));

    return snap.docs
        .map((doc) => BookingModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  static Future<List<BookingModel>> getBookingsByCaregiver(
    String caregiverUid,
  ) async {
    final snap = await FirebaseFirestore.instance
        .collection('bookings')
        .where('caregiver_uid', isEqualTo: caregiverUid)
        .orderBy('date', descending: true)
        .get(const GetOptions(source: Source.server));

    return snap.docs
        .map((doc) => BookingModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  // Útil para el home del caregiver — solo pendientes
  static Future<List<BookingModel>> getPendingByCaregiver(
    String caregiverUid,
  ) async {
    print('getPending para: $caregiverUid');
    final snap = await FirebaseFirestore.instance
        .collection('bookings')
        .where('caregiver_uid', isEqualTo: caregiverUid)
        .where('status', isEqualTo: 'pendiente')
        .orderBy('created_at', descending: false)
        .get(const GetOptions(source: Source.server));
    print('Pendientes encontrados: ${snap.docs.length}');
    print('Docs: ${snap.docs.map((d) => d.data()).toList()}');
    return snap.docs
        .map((doc) => BookingModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  // Próxima cita confirmada del caregiver
  static Future<BookingModel?> getNextBooking(String caregiverUid) async {
    final now = DateTime.now();
    final snap = await FirebaseFirestore.instance
        .collection('bookings')
        .where('caregiver_uid', isEqualTo: caregiverUid)
        .where('status', isEqualTo: 'confirmada')
        .where('date', isGreaterThanOrEqualTo: now)
        .orderBy('date', descending: false)
        .limit(1)
        .get(const GetOptions(source: Source.server));

    if (snap.docs.isEmpty) return null;
    return BookingModel.fromFirestore(
      snap.docs.first.data(),
      snap.docs.first.id,
    );
  }

  // ── Disponibilidad ─────────────────────────────────────

  static Future<bool> isBlockAvailable({
    required String caregiverUid,
    required DateTime date,
    required String timeBlock,
  }) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final snap = await FirebaseFirestore.instance
        .collection('bookings')
        .where('caregiver_uid', isEqualTo: caregiverUid)
        .where('time_block', isEqualTo: timeBlock)
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThan: end)
        .where('status', whereIn: ['pendiente', 'confirmada', 'en_curso'])
        .get();

    return snap.docs.isEmpty;
  }

  // Devuelve qué bloques están ocupados para un caregiver en una fecha
  static Future<List<String>> getOccupiedBlocks({
    required String caregiverUid,
    required DateTime date,
  }) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final snap = await FirebaseFirestore.instance
        .collection('bookings')
        .where('caregiver_uid', isEqualTo: caregiverUid)
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThan: end)
        .where('status', whereIn: ['pendiente', 'confirmada', 'en_curso'])
        .get();

    return snap.docs.map((doc) => doc.data()['time_block'] as String).toList();
  }

  // ── Crear ──────────────────────────────────────────────

  static Future<void> createBooking(BookingModel booking) async {
    final available = await isBlockAvailable(
      caregiverUid: booking.caregiverUid,
      date: booking.date,
      timeBlock: booking.timeBlock,
    );

    if (!available) throw Exception('block_unavailable');

    final ref = FirebaseFirestore.instance.collection('bookings').doc();
    await ref.set(booking.toFirestore());
  }

  // ── Ciclo de vida ──────────────────────────────────────

  static Future<void> confirmBooking(String bookingUid) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingUid)
        .update({'status': 'confirmada', 'confirmed_at': DateTime.now()});
  }

  static Future<void> startBooking(String bookingUid) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingUid)
        .update({'status': 'en_curso', 'picked_up_at': DateTime.now()});
  }

  static Future<void> completeBooking(String bookingUid) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingUid)
        .update({'status': 'completada', 'completed_at': DateTime.now()});
  }

  static Future<void> cancelBooking({
    required String bookingUid,
    required String cancelledBy,
    String? reason,
  }) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingUid)
        .update({
          'status': 'cancelada',
          'cancelled_at': DateTime.now(),
          'cancelled_by': cancelledBy,
          'cancellation_reason': reason,
        });
  }

  static Future<void> rejectBooking({
    required String bookingUid,
    String? reason,
  }) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingUid)
        .update({
          'status': 'rechazada',
          'cancelled_at': DateTime.now(),
          'cancelled_by': 'caregiver',
          'cancellation_reason': reason,
        });
  }

  // Citas próximas del tutor (confirmadas, en_curso)
  static Future<List<BookingModel>> getUpcomingByTutor(String tutorUid) async {
    final snap = await FirebaseFirestore.instance
        .collection('bookings')
        .where('tutor_uid', isEqualTo: tutorUid)
        .where('status', whereIn: ['confirmada', 'en_curso'])
        .orderBy('date', descending: false)
        .get(const GetOptions(source: Source.server));
    return snap.docs
        .map((doc) => BookingModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  // Historial del tutor (completadas, canceladas, rechazadas)
  static Future<List<BookingModel>> getHistoryByTutor(String tutorUid) async {
    final snap = await FirebaseFirestore.instance
        .collection('bookings')
        .where('tutor_uid', isEqualTo: tutorUid)
        .where('status', whereIn: ['completada', 'cancelada', 'rechazada'])
        .orderBy('date', descending: true)
        .get(const GetOptions(source: Source.server));
    return snap.docs
        .map((doc) => BookingModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  // Pendientes del tutor
  static Future<List<BookingModel>> getPendingByTutor(String tutorUid) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('bookings')
          .where('tutor_uid', isEqualTo: tutorUid)
          .where('status', isEqualTo: 'pendiente')
          .orderBy('created_at', descending: false)
          .get(const GetOptions(source: Source.server));
      return snap.docs
          .map((doc) => BookingModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('ERROR FIRESTORE getPendingByTutor: $e');
      rethrow;
    }
  }

  // Citas próximas del caregiver
  static Future<List<BookingModel>> getUpcomingByCaregiver(
    String caregiverUid,
  ) async {
    print('getUpcoming para: $caregiverUid');
    final snap = await FirebaseFirestore.instance
        .collection('bookings')
        .where('caregiver_uid', isEqualTo: caregiverUid)
        .where('status', whereIn: ['confirmada', 'en_curso'])
        .orderBy('date', descending: false)
        .get(const GetOptions(source: Source.server));
    print('Upcoming encontrados: ${snap.docs.length}');
    return snap.docs
        .map((doc) => BookingModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  // Historial del caregiver
  static Future<List<BookingModel>> getHistoryByCaregiver(
    String caregiverUid,
  ) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('bookings')
          .where('caregiver_uid', isEqualTo: caregiverUid)
          .where('status', whereIn: ['completada', 'cancelada', 'rechazada'])
          .orderBy('date', descending: true)
          .get(const GetOptions(source: Source.server));
      return snap.docs
          .map((doc) => BookingModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('ERROR FIRESTORE getPendingByTutor: $e');
      rethrow;
    }
  }

  static Future<List<BookingModel>> getInProgressByCaregiver(
    String caregiverUid,
  ) async {
    final snap = await FirebaseFirestore.instance
        .collection('bookings')
        .where('caregiver_uid', isEqualTo: caregiverUid)
        .where('status', isEqualTo: 'en_curso')
        .orderBy('date', descending: false)
        .get(const GetOptions(source: Source.server));
    return snap.docs
        .map((doc) => BookingModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }
}
