class Venue {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double pricePerHour;
  final int capacity;
  final List<String> amenities;
  final String location;

  Venue({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.pricePerHour,
    required this.capacity,
    required this.amenities,
    required this.location,
  });
}
