//Este archivo se usa para pruebas mientras está la base de datos, luego vemos que hacer con el
import '../models/caregiver_model.dart';

class CaregiverService {

  static List<CaregiverModel> caregivers = [

    CaregiverModel(

      name: "María López",

      experience: "5 años de experiencia",

      price: 250,

      rating: 4.8,

      imageUrl:
          "https://i.pravatar.cc/300?img=5",

      availability: [
        "Lunes-Mañana",
        "Martes-Tarde",
      ],

     reviews: [

        ReviewModel(
          comment:
              "Muy amable con los niños",

          rating: 5,
        ),

        ReviewModel(
          comment:
              "Siempre llega puntual",

          rating: 4.5,
        ),

        ReviewModel(
          comment:
              "Excelente atención",

          rating: 5,
        ),
      ],
    ),

    CaregiverModel(

      name: "Ana Torres",

      experience: "3 años de experiencia",

      price: 180,

      rating: 4.5,

      imageUrl:
          "https://i.pravatar.cc/300?img=10",

      availability: [
        "Viernes-Noche",
      ],

      reviews: [

        ReviewModel(
          comment:
              "Muy amable con los niños",

          rating: 5,
        ),

        ReviewModel(
          comment:
              "Siempre llega puntual",

          rating: 4.5,
        ),

        ReviewModel(
          comment:
              "Excelente atención",

          rating: 5,
        ),
      ],
    ),

    CaregiverModel(

      name: "Fernanda Ruiz",

      experience: "7 años de experiencia",

      price: 320,

      rating: 4.9,

      imageUrl:
          "https://i.pravatar.cc/300?img=20",

      availability: [
        "Miércoles-Mañana",
      ],

      reviews: [

        ReviewModel(
          comment:
              "Muy amable con los niños",

          rating: 5,
        ),

        ReviewModel(
          comment:
              "Siempre llega puntual",

          rating: 4.5,
        ),

        ReviewModel(
          comment:
              "Excelente atención",

          rating: 5,
        ),
      ],
    ),
  ];
}