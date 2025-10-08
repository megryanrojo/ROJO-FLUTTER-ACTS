import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/venue.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';
import '../widgets/custom_button.dart';

class BookingScreen extends StatefulWidget {
  final Venue venue;

  const BookingScreen({super.key, required this.venue});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);
  bool _isLoading = false;
  bool _useCupertino = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null && picked != _endTime) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  void _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final startDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _startTime.hour,
        _startTime.minute,
      );

      final endDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _endTime.hour,
        _endTime.minute,
      );

      final totalPrice = BookingService.calculateTotalPrice(
        widget.venue.pricePerHour,
        startDateTime,
        endDateTime,
      );

      final booking = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        venueId: widget.venue.id,
        customerName: _nameController.text,
        customerEmail: _emailController.text,
        customerPhone: _phoneController.text,
        bookingDate: _selectedDate,
        startTime: startDateTime,
        endTime: endDateTime,
        totalPrice: totalPrice,
        status: 'Confirmed',
      );

      BookingService.addBooking(booking);

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Booking Confirmed!'),
            content: Text(
              'Your booking for ${widget.venue.name} has been confirmed.\n\n'
              'Total: ₱${totalPrice.toStringAsFixed(2)}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.venue.name}'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_useCupertino ? Icons.android : Icons.phone_iphone),
            onPressed: () {
              setState(() {
                _useCupertino = !_useCupertino;
              });
            },
            tooltip: 'Switch to ${_useCupertino ? 'Material' : 'Cupertino'} Design',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Venue Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.venue.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.venue.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Capacity: ${widget.venue.capacity} people',
                            style: const TextStyle(fontSize: 16),
                          ),
                           Text(
                             '₱${widget.venue.pricePerHour.toStringAsFixed(0)}/hour',
                             style: const TextStyle(
                               fontSize: 18,
                               fontWeight: FontWeight.bold,
                               color: Colors.green,
                             ),
                           ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Customer Information
              const Text(
                'Customer Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Booking Details
              const Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Date Selection
              if (_useCupertino)
                _buildCupertinoDatePicker()
              else
                _buildMaterialDatePicker(),
              
              const SizedBox(height: 16),
              
              // Time Selection
              Row(
                children: [
                  Expanded(
                    child: _useCupertino
                        ? _buildCupertinoTimePicker('Start Time', _startTime, _selectStartTime)
                        : _buildMaterialTimePicker('Start Time', _startTime, _selectStartTime),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _useCupertino
                        ? _buildCupertinoTimePicker('End Time', _endTime, _selectEndTime)
                        : _buildMaterialTimePicker('End Time', _endTime, _selectEndTime),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Submit Button
              CustomButton(
                text: 'Book Venue',
                onPressed: _submitBooking,
                isLoading: _isLoading,
                backgroundColor: Colors.blue[600],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialDatePicker() {
    return InkWell(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Booking Date',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
        ),
      ),
    );
  }

  Widget _buildCupertinoDatePicker() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: CupertinoButton(
        onPressed: _selectDate,
        child: Row(
          children: [
            const Icon(CupertinoIcons.calendar),
            const SizedBox(width: 8),
            Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialTimePicker(String label, TimeOfDay time, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.access_time),
        ),
        child: Text(time.format(context)),
      ),
    );
  }

  Widget _buildCupertinoTimePicker(String label, TimeOfDay time, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: CupertinoButton(
        onPressed: onTap,
        child: Row(
          children: [
            const Icon(CupertinoIcons.time),
            const SizedBox(width: 8),
            Text(
              time.format(context),
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
