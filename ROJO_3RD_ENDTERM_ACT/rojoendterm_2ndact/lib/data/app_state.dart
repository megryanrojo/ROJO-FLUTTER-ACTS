import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/firestore_service.dart';

class AppState extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  bool _processing = false;
  String? _lastMessage;

  bool get processing => _processing;
  String? get lastMessage => _lastMessage;

  Future<void> addToCart(Product product) async {
    _setProcessing(true);
    try {
      await _firestore.addToCart(product);
      _lastMessage = '${product.title} added to cart';
    } finally {
      _setProcessing(false);
    }
  }

  Future<void> buyProduct(Product product) async {
    _setProcessing(true);
    try {
      await _firestore.buyNow(product);
      _lastMessage = 'Purchased ${product.title}';
    } finally {
      _setProcessing(false);
    }
  }

  void _setProcessing(bool value) {
    _processing = value;
    notifyListeners();
  }
}
