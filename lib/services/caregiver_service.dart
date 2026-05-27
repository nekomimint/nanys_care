//Este archivo se usa para pruebas mientras está la base de datos, luego vemos que hacer con el

import '../models/caregiver_model.dart';

class CaregiverService {
  static List<CaregiverModel> caregivers = [
    CaregiverModel(
      uid: "1",

      name: "Edgar Klassen",

      experience: "5 años de experiencia",

      price: 250,

      rating: 4.8,

      imageUrl: "https://i.pravatar.cc/300?img=5",

      availability: ["lunes-09:00", "lunes-13:00", "martes-16:00"],

      reviews: [
        ReviewModel(comment: "Muy amable con los niños", rating: 5),

        ReviewModel(comment: "Siempre llega puntual", rating: 4.5),

        ReviewModel(comment: "Excelente atención", rating: 5),
      ],
    ),

    CaregiverModel(
      uid: "2",

      name: "Ana Torres",

      experience: "3 años de experiencia",

      price: 180,

      rating: 4.5,

      imageUrl: "https://i.pravatar.cc/300?img=10",

      availability: ["viernes-18:00", "sábado-10:00"],

      reviews: [
        ReviewModel(comment: "Muy amable con los niños", rating: 5),

        ReviewModel(comment: "Siempre llega puntual", rating: 4.5),

        ReviewModel(comment: "Excelente atención", rating: 5),
      ],
    ),

    CaregiverModel(
      uid: "3",

      name: "Fernanda Ruiz",

      experience: "7 años de experiencia",

      price: 320,

      rating: 4.9,

      imageUrl: "https://i.pravatar.cc/300?img=20",

      availability: ["miércoles-08:00", "jueves-15:00"],

      reviews: [
        ReviewModel(comment: "Muy amable con los niños", rating: 5),

        ReviewModel(comment: "Siempre llega puntual", rating: 4.5),

        ReviewModel(comment: "Excelente atención", rating: 5),
      ],
    ),
  ];
}
