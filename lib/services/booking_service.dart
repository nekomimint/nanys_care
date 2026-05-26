//Simulador de firebase
//También simula cuando se envía una solicitud de cita al cuidador, pero no sale en la pantalla del cuidador
import '../models/booking_model.dart';

class BookingService {

  static List<BookingModel> bookings = [

    //Solicitud fake para hacer pruebas
    BookingModel(
      caregiverName: "María López",
      tutorName: "Krystina",
      date: DateTime.now(),
      timeSlot: "Mañana",
      notes: "Mi hijo es alérgico al cacahuate",
      status: "Pendiente",
    ),
  ];

  static void addBooking(
    BookingModel booking,
  ) {

    bookings.add(booking);

    // pruebas
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
