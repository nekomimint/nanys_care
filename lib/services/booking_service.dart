//Simulador de firebase
//También simula cuando se envía una solicitud de cita al cuidador, pero no sale en la pantalla del cuidador
//Simulador de firebase
import '../models/booking_model.dart';

class BookingService {

  static List<BookingModel> bookings = [

    BookingModel(

      caregiverName: "María López",

      tutorName: "Krystina",

      date: DateTime.now().add(
        const Duration(days: 1),
      ),

      timeSlot: "Mañana",

      notes:
          "Mi hijo es alérgico al cacahuate",

      status: "Aceptada",
    ),

    BookingModel(

      caregiverName: "Ana Torres",

      tutorName: "Carlos",

      date: DateTime.now().add(
        const Duration(days: 3),
      ),

      timeSlot: "Tarde",

      notes:
          "Necesita ayuda con tareas",

      status: "Aceptada",
    ),

    BookingModel(

      caregiverName: "Fernanda Ruiz",

      tutorName: "Laura",

      date: DateTime.now().add(
        const Duration(days: 5),
      ),

      timeSlot: "Noche",

      notes:
          "Dormir temprano",

      status: "Pendiente",
    ),
  ];

  static void addBooking(
    BookingModel booking,
  ) {

    bookings.add(booking);

    print(bookings.length);
    print(booking.tutorName);
    print(booking.timeSlot);
  }

  static void updateBookingStatus(
    BookingModel booking,
    String newStatus,
  ) {

    booking.status = newStatus;
  }
}
