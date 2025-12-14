import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/booking.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService _instance = FirestoreService._();
  factory FirestoreService() => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _bookingsRef =>
      _firestore.collection('bookings');

  DocumentReference<Map<String, dynamic>>? get _userDoc {
    final uid = _uid;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid);
  }

  CollectionReference<Map<String, dynamic>>? get _cartRef =>
      _userDoc?.collection('cart');
  CollectionReference<Map<String, dynamic>>? get _ordersRef =>
      _userDoc?.collection('orders');

  Stream<List<Booking>> bookingsStream() {
    final uid = _uid;
    if (uid == null) return Stream<List<Booking>>.value(const <Booking>[]);
    return _bookingsRef
        .where('uid', isEqualTo: uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Booking.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addBooking({
    required String facility,
    required double price,
    required DateTime date,
    required String time,
    required String role,
  }) async {
    final uid = _uid;
    if (uid == null) throw StateError('You must be logged in');
    await _bookingsRef.add(
      Booking(
        id: '',
        facility: facility,
        price: price,
        date: date,
        time: time,
        status: 'pending',
        role: role,
      ).toMap(uid),
    );
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _bookingsRef.doc(bookingId).update({
      'status': status,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteBooking(String bookingId) =>
      _bookingsRef.doc(bookingId).delete();

  Stream<List<CartItem>> cartStream() {
    final ref = _cartRef;
    if (ref == null) return Stream<List<CartItem>>.value(const <CartItem>[]);
    return ref
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CartItem.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    final ref = _cartRef;
    if (ref == null) throw StateError('You must be logged in');
    await ref
        .doc(product.id)
        .set(
          CartItem(
            id: product.id,
            title: product.title,
            price: product.price,
            quantity: quantity,
            imageUrl: product.imageUrl,
          ).toMap(),
          SetOptions(merge: true),
        );
  }

  Future<void> buyNow(Product product, {int quantity = 1}) async {
    final orders = _ordersRef;
    if (orders == null) throw StateError('You must be logged in');
    await orders.add({
      'title': product.title,
      'price': product.price,
      'quantity': quantity,
      'imageUrl': product.imageUrl,
      'purchasedAt': DateTime.now().toIso8601String(),
    });
  }

  Stream<Map<String, dynamic>?> userProfileStream() {
    final doc = _userDoc;
    if (doc == null) return Stream<Map<String, dynamic>?>.value(null);
    return doc.snapshots().map((snap) => snap.data());
  }

  Future<void> saveUserProfile({
    required String role,
    required DateTime? availabilityDate,
    required String? availabilityTime,
  }) async {
    final doc = _userDoc;
    if (doc == null) throw StateError('Missing user');
    await doc.set({
      'role': role,
      'availabilityDate': availabilityDate?.toIso8601String(),
      'availabilityTime': availabilityTime,
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }
}
