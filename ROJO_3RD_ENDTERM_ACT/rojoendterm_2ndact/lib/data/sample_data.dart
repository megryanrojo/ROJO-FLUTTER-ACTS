import 'package:flutter/material.dart';
import '../models/product.dart';

class SampleData {
  static const facilityImages = [
    'https://images.unsplash.com/photo-1517649763962-0c623066013b?q=80&w=1200&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=1200&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1599050751795-5d0b06cf0e97?q=80&w=1200&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1546519638-68e109498ffc?q=80&w=1200&auto=format&fit=crop',
  ];

  static final gridItems = [
    {'name': 'Basketball', 'icon': Icons.sports_basketball},
    {'name': 'Tennis', 'icon': Icons.sports_tennis},
    {'name': 'Badminton', 'icon': Icons.sports},
    {'name': 'Volleyball', 'icon': Icons.sports_volleyball},
    {'name': 'Table Tennis', 'icon': Icons.sports_tennis_outlined},
    {'name': 'Gym', 'icon': Icons.fitness_center},
  ];

  static const contacts = [
    {
      'name': 'Front Desk',
      'email': 'frontdesk@gofit.center',
      'phone': '+1 555 1000',
    },
    {
      'name': 'Coach Mike',
      'email': 'mike@gofit.center',
      'phone': '+1 555 2233',
    },
    {
      'name': 'Court Manager',
      'email': 'courts@gofit.center',
      'phone': '+1 555 7788',
    },
  ];

  static const dividerItems = [
    'Indoor Courts',
    'Outdoor Courts',
    'Swimming',
    'Strength Area',
    'Cardio Area',
  ];

  static final products = <Product>[
    Product(
      id: 'p1',
      title: 'Basketball Court - 1 hr',
      price: 20.0,
      imageUrl: facilityImages[0],
    ),
    Product(
      id: 'p2',
      title: 'Tennis Court - 1 hr',
      price: 18.0,
      imageUrl: facilityImages[2],
    ),
    Product(
      id: 'p3',
      title: 'Badminton Court - 1 hr',
      price: 12.0,
      imageUrl: facilityImages[3],
    ),
    Product(
      id: 'p4',
      title: 'Day Gym Pass',
      price: 5.0,
      imageUrl: facilityImages[1],
    ),
  ];
}
