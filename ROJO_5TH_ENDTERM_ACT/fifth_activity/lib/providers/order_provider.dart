import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  Order? _currentOrder;
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => _orders;
  Order? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get user's orders
  Future<void> getOrders({int page = 1}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await ApiService.get('orders?page=$page', requiresAuth: true);

      if (response.isSuccess && response.data != null) {
        _orders = List<Order>.from(
          (response.data['orders'] as List).map((o) => Order.fromJson(o)),
        );
        _isLoading = false;
        notifyListeners();
      } else {
        _error = response.message;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get order details
  Future<void> getOrderDetails(int orderId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await ApiService.get(
        'orders/$orderId',
        requiresAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        _currentOrder = Order.fromJson(response.data['order']);
        _currentOrder = _currentOrder?.copyWith(
          items: (response.data['items'] as List?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList(),
        );
        _isLoading = false;
        notifyListeners();
      } else {
        _error = response.message;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create order
  Future<bool> createOrder({
    required String shippingAddress,
    required String shippingCity,
    required String shippingZip,
    String? notes,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await ApiService.post(
        'orders',
        {
          'shipping_address': shippingAddress,
          'shipping_city': shippingCity,
          'shipping_zip': shippingZip,
          if (notes != null) 'notes': notes,
        },
        requiresAuth: true,
      );

      if (response.isSuccess) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(int orderId, String status) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await ApiService.put(
        'orders/$orderId/status',
        {'status': status},
        requiresAuth: true,
      );

      if (response.isSuccess) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get seller's orders
  Future<void> getSellerOrders({int page = 1}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await ApiService.get(
        'seller/orders?page=$page',
        requiresAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        _orders = List<Order>.from(
          (response.data['orders'] as List).map((o) => Order.fromJson(o)),
        );
        _isLoading = false;
        notifyListeners();
      } else {
        _error = response.message;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}

extension OrderExtension on Order {
  Order copyWith({
    int? id,
    int? buyerId,
    String? orderNumber,
    double? totalAmount,
    String? status,
    String? shippingAddress,
    String? shippingCity,
    String? shippingZip,
    String? notes,
    DateTime? createdAt,
    List<OrderItem>? items,
  }) {
    return Order(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      orderNumber: orderNumber ?? this.orderNumber,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      shippingCity: shippingCity ?? this.shippingCity,
      shippingZip: shippingZip ?? this.shippingZip,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }
}
