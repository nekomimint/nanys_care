//Simulador de firebase
import '../models/booking_model.dart';

class BookingService {

  static List<BookingModel> bookings = [];

  static void addBooking(
  BookingModel booking,
) {

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

