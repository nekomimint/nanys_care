class BookingModel {
  final String uid;
  final String caregiverUid;
  final String caregiverName;
  final String caregiverPhoto;
  final String tutorUid;
  final String tutorName;
  final DateTime date;
  final String timeSlot;
  final String notes;
  final String status; // 'pendiente', 'confirmada', 'cancelada'
  final List<String> childrenUids; // uids de los niños involucrados

  const BookingModel({
    required this.uid,
    required this.caregiverUid,
    required this.caregiverName,
    required this.caregiverPhoto,
    required this.tutorUid,
    required this.tutorName,
    required this.date,
    required this.timeSlot,
    required this.notes,
    required this.status,
    required this.childrenUids,
  });

  factory BookingModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return BookingModel(
      uid: uid,
      caregiverUid: data['caregiver_uid'] ?? '',
      caregiverName: data['caregiver_name'] ?? '',
      caregiverPhoto: data['caregiver_photo'] ?? '',
      tutorUid: data['tutor_uid'] ?? '',
      tutorName: data['tutor_name'] ?? '',
      date: (data['date'] as dynamic).toDate(),
      timeSlot: data['time_slot'] ?? '',
      notes: data['notes'] ?? '',
      status: data['status'] ?? 'pendiente',
      childrenUids: List<String>.from(data['children_uids'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'caregiver_uid': caregiverUid,
      'caregiver_name': caregiverName,
      'caregiver_photo': caregiverPhoto,
      'tutor_uid': tutorUid,
      'tutor_name': tutorName,
      'date': date,
      'time_slot': timeSlot,
      'notes': notes,
      'status': status,
      'children_uids': childrenUids,
    };
  }
}
