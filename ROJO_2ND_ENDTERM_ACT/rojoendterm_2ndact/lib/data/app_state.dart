import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../models/product.dart';

class AppState extends ChangeNotifier {
  final List<Booking> _bookings = [];

  List<Booking> get bookings => List.unmodifiable(_bookings);

  void book(Product p) {
    _bookings.add(Booking(id: p.id, title: p.title, price: p.price, createdAt: DateTime.now()));
    notifyListeners();
  }

  void cancel(String bookingId) {
    _bookings.removeWhere((b) => b.id == bookingId);
    notifyListeners();
  }
}


