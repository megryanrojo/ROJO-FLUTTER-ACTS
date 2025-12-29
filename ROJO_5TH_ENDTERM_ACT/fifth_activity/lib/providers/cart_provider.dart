import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../services/api_service.dart';

class CartProvider extends ChangeNotifier {
  Cart? _cart;
  bool _isLoading = false;
  String? _error;

  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _cart?.items.length ?? 0;
  double get total => _cart?.total ?? 0.0;

  // Get cart
  Future<void> getCart() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await ApiService.get('cart', requiresAuth: true);

      if (response.isSuccess && response.data != null) {
        _cart = Cart.fromJson(response.data);
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

  // Add item to cart
  Future<bool> addItem(int productId, int quantity) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await ApiService.post(
        'cart/items',
        {
          'product_id': productId,
          'quantity': quantity,
        },
        requiresAuth: true,
      );

      if (response.isSuccess) {
        await getCart(); // Refresh cart
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

  // Update item quantity
  Future<bool> updateItemQuantity(int itemId, int quantity) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await ApiService.put(
        'cart/items/$itemId',
        {'quantity': quantity},
        requiresAuth: true,
      );

      if (response.isSuccess) {
        await getCart();
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

  // Remove item from cart
  Future<bool> removeItem(int itemId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await ApiService.delete(
        'cart/items/$itemId',
        requiresAuth: true,
      );

      if (response.isSuccess) {
        await getCart();
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

  // Clear cart
  Future<bool> clearCart() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await ApiService.delete(
        'cart',
        requiresAuth: true,
      );

      if (response.isSuccess) {
        _cart = Cart(id: 0, userId: 0);
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
}
