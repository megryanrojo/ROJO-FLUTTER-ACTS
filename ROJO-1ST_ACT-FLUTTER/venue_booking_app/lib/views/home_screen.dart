import 'package:flutter/material.dart';
import '../models/venue.dart';
import '../services/venue_service.dart';
import '../widgets/venue_card.dart';
import 'booking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Venue> venues = [];

  @override
  void initState() {
    super.initState();
    venues = VenueService.getAllVenues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venue Booking App'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: venues.length,
        itemBuilder: (context, index) {
          final venue = venues[index];
          return VenueCard(
            venue: venue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingScreen(venue: venue),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
