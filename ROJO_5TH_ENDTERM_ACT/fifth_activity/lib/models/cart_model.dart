import 'product_model.dart';

class CartItem {
  final int id;
  final int cartId;
  final int productId;
  final int quantity;
  final Product? product;

  CartItem({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      cartId: json['cart_id'],
      productId: json['product_id'],
      quantity: json['quantity'] ?? 1,
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart_id': cartId,
      'product_id': productId,
      'quantity': quantity,
    };
  }
}

class Cart {
  final int id;
  final int userId;
  final List<CartItem> items;
  final double total;

  Cart({
    required this.id,
    required this.userId,
    this.items = const [],
    this.total = 0.0,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    List<CartItem> items = [];
    if (json['items'] != null) {
      items = List<CartItem>.from(
        (json['items'] as List).map((item) => CartItem.fromJson(item)),
      );
    }
    return Cart(
      id: json['cart_id'],
      userId: json['user_id'] ?? 0,
      items: items,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
    };
  }
}
