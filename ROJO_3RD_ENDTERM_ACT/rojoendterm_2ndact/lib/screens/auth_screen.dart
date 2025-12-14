import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  bool busy = false;
  String? error;
  final List<String> roles = const ['Admin', 'User'];
  String role = 'User';
  DateTime? availabilityDate;
  TimeOfDay? availabilityTime;

  @override
  Widget build(BuildContext context) {
    final dateLabel = availabilityDate != null
        ? DateFormat.yMMMMd().format(availabilityDate!)
        : 'Preferred date';
    final timeLabel = availabilityTime != null
        ? availabilityTime!.format(context)
        : 'Preferred time';
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Icon(
                  Icons.sports_basketball,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sports Court & Gym Booking',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  isLogin ? 'Sign in to continue' : 'Create your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) =>
                      v?.isEmpty ?? true ? 'Email required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (v) =>
                      v == null || v.length < 6 ? 'Min 6 characters' : null,
                ),
                if (!isLogin) ...[
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    key: ValueKey(role),
                    initialValue: role,
                    decoration: const InputDecoration(
                      labelText: 'Select role',
                      border: OutlineInputBorder(),
                    ),
                    items: roles
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => role = value ?? 'User'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_month_outlined),
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
                  const SizedBox(height: 4),
                  Text(
                    'Capture preferred schedule during onboarding',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 12),
                if (error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            error!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isLogin)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: busy ? null : _forgotPassword,
                      child: const Text('Forgot password?'),
                    ),
                  ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: busy ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: busy
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isLogin ? 'Sign In' : 'Create Account'),
                ),
                TextButton(
                  onPressed: () => setState(() => isLogin = !isLogin),
                  child: Text(
                    isLogin
                        ? "Don't have an account? Sign up"
                        : "Already have an account? Sign in",
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Theme.of(context).dividerColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Theme.of(context).dividerColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.login),
                  onPressed: busy ? null : _google,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  label: const Text('Continue with Google'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: availabilityDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => availabilityDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: availabilityTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => availabilityTime = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!isLogin && (availabilityDate == null || availabilityTime == null)) {
      setState(() => error = 'Please choose a date & time');
      return;
    }
    setState(() {
      busy = true;
      error = null;
    });
    final auth = AuthService();
    final String? formattedTime = availabilityTime != null
        ? availabilityTime!.format(context)
        : null;
    try {
      if (isLogin) {
        await auth.loginWithEmail(email.text.trim(), password.text);
      } else {
        await auth.registerWithEmail(email.text.trim(), password.text);
        await auth.saveRoleAndAvailability(
          role: role,
          date: availabilityDate,
          time: formattedTime,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _google() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await AuthService().signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _forgotPassword() async {
    final targetEmail = email.text.trim();
    if (targetEmail.isEmpty) {
      setState(() => error = 'Enter your email to reset your password');
      return;
    }
    setState(() => busy = true);
    try {
      await AuthService().sendPasswordReset(targetEmail);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset sent'),
          duration: Duration(seconds: 2),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }
}
