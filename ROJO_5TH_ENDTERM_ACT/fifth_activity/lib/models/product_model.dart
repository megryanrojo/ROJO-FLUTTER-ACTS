class Product {
  final int id;
  final int sellerId;
  final String name;
  final String description;
  final double price;
  final int stockQuantity;
  final String? imageUrl;
  final String? category;
  final double rating;
  final int totalReviews;
  final String status;

  Product({
    required this.id,
    required this.sellerId,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    this.imageUrl,
    this.category,
    this.rating = 0.0,
    this.totalReviews = 0,
    required this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      sellerId: json['seller_id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      stockQuantity: json['stock_quantity'] ?? 0,
      imageUrl: json['image_url'],
      category: json['category'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] ?? 0,
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seller_id': sellerId,
      'name': name,
      'description': description,
      'price': price,
      'stock_quantity': stockQuantity,
      'image_url': imageUrl,
      'category': category,
      'rating': rating,
      'total_reviews': totalReviews,
      'status': status,
    };
  }
}
