class Booking {
  final String id;
  final String venueId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final DateTime bookingDate;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final String status;

  Booking({
    required this.id,
    required this.venueId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
  });
}
