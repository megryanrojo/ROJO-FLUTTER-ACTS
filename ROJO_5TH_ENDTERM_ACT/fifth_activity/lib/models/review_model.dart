class Review {
  final int id;
  final int productId;
  final int buyerId;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final String? buyerName;
  final String? buyerProfileImage;

  Review({
    required this.id,
    required this.productId,
    required this.buyerId,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.buyerName,
    this.buyerProfileImage,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      productId: json['product_id'],
      buyerId: json['buyer_id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      buyerName: json['full_name'],
      buyerProfileImage: json['profile_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'buyer_id': buyerId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
