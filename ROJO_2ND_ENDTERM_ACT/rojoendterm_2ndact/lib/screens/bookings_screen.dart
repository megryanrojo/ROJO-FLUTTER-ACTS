import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<AppState>().bookings;
    if (bookings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.event_note, size: 72),
              SizedBox(height: 12),
              Text('No bookings yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Your reserved courts and gym passes will appear here.'),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final b = bookings[i];
        return ListTile(
          leading: const Icon(Icons.event_available),
          title: Text(b.title),
          subtitle: Text('₱${b.price.toStringAsFixed(2)} • ${b.createdAt}'),
          trailing: IconButton(
            icon: const Icon(Icons.cancel_outlined),
            onPressed: () => context.read<AppState>().cancel(b.id),
          ),
        );
      },
    );
  }
}


