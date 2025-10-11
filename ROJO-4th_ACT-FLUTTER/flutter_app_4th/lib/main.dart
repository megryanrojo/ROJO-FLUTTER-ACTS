import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ROJO E-Learning Platform',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // Named routes for Home, About, and Contact
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const MainNavigationScreen(),
        '/about': (context) => const AboutScreen(),
        '/contact': (context) => const ContactScreen(),
        '/course-details': (context) => const CourseDetailsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/enrollment': (context) => const EnrollmentScreen(),
        '/push-demo': (context) => const PushDemoScreen(),
        '/replacement-demo': (context) => const ReplacementDemoScreen(),
      },
      initialRoute: '/',
    );
  }
}

// Login Screen - Entry point that navigates to home
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      // Using pushReplacement to replace login screen
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Card(
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.school,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'ROJO E-Learning',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty || !value.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          child: const Text('Sign In'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Main Navigation Screen with Drawer and BottomNavigationBar
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ROJO E-Learning'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          HomeTab(),
          CoursesTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 30, color: Colors.indigo),
                ),
                SizedBox(height: 16),
                Text(
                  'Welcome!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'student@rojo.edu',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              _onTabTapped(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('My Courses'),
            onTap: () {
              Navigator.pop(context);
              _onTabTapped(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              _onTabTapped(2);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/about');
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/contact');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}

// Home Tab with TabBar and TabBarView
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
              Tab(icon: Icon(Icons.trending_up), text: 'Progress'),
              Tab(icon: Icon(Icons.calendar_today), text: 'Schedule'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            OverviewTab(),
            ProgressTab(),
            ScheduleTab(),
          ],
        ),
      ),
    );
  }
}

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text('Continue your learning journey'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/enrollment'),
                          icon: const Icon(Icons.add),
                          label: const Text('Enroll in Course'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/push-demo'),
                          icon: const Icon(Icons.explore),
                          label: const Text('Explore'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildActivityItem(context, Icons.book, 'Completed Flutter Basics', '2 hours ago'),
              _buildActivityItem(context, Icons.quiz, 'Quiz: Data Structures', '1 day ago'),
              _buildActivityItem(context, Icons.assignment, 'Submitted Project', '3 days ago'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, IconData icon, String title, String time) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(time),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Learning Progress',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: 0.7,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('70% Complete'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildProgressItem('Flutter Development', 0.9, '90%'),
                _buildProgressItem('Data Structures', 0.6, '60%'),
                _buildProgressItem('Algorithms', 0.3, '30%'),
                _buildProgressItem('UI/UX Design', 0.8, '80%'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String title, double progress, String percentage) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: LinearProgressIndicator(value: progress),
        trailing: Text(percentage),
      ),
    );
  }
}

class ScheduleTab extends StatelessWidget {
  const ScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Schedule',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildScheduleItem('Flutter Workshop', '10:00 AM - 12:00 PM', Colors.blue),
                  _buildScheduleItem('Code Review', '2:00 PM - 3:00 PM', Colors.green),
                  _buildScheduleItem('Project Discussion', '4:00 PM - 5:00 PM', Colors.orange),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String title, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(time, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Courses Tab
class CoursesTab extends StatelessWidget {
  const CoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Courses',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildCourseCard(
                  context,
                  'Flutter Development',
                  'Learn cross-platform mobile development',
                  '85% Complete',
                  0.85,
                  Icons.phone_android,
                ),
                _buildCourseCard(
                  context,
                  'Data Structures',
                  'Master fundamental computer science concepts',
                  '60% Complete',
                  0.60,
                  Icons.account_tree,
                ),
                _buildCourseCard(
                  context,
                  'UI/UX Design',
                  'Create beautiful and intuitive interfaces',
                  '40% Complete',
                  0.40,
                  Icons.design_services,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, String title, String description, String progress, double progressValue, IconData icon) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/course-details'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: Theme.of(context).textTheme.titleMedium),
                        Text(description, style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: progressValue),
              const SizedBox(height: 8),
              Text(progress, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

// Profile Tab
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Meg Ryan Rojo',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    'student@rojo.edu',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Courses', '12'),
                      _buildStatItem('Completed', '8'),
                      _buildStatItem('Certificates', '3'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Profile'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => Navigator.pushNamed(context, '/contact'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// Named Route Screens
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About ROJO E-Learning',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'ROJO E-Learning is a comprehensive online learning platform designed to provide high-quality education in technology and computer science.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Features:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Interactive courses'),
            Text('• Progress tracking'),
            Text('• Expert instructors'),
            Text('• Flexible scheduling'),
            Text('• Certificates of completion'),
          ],
        ),
      ),
    );
  }
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.email, size: 48),
                    SizedBox(height: 8),
                    Text('Email: support@rojo.edu'),
                    Text('Phone: +1 (555) 123-4567'),
                    Text('Address: 123 Learning St, Education City'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message sent!')),
                );
              },
              icon: const Icon(Icons.send),
              label: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}

// Additional screens for navigation demonstrations
class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Details')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Flutter Development Course', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Learn to build beautiful cross-platform mobile applications using Flutter.'),
            SizedBox(height: 16),
            Text('Duration: 8 weeks'),
            Text('Level: Intermediate'),
            Text('Instructor: Dr. Smith'),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            SizedBox(height: 16),
            Text('John Doe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('student@rojo.edu'),
            SizedBox(height: 16),
            Text('Edit your profile information here.'),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(title: Text('Notifications'), trailing: Switch(value: true, onChanged: null)),
            ListTile(title: Text('Dark Mode'), trailing: Switch(value: false, onChanged: null)),
            ListTile(title: Text('Language'), trailing: Text('English')),
            ListTile(title: Text('Privacy'), trailing: Icon(Icons.arrow_forward_ios)),
          ],
        ),
      ),
    );
  }
}

class EnrollmentScreen extends StatelessWidget {
  const EnrollmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enroll in Course')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Available Courses:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Card(child: ListTile(title: Text('Flutter Development'), subtitle: Text('8 weeks'), trailing: Text('Enroll'))),
            Card(child: ListTile(title: Text('Data Structures'), subtitle: Text('6 weeks'), trailing: Text('Enroll'))),
            Card(child: ListTile(title: Text('UI/UX Design'), subtitle: Text('4 weeks'), trailing: Text('Enroll'))),
          ],
        ),
      ),
    );
  }
}

// Push vs PushReplacement Demo
class PushDemoScreen extends StatelessWidget {
  const PushDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Push Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('This screen was pushed using Navigator.push()'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/replacement-demo'),
              child: const Text('Push Another Screen'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class ReplacementDemoScreen extends StatelessWidget {
  const ReplacementDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Replacement Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('This screen was pushed using Navigator.pushReplacement()'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              child: const Text('Replace with Home'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}