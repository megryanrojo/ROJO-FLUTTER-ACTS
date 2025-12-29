class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int sellerId;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final String? productName;
  final String? imageUrl;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.sellerId,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    this.productName,
    this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      sellerId: json['seller_id'],
      quantity: json['quantity'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      productName: json['product_name'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'seller_id': sellerId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'subtotal': subtotal,
    };
  }
}

class Order {
  final int id;
  final int buyerId;
  final String orderNumber;
  final double totalAmount;
  final String status;
  final String shippingAddress;
  final String shippingCity;
  final String shippingZip;
  final String? notes;
  final DateTime createdAt;
  final List<OrderItem>? items;

  Order({
    required this.id,
    required this.buyerId,
    required this.orderNumber,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.shippingCity,
    required this.shippingZip,
    this.notes,
    required this.createdAt,
    this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderItem>? items;
    if (json['items'] != null) {
      items = List<OrderItem>.from(
        (json['items'] as List).map((item) => OrderItem.fromJson(item)),
      );
    }
    return Order(
      id: json['id'],
      buyerId: json['buyer_id'],
      orderNumber: json['order_number'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'],
      shippingAddress: json['shipping_address'],
      shippingCity: json['shipping_city'],
      shippingZip: json['shipping_zip'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      items: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer_id': buyerId,
      'order_number': orderNumber,
      'total_amount': totalAmount,
      'status': status,
      'shipping_address': shippingAddress,
      'shipping_city': shippingCity,
      'shipping_zip': shippingZip,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
