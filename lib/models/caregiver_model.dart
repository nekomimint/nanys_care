class CaregiverModel {
  final String uid;
  final String name;
  final String experience;
  final int price;
  final double rating;
  final String imageUrl;
  final List<String> availability;
  final List<ReviewModel> reviews;
  const CaregiverModel({
    required this.uid,
    required this.name,
    required this.experience,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.availability,
    required this.reviews,
  });

  factory CaregiverModel.fromFirestore(Map<String, dynamic> data) {
    return CaregiverModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      experience: data['experience'] ?? '',
      price: data['price'] ?? 0,
      rating: (data['rating'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      availability: List<String>.from(data['availability'] ?? []),
      reviews: (data['reviews'] as List<dynamic>? ?? []).map((reviewData) {
        return ReviewModel.fromFirestore(reviewData);
      }).toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'experience': experience,
      'price': price,
      'rating': rating,
      'imageUrl': imageUrl,
      'availability': availability,
      'reviews': reviews.map((review) {
        return review.toFirestore();
      }).toList(),
    };
  }
}

class ReviewModel {
  final String comment;
  final double rating;
  const ReviewModel({required this.comment, required this.rating});

  factory ReviewModel.fromFirestore(Map<String, dynamic> data) {
    return ReviewModel(
      comment: data['comment'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'comment': comment, 'rating': rating};
  }
}
