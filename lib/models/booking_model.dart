import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String uid;
  // ── Partes involucradas ──────────────────────
  final String caregiverUid;
  final String caregiverName;
  final String caregiverPhoto;
  final String tutorUid;
  final String tutorName;
  final List<String> childrenUids;

  // ── Detalles de la reserva ───────────────────
  final DateTime date;
  final String timeBlock; // 'manana', 'mediodia', 'tarde', 'noche'
  final int priceSnapshot; // precio del caregiver AL MOMENTO de reservar
  final String notes;

  // ── Estado ──────────────────────────────────
  final String status;
  // 'pendiente' → 'confirmada' → 'en_curso' → 'completada'
  //      ↓              ↓
  // 'rechazada'     'cancelada'
  // ── Cancelación ─────────────────────────────
  final String? cancelledBy; // 'tutor' o 'caregiver'
  final String? cancellationReason;

  // ── Timestamps del ciclo de vida ────────────
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? pickedUpAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;

  const BookingModel({
    required this.uid,
    required this.caregiverUid,
    required this.caregiverName,
    required this.caregiverPhoto,
    required this.tutorUid,
    required this.tutorName,
    required this.childrenUids,
    required this.date,
    required this.timeBlock,
    required this.priceSnapshot,
    required this.notes,
    required this.status,
    required this.createdAt,
    this.cancelledBy,
    this.cancellationReason,
    this.confirmedAt,
    this.pickedUpAt,
    this.completedAt,
    this.cancelledAt,
  });

  factory BookingModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return BookingModel(
      uid: uid,
      caregiverUid: data['caregiver_uid'] ?? '',
      caregiverName: data['caregiver_name'] ?? '',
      caregiverPhoto: data['caregiver_photo'] ?? '',
      tutorUid: data['tutor_uid'] ?? '',
      tutorName: data['tutor_name'] ?? '',
      childrenUids: List<String>.from(data['children_uids'] ?? []),
      date: (data['date'] as Timestamp).toDate(),
      timeBlock: data['time_block'] ?? 'manana',
      priceSnapshot: data['price_snapshot'] ?? 0,
      notes: data['notes'] ?? '',
      status: data['status'] ?? 'pendiente',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      cancelledBy: data['cancelled_by'],
      cancellationReason: data['cancellation_reason'],
      confirmedAt: (data['confirmed_at'] as Timestamp?)?.toDate(),
      pickedUpAt: (data['picked_up_at'] as Timestamp?)?.toDate(),
      completedAt: (data['completed_at'] as Timestamp?)?.toDate(),
      cancelledAt: (data['cancelled_at'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'caregiver_uid': caregiverUid,
      'caregiver_name': caregiverName,
      'caregiver_photo': caregiverPhoto,
      'tutor_uid': tutorUid,
      'tutor_name': tutorName,
      'children_uids': childrenUids,
      'date': date,
      'time_block': timeBlock,
      'price_snapshot': priceSnapshot,
      'notes': notes,
      'status': status,
      'created_at': createdAt,
      'cancelled_by': cancelledBy,
      'cancellation_reason': cancellationReason,
      'confirmed_at': confirmedAt,
      'picked_up_at': pickedUpAt,
      'completed_at': completedAt,
      'cancelled_at': cancelledAt,
    };
  }
}
