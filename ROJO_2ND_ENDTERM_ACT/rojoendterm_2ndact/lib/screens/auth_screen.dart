import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Icon(Icons.sports_basketball, size: 80, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 16),
                const Text('Sports Court & Gym Booking', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(isLogin ? 'Sign in to continue' : 'Create your account', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
                const SizedBox(height: 32),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) => v?.isEmpty ?? true ? 'Email required' : null,
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
                  validator: (v) => v?.isEmpty ?? true ? 'Password required' : null,
                ),
                const SizedBox(height: 12),
                if (error != null) Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Row(children: [Icon(Icons.error_outline, color: Colors.red.shade700, size: 20), const SizedBox(width: 8), Expanded(child: Text(error!, style: TextStyle(color: Colors.red.shade700)))]),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: busy ? null : _submit,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: busy ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(isLogin ? 'Sign In' : 'Create Account'),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => isLogin = !isLogin),
                  child: Text(isLogin ? "Don't have an account? Sign up" : "Already have an account? Sign in"),
                ),
                const SizedBox(height: 16),
                Row(children: [Expanded(child: Divider(color: Theme.of(context).dividerColor)), Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('OR', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color))), Expanded(child: Divider(color: Theme.of(context).dividerColor))]),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.login),
                    onPressed: busy ? null : _google,
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    label: const Text('Continue with Google'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { busy = true; error = null; });
    try {
      if (isLogin) {
        await AuthService().loginWithEmail(email.text.trim(), password.text);
      } else {
        await AuthService().registerWithEmail(email.text.trim(), password.text);
      }
    } on FirebaseAuthException catch (e) {
      setState(() { error = e.message; });
    } finally {
      if (mounted) setState(() { busy = false; });
    }
  }

  Future<void> _google() async {
    setState(() { busy = true; error = null; });
    try {
      await AuthService().signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      setState(() { error = e.message; });
    } finally {
      if (mounted) setState(() { busy = false; });
    }
  }
}
