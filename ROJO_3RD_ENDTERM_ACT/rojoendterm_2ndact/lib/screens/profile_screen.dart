import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cart_item.dart';
import '../models/performance_report.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/performance_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = AuthService();
  final _firestore = FirestoreService();
  final _performance = PerformanceService();
  PerformanceReport? _report;
  bool _checking = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? Icon(
                          Icons.person,
                          size: 50,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  user?.displayName ??
                      user?.email?.split('@').first ??
                      'Guest User',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (user?.email != null)
                  Text(
                    user!.email!,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        StreamBuilder<Map<String, dynamic>?>(
          stream: _firestore.userProfileStream(),
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (data == null) {
              return const SizedBox.shrink();
            }
            return Card(
              child: ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: Text('Role: ${data['role'] ?? 'Not set'}'),
                subtitle: Text(
                  'Availability: ${data['availabilityDate'] ?? '—'} ${data['availabilityTime'] ?? ''}',
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Text(
          'Cart (Firestore realtime)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        StreamBuilder<List<CartItem>>(
          stream: _firestore.cartStream(),
          builder: (context, snapshot) {
            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('No items in cart yet'),
              );
            }
            return Column(
              children: items
                  .map(
                    (item) => ListTile(
                      leading: const Icon(Icons.shopping_cart_outlined),
                      title: Text(item.title),
                      subtitle: Text(
                        'x${item.quantity} • ₱${item.price.toStringAsFixed(2)}',
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Realtime DB vs Firestore',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Realtime DB pushes low-latency updates ideal for chat/inventory, while Firestore offers structured queries with offline caching suited for bookings & carts.',
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _checking ? null : _runComparison,
                  icon: const Icon(Icons.speed),
                  label: Text(
                    _checking ? 'Measuring…' : 'Measure large dataset read',
                  ),
                ),
                if (_report != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Realtime: ${_report!.realtimeCount} rows in ${_report!.realtimeDuration.inMilliseconds} ms\nFirestore: ${_report!.firestoreCount} rows in ${_report!.firestoreDuration.inMilliseconds} ms',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text('Generated at ${_report!.generatedAt}'),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: const [
              ListTile(
                leading: Icon(Icons.flash_on),
                title: Text('Realtime Database'),
                subtitle: Text(
                  'Best for live chat, counters, and quick inventory updates. Data is hierarchical and streams instantly to the UI.',
                ),
              ),
              Divider(height: 0),
              ListTile(
                leading: Icon(Icons.storage),
                title: Text('Cloud Firestore'),
                subtitle: Text(
                  'Ideal for analytics-friendly queries, relational-style data such as bookings, carts, and audit trails.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () => _auth.logout(),
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ],
    );
  }

  Future<void> _runComparison() async {
    setState(() => _checking = true);
    try {
      final report = await _performance.measure();
      setState(() => _report = report);
    } finally {
      setState(() => _checking = false);
    }
  }
}
