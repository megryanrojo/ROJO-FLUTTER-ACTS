class Booking {
  final String id;
  final String facility;
  final double price;
  final DateTime date;
  final String time;
  final String status;
  final String role;

  const Booking({
    required this.id,
    required this.facility,
    required this.price,
    required this.date,
    required this.time,
    required this.status,
    required this.role,
  });

  factory Booking.fromMap(String id, Map<String, dynamic> data) {
    return Booking(
      id: id,
      facility: data['facility'] as String? ?? 'Facility',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      date: DateTime.tryParse(data['date'] as String? ?? '') ?? DateTime.now(),
      time: data['time'] as String? ?? '',
      status: data['status'] as String? ?? 'pending',
      role: data['role'] as String? ?? 'User',
    );
  }

  Map<String, dynamic> toMap(String uid) {
    return {
      'facility': facility,
      'price': price,
      'date': date.toIso8601String(),
      'time': time,
      'status': status,
      'role': role,
      'uid': uid,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}
