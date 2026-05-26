//Simulador de firebase
//También simula cuando se envía una solicitud de cita al cuidador y este la rechaza o acepta
import '../models/booking_model.dart';

class BookingService {

  static List<BookingModel> bookings = [];

  static void addBooking(
    BookingModel booking,
  ) {

    bookings.add(booking);
  }

  static void updateBookingStatus(
    BookingModel booking,
    String newStatus,
  ) {

    booking.status = newStatus;

    {

      bookings.add(booking);
      //Estos prints son para pruebas, hay que quitarlos al final
      print("RESERVA GUARDADA");

      print(booking.caregiverName);

      print(booking.date);

      print(booking.timeSlot);

      print(booking.notes);

      print("----------------");

      print(
        "TOTAL RESERVAS: ${bookings.length}",
      );
    }
  }

  
}

