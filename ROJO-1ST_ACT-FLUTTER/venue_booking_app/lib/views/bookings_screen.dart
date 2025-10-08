import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../models/venue.dart';
import '../services/booking_service.dart';
import '../services/venue_service.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    bookings = BookingService.getAllBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),
      body: bookings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No bookings yet',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Book a venue to see your reservations here',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final venue = VenueService.getVenueById(booking.venueId);
                
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: const Icon(Icons.event, color: Colors.blue),
                    ),
                    title: Text(
                      venue?.name ?? 'Unknown Venue',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Customer: ${booking.customerName}'),
                        Text('Date: ${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year}'),
                        Text('Time: ${booking.startTime.hour}:${booking.startTime.minute.toString().padLeft(2, '0')} - ${booking.endTime.hour}:${booking.endTime.minute.toString().padLeft(2, '0')}'),
                        Text('Total: ₱${booking.totalPrice.toStringAsFixed(2)}'),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(
                        booking.status,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: booking.status == 'Confirmed' ? Colors.green : Colors.orange,
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
