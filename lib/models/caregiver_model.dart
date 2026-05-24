class CaregiverModel {

  final String name;

  final String experience;

  final int price;

  final double rating;

  final String imageUrl;

  final List<String> availability;

  final List<ReviewModel> reviews;

  CaregiverModel({

    required this.name,

    required this.experience,

    required this.price,

    required this.rating,

    required this.imageUrl,

    required this.availability,

    required this.reviews,
  });
}

class ReviewModel {

  final String comment;

  final double rating;

  ReviewModel({

    required this.comment,

    required this.rating,
  });
}