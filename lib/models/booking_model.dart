class BookingModel {

  final String caregiverName;

  final String tutorName;

  final DateTime date;

  final String timeSlot;

  final String notes;

  String status;

  BookingModel({

    required this.caregiverName,

    required this.tutorName,

    required this.date,

    required this.timeSlot,

    required this.notes,

    required this.status,
  });
}