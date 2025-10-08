import '../models/booking.dart';

class BookingService {
  static final List<Booking> _bookings = [];

  static List<Booking> getAllBookings() {
    return _bookings;
  }

  static void addBooking(Booking booking) {
    _bookings.add(booking);
  }

  static List<Booking> getBookingsByVenueId(String venueId) {
    return _bookings.where((booking) => booking.venueId == venueId).toList();
  }

  static double calculateTotalPrice(double pricePerHour, DateTime startTime, DateTime endTime) {
    final duration = endTime.difference(startTime);
    final hours = duration.inMinutes / 60.0;
    return pricePerHour * hours;
  }
}
