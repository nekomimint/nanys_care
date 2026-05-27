import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';

class BookingService {
  static Future<void> createBooking({
    required String caregiverUid,
    required String tutorUid,
    required String tutorName,
    required DateTime date,
    required String timeSlot,
    String notes = '',
    List<String> childrenUids = const [],
  }) async {
    // 1. Traer datos del caregiver desde users
    final caregiverDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(caregiverUid)
        .get();

    final caregiverData = caregiverDoc.data()!;
    final caregiverName = caregiverData['name'] ?? '';
    final caregiverPhoto =
        caregiverData['photo_url'] ??
        ''; // ajusta el campo a como lo tengas en Firestore

    // 2. Crear el documento con todo resuelto
    final ref = FirebaseFirestore.instance.collection('bookings').doc();
    await ref.set({
      'caregiver_uid': caregiverUid,
      'caregiver_name': caregiverName,
      'caregiver_photo': caregiverPhoto, // URL directa de Storage
      'tutor_uid': tutorUid,
      'tutor_name': tutorName,
      'date': date,
      'time_slot': timeSlot,
      'notes': notes,
      'status': 'pendiente',
      'children_uids': childrenUids,
    });
  }
}
