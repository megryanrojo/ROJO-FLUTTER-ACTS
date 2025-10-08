import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Learning Enrollment & Payment',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const HomeScreen(),
      routes: {
        UsernameFormScreen.routeName: (_) => const UsernameFormScreen(),
        LoginFormScreen.routeName: (_) => const LoginFormScreen(),
        MixedInputsScreen.routeName: (_) => const MixedInputsScreen(),
        RegistrationFormScreen.routeName: (_) => const RegistrationFormScreen(),
        DateTimePickerScreen.routeName: (_) => const DateTimePickerScreen(),
        ControllerCaptureScreen.routeName: (_) => const ControllerCaptureScreen(),
        LocalListFormScreen.routeName: (_) => const LocalListFormScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ROJO E-Learning'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App header
            Text(
              'Welcome to ROJO E-Learning',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Enroll in classes, manage your profile, and record payments.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // Quick actions grid
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 3.2,
                      ),
                      children: [
                        _QuickAction(
                          icon: Icons.login,
                          label: 'Login',
                          onTap: () => Navigator.pushNamed(context, LoginFormScreen.routeName),
                        ),
                        _QuickAction(
                          icon: Icons.app_registration,
                          label: 'Register',
                          onTap: () => Navigator.pushNamed(context, RegistrationFormScreen.routeName),
                        ),
                        _QuickAction(
                          icon: Icons.school,
                          label: 'Enroll in Class',
                          onTap: () => Navigator.pushNamed(context, LocalListFormScreen.routeName),
                        ),
                        _QuickAction(
                          icon: Icons.schedule,
                          label: 'Schedule',
                          onTap: () => Navigator.pushNamed(context, DateTimePickerScreen.routeName),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Featured courses section
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, size: 20),
                        const SizedBox(width: 8),
                        Text('Featured Courses', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      leading: const Icon(Icons.book_outlined),
                      title: const Text('Flutter for Beginners'),
                      subtitle: const Text('Build beautiful cross‑platform apps'),
                      trailing: TextButton(
                        onPressed: () => Navigator.pushNamed(context, LocalListFormScreen.routeName),
                        child: const Text('Enroll'),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.book_outlined),
                      title: const Text('Data Structures'),
                      subtitle: const Text('Foundations for technical interviews'),
                      trailing: TextButton(
                        onPressed: () => Navigator.pushNamed(context, LocalListFormScreen.routeName),
                        child: const Text('Enroll'),
                      ),
                    ),
                    const Divider(height: 1),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, LocalListFormScreen.routeName),
                        icon: const Icon(Icons.shopping_cart_checkout, size: 18),
                        label: const Text('Go to Enrollment & Payments'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Profile & settings section
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Profile: Username'),
                    subtitle: const Text('Update your learner ID'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.pushNamed(context, UsernameFormScreen.routeName),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.tune),
                    title: const Text('Preferences'),
                    subtitle: const Text('Notes, terms agreement, notifications'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.pushNamed(context, MixedInputsScreen.routeName),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.key),
                    title: const Text('Join via Course Code'),
                    subtitle: const Text('Enter and capture a course code'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.pushNamed(context, ControllerCaptureScreen.routeName),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class _GuidelineItem extends StatelessWidget {
  const _GuidelineItem({required this.index, required this.text, required this.onTap});
  final int index;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 12,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text('$index', style: const TextStyle(fontSize: 12)),
      ),
      title: Text(text),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.title, required this.routeName});
  final String title;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => Navigator.pushNamed(context, routeName),
    );
  }
}

// 1) Username simple form
class UsernameFormScreen extends StatefulWidget {
  const UsernameFormScreen({super.key});
  static const routeName = '/username-form';

  @override
  State<UsernameFormScreen> createState() => _UsernameFormScreenState();
}

class _UsernameFormScreenState extends State<UsernameFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Username Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username (Learner ID)',
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Saved username: ${_usernameController.text}')),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2-4) Login with validation and GlobalKey
class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});
  static const routeName = '/login';

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logging in as ${_emailController.text}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learner Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Enter a valid email containing @';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _submit, child: const Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}

// 5) Mixed inputs: TextField, Checkbox, Switch
class MixedInputsScreen extends StatefulWidget {
  const MixedInputsScreen({super.key});
  static const routeName = '/mixed-inputs';

  @override
  State<MixedInputsScreen> createState() => _MixedInputsScreenState();
}

class _MixedInputsScreenState extends State<MixedInputsScreen> {
  final _noteController = TextEditingController();
  bool _agreeTerms = false;
  bool _notifications = true;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Preferences')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Notes for instructor',
              ),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: _agreeTerms,
              onChanged: (v) => setState(() => _agreeTerms = v ?? false),
              title: const Text('I agree to enrollment terms'),
            ),
            SwitchListTile(
              value: _notifications,
              onChanged: (v) => setState(() => _notifications = v),
              title: const Text('Enable course notifications'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Saved: note="${_noteController.text}", terms=$_agreeTerms, notify=$_notifications',
                    ),
                  ),
                );
              },
              child: const Text('Save Preferences'),
            )
          ],
        ),
      ),
    );
  }
}

// 6-7) Registration with dropdown role
class RegistrationFormScreen extends StatefulWidget {
  const RegistrationFormScreen({super.key});
  static const routeName = '/registration';

  @override
  State<RegistrationFormScreen> createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _role = 'Learner';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => (v == null || !v.contains('@')) ? 'Enter valid email' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (v) => (v != _passwordController.text) ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _role,
                items: const [
                  DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'Learner', child: Text('Learner')),
                  DropdownMenuItem(value: 'Instructor', child: Text('Instructor')),
                ],
                onChanged: (v) => setState(() => _role = v ?? 'Learner'),
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Registered $_role: ${_nameController.text}')),
                    );
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 8) Date & Time picker
class DateTimePickerScreen extends StatefulWidget {
  const DateTimePickerScreen({super.key});
  static const routeName = '/date-time';

  @override
  State<DateTimePickerScreen> createState() => _DateTimePickerScreenState();
}

class _DateTimePickerScreenState extends State<DateTimePickerScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      initialDate: now,
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Class')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(_selectedDate == null
                      ? 'No date selected'
                      : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
                ),
                ElevatedButton(onPressed: _pickDate, child: const Text('Pick Date')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(_selectedTime == null
                      ? 'No time selected'
                      : 'Time: ${_selectedTime!.format(context)}'),
                ),
                ElevatedButton(onPressed: _pickTime, child: const Text('Pick Time')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 9) Controller capture & display
class ControllerCaptureScreen extends StatefulWidget {
  const ControllerCaptureScreen({super.key});
  static const routeName = '/controller-capture';

  @override
  State<ControllerCaptureScreen> createState() => _ControllerCaptureScreenState();
}

class _ControllerCaptureScreenState extends State<ControllerCaptureScreen> {
  final _controller = TextEditingController();
  String _captured = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture Text')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter course code'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => setState(() => _captured = _controller.text),
              child: const Text('Capture'),
            ),
            const SizedBox(height: 12),
            Text('Captured: $_captured'),
          ],
        ),
      ),
    );
  }
}

// 10) Form saves to local list and displays submissions
class LocalListFormScreen extends StatefulWidget {
  const LocalListFormScreen({super.key});
  static const routeName = '/local-list';

  @override
  State<LocalListFormScreen> createState() => _LocalListFormScreenState();
}

class _LocalListFormScreenState extends State<LocalListFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _courseController = TextEditingController();
  final _amountController = TextEditingController();
  final List<Map<String, String>> _submissions = [];

  @override
  void dispose() {
    _courseController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _add() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _submissions.add({
          'course': _courseController.text,
          'amount': _amountController.text,
        });
        _courseController.clear();
        _amountController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enroll & Record Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _courseController,
                    decoration: const InputDecoration(labelText: 'Course Name'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(labelText: 'Payment Amount'),
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _add, child: const Text('Add Record')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _submissions.isEmpty
                  ? const Center(child: Text('No records yet'))
                  : ListView.separated(
                      itemCount: _submissions.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = _submissions[index];
                        return ListTile(
                          title: Text(item['course'] ?? ''),
                          subtitle: Text('Amount: ${item['amount'] ?? ''}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
