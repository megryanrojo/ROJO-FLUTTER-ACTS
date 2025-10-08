import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/venue.dart';
import '../services/venue_service.dart';
import 'venue_card.dart';
import '../views/booking_screen.dart';

class VenueGrid extends StatelessWidget {
  const VenueGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final venues = VenueService.getAllVenues();

    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
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
    );
  }
}
