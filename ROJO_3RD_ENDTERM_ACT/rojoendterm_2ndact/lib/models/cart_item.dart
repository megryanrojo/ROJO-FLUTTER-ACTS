class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;

  const CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory CartItem.fromMap(String id, Map<String, dynamic> data) {
    return CartItem(
      id: id,
      title: data['title'] as String? ?? 'Item',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      quantity: (data['quantity'] as num?)?.toInt() ?? 1,
      imageUrl: data['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}


