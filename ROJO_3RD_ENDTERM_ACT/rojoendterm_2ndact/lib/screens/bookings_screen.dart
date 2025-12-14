import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/booking.dart';
import '../services/firestore_service.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController facility = TextEditingController();
  final TextEditingController price = TextEditingController(text: '15');
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String role = 'User';
  final _roles = const ['Admin', 'User'];
  final _service = FirestoreService();

  @override
  void dispose() {
    facility.dispose();
    price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = selectedDate != null
        ? DateFormat.MMMd().format(selectedDate!)
        : 'Choose date';
    final timeLabel = selectedTime != null
        ? selectedTime!.format(context)
        : 'Choose time';
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create a Firestore booking',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: facility,
                    decoration: const InputDecoration(
                      labelText: 'Facility',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Facility required'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: price,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      prefixText: '₱',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || double.tryParse(value) == null
                        ? 'Enter a number'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    key: ValueKey(role),
                    initialValue: role,
                    items: _roles
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => role = value ?? 'User'),
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_today),
                          label: Text(dateLabel),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickTime,
                          icon: const Icon(Icons.access_time),
                          label: Text(timeLabel),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addBooking,
                      icon: const Icon(Icons.add),
                      label: const Text('Save to Firestore'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'My bookings (Firestore stream)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        StreamBuilder<List<Booking>>(
          stream: _service.bookingsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final bookings = snapshot.data ?? [];
            if (bookings.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No Firestore bookings yet. Submit the form above.',
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bookings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.event_available),
                    title: Text('${booking.facility} (${booking.role})'),
                    subtitle: Text(
                      '${DateFormat.yMMMEd().format(booking.date)} at ${booking.time}\nStatus: ${booking.status}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) =>
                              _service.updateBookingStatus(booking.id, value),
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'pending',
                              child: Text('Pending'),
                            ),
                            PopupMenuItem(
                              value: 'confirmed',
                              child: Text('Confirm'),
                            ),
                            PopupMenuItem(
                              value: 'completed',
                              child: Text('Complete'),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _service.deleteBooking(booking.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: selectedDate ?? now,
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  Future<void> _addBooking() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select date & time')));
      return;
    }
    final amount = double.tryParse(price.text.trim()) ?? 0;
    final timeString = selectedTime!.format(context);
    try {
      await _service.addBooking(
        facility: facility.text.trim(),
        price: amount,
        date: selectedDate!,
        time: timeString,
        role: role,
      );
      facility.clear();
      price.text = '15';
      setState(() {
        selectedDate = null;
        selectedTime = null;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }
}
