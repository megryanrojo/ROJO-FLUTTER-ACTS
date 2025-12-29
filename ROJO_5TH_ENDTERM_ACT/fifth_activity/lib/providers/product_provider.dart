import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  String? _selectedCategory;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get all products
  Future<void> getProducts({int page = 1, String? category}) async {
    try {
      _isLoading = true;
      _error = null;
      _currentPage = page;
      _selectedCategory = category;
      notifyListeners();

      String endpoint = 'products?page=$page';
      if (category != null) {
        endpoint += '&category=$category';
      }

      final response = await ApiService.get(endpoint);

      if (response.isSuccess && response.data != null) {
        final products = List<Product>.from(
          (response.data['products'] as List).map((p) => Product.fromJson(p)),
        );
        _products = products;
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

  // Get product by ID
  Future<Product?> getProductById(int id) async {
    try {
      final response = await ApiService.get('products/$id');

      if (response.isSuccess && response.data != null) {
        return Product.fromJson(response.data);
      } else {
        _error = response.message;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Get products by seller
  Future<List<Product>> getProductsBySeller(int sellerId, {int page = 1}) async {
    try {
      final response = await ApiService.get('sellers/$sellerId/products?page=$page');

      if (response.isSuccess && response.data != null) {
        return List<Product>.from(
          (response.data['products'] as List).map((p) => Product.fromJson(p)),
        );
      } else {
        _error = response.message;
        notifyListeners();
        return [];
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  // Create product
  Future<bool> createProduct({
    required String name,
    required String description,
    required double price,
    required int stockQuantity,
    required String imageUrl,
    required String category,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await ApiService.post(
        'products',
        {
          'name': name,
          'description': description,
          'price': price,
          'stock_quantity': stockQuantity,
          'image_url': imageUrl,
          'category': category,
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

  // Update product
  Future<bool> updateProduct({
    required int id,
    required String name,
    required String description,
    required double price,
    required int stockQuantity,
    String? imageUrl,
    String? category,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await ApiService.put(
        'products/$id',
        {
          'name': name,
          'description': description,
          'price': price,
          'stock_quantity': stockQuantity,
          if (imageUrl != null) 'image_url': imageUrl,
          if (category != null) 'category': category,
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

  // Delete product
  Future<bool> deleteProduct(int id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await ApiService.delete(
        'products/$id',
        requiresAuth: true,
      );

      if (response.isSuccess) {
        _products.removeWhere((p) => p.id == id);
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
