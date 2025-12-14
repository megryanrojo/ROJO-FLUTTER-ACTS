class Product {
  final String id;
  final String title;
  final double price;
  final String imageUrl;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      title: data['title'] as String? ?? 'Product',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      imageUrl: data['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'price': price, 'imageUrl': imageUrl};
  }
}
