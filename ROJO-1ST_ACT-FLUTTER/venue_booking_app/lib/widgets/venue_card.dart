import 'package:flutter/material.dart';
import '../models/venue.dart';
import 'placeholder_image.dart';

class VenueCard extends StatelessWidget {
  final Venue venue;
  final VoidCallback onTap;

  const VenueCard({
    super.key,
    required this.venue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: _buildVenueImage(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    venue.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.people, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('${venue.capacity} people'),
                        ],
                      ),
                      Text(
                        '₱${venue.pricePerHour.toStringAsFixed(0)}/hour',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          venue.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVenueImage() {
    // Define colors for different venue types
    Color backgroundColor;
    String displayText;
    
    switch (venue.imageUrl) {
      case 'ballroom':
        backgroundColor = Colors.purple[400]!;
        displayText = 'Grand Ballroom';
        break;
      case 'garden':
        backgroundColor = Colors.green[400]!;
        displayText = 'Garden Pavilion';
        break;
      case 'conference':
        backgroundColor = Colors.blue[400]!;
        displayText = 'Conference Hall';
        break;
      case 'rooftop':
        backgroundColor = Colors.orange[400]!;
        displayText = 'Rooftop Terrace';
        break;
      default:
        backgroundColor = Colors.grey[400]!;
        displayText = 'Venue';
    }

    return PlaceholderImage(
      text: displayText,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      height: 200,
    );
  }
}
