import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final auth = AuthService();
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
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                  child: user?.photoURL == null ? Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.primary) : null,
                ),
                const SizedBox(height: 16),
                Text(user?.displayName ?? user?.email?.split('@').first ?? 'Guest User', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                if (user?.email != null) ...[
                  const SizedBox(height: 4),
                  Text(user!.email!, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
        const ListTile(leading: Icon(Icons.privacy_tip_outlined), title: Text('Privacy')),
        const ListTile(leading: Icon(Icons.help_outline), title: Text('Help & Support')),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () => auth.logout(),
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ],
    );
  }
}
