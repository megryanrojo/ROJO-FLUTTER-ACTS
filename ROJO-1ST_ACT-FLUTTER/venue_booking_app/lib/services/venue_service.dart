import '../models/venue.dart';

class VenueService {
  static final List<Venue> _venues = [
    Venue(
      id: '1',
      name: 'Grand Ballroom',
      description: 'Elegant ballroom perfect for weddings and corporate events',
      imageUrl: 'ballroom',
      pricePerHour: 1500.0,
      capacity: 200,
      amenities: ['Sound System', 'Lighting', 'Catering Kitchen', 'Parking'],
      location: 'Downtown Plaza',
    ),
    Venue(
      id: '2',
      name: 'Garden Pavilion',
      description: 'Beautiful outdoor venue surrounded by nature',
      imageUrl: 'garden',
      pricePerHour: 1000.0,
      capacity: 100,
      amenities: ['Garden Setting', 'Outdoor Sound', 'Restrooms', 'Parking'],
      location: 'Riverside Park',
    ),
    Venue(
      id: '3',
      name: 'Modern Conference Hall',
      description: 'State-of-the-art conference facility for business meetings',
      imageUrl: 'conference',
      pricePerHour: 2000.0,
      capacity: 50,
      amenities: ['Projector', 'WiFi', 'Coffee Service', 'Air Conditioning'],
      location: 'Business District',
    ),
    Venue(
      id: '4',
      name: 'Rooftop Terrace',
      description: 'Stunning rooftop venue with city views',
      imageUrl: 'rooftop',
      pricePerHour: 1200.0,
      capacity: 80,
      amenities: ['City Views', 'Bar Service', 'Heating', 'Elevator Access'],
      location: 'Sky Tower',
    ),
  ];

  static List<Venue> getAllVenues() {
    return _venues;
  }

  static Venue? getVenueById(String id) {
    try {
      return _venues.firstWhere((venue) => venue.id == id);
    } catch (e) {
      return null;
    }
  }
}
