import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Shop App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final int _cartItemCount = 0;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const AllProductsPage(),
    const CoffeeGuidePage(),
    const ShoppingListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('☕ Coffee Shop'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
              ),
              if (_cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.brown.shade800,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.brown.shade300,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Guide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Quick Access',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildQuickAccessItem(
                    context,
                    'Gallery',
                    Icons.image,
                    () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const GalleryPage()));
                    },
                  ),
                  _buildQuickAccessItem(
                    context,
                    'Product Selector',
                    Icons.view_carousel,
                    () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductSelectorPage()));
                    },
                  ),
                  _buildQuickAccessItem(
                    context,
                    'Our Team',
                    Icons.contacts,
                    () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TeamPage()));
                    },
                  ),
                ],
              ),
            ),
          );
        },
        icon: const Icon(Icons.more_horiz),
        label: const Text('More'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildQuickAccessItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.brown),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

}

// Home Page - Main landing page with categories
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF8B4513), Color(0xFFD2691E)],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeroSection(context),
          ),
          SliverToBoxAdapter(
            child: _buildQuickActions(context),
          ),
          SliverToBoxAdapter(
            child: _buildFeaturedProducts(context),
          ),
          SliverToBoxAdapter(
            child: _buildCategories(context),
          ),
          SliverToBoxAdapter(
            child: _buildPromotions(context),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.local_cafe,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome to Coffee Shop',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Discover premium coffee, expertly crafted drinks, and everything you need for the perfect cup',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard('Drinks', '25+', Icons.local_cafe),
                    _buildStatCard('Equipment', '50+', Icons.devices),
                    _buildStatCard('Beans', '15+', Icons.local_grocery_store),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context,
                  'Coffee Menu',
                  Icons.local_cafe,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CoffeeMenuPage()),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  context,
                  'Equipment',
                  Icons.devices,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EquipmentStorePage()),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context,
                  'Coffee Beans',
                  Icons.local_grocery_store,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CoffeeBeansPage()),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  context,
                  'Coffee Gallery',
                  Icons.image,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GalleryPage()),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedProducts(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text(
            'Featured Products',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFeaturedProductCard(context, 'Espresso', '\$2.99', Icons.local_cafe, 'Rich & Bold'),
                _buildFeaturedProductCard(context, 'Cappuccino', '\$4.99', Icons.local_cafe, 'Creamy & Smooth'),
                _buildFeaturedProductCard(context, 'Latte', '\$5.49', Icons.local_cafe, 'Perfect Balance'),
                _buildFeaturedProductCard(context, 'Mocha', '\$5.99', Icons.local_cafe, 'Chocolate Bliss'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildCategoryCard(context, 'Hot Drinks', Icons.whatshot, () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CoffeeMenuPage()),
              )),
              _buildCategoryCard(context, 'Cold Drinks', Icons.ac_unit, () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CoffeeMenuPage()),
              )),
              _buildCategoryCard(context, 'Equipment', Icons.devices, () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EquipmentStorePage()),
              )),
              _buildCategoryCard(context, 'Coffee Beans', Icons.local_grocery_store, () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CoffeeBeansPage()),
              )),
              _buildCategoryCard(context, 'Gallery', Icons.image, () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GalleryPage()),
              )),
              _buildCategoryCard(context, 'Product Selector', Icons.view_carousel, () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductSelectorPage()),
              )),
              _buildCategoryCard(context, 'Our Team', Icons.contacts, () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TeamPage()),
              )),
              _buildCategoryCard(context, 'Shopping List', Icons.shopping_cart, () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShoppingListPage()),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromotions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text(
            'Special Offers',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_offer,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '20% Off All Coffee Beans',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Premium quality beans at unbeatable prices',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CoffeeBeansPage()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF8B4513),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Shop Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(icon, color: Colors.white, size: 32),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedProductCard(BuildContext context, String name, String price, IconData icon, String description) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 40),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 36),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Fashion Store Page - SingleChildScrollView with interactive features
class CoffeeMenuPage extends StatefulWidget {
  const CoffeeMenuPage({super.key});

  @override
  State<CoffeeMenuPage> createState() => _CoffeeMenuPageState();
}

class _CoffeeMenuPageState extends State<CoffeeMenuPage> {
  final List<Map<String, dynamic>> _cart = [];
  String _selectedSize = 'Medium';
  String _selectedTemperature = 'Hot';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('☕ Coffee Menu'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => _showCart(),
              ),
              if (_cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${_cart.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildSizeSelector(),
            const SizedBox(height: 16),
            _buildTemperatureSelector(),
            const SizedBox(height: 20),
            const Text(
              'Our Signature Drinks',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildCoffeeItem('Espresso', 'Rich, bold, and intense', '\$2.99', Icons.local_cafe, 'Classic'),
            _buildCoffeeItem('Americano', 'Espresso with hot water', '\$3.49', Icons.local_cafe, 'Classic'),
            _buildCoffeeItem('Cappuccino', 'Espresso with steamed milk foam', '\$4.99', Icons.local_cafe, 'Milk'),
            _buildCoffeeItem('Latte', 'Smooth espresso with steamed milk', '\$5.49', Icons.local_cafe, 'Milk'),
            _buildCoffeeItem('Mocha', 'Chocolate and espresso blend', '\$5.99', Icons.local_cafe, 'Chocolate'),
            _buildCoffeeItem('Macchiato', 'Espresso with dollop of foam', '\$4.49', Icons.local_cafe, 'Classic'),
            _buildCoffeeItem('Frappuccino', 'Blended ice coffee drink', '\$6.99', Icons.local_cafe, 'Cold'),
            _buildCoffeeItem('Cold Brew', 'Smooth cold-steeped coffee', '\$4.99', Icons.local_cafe, 'Cold'),
            _buildCoffeeItem('Iced Coffee', 'Refreshing chilled coffee', '\$3.99', Icons.local_cafe, 'Cold'),
            _buildCoffeeItem('Affogato', 'Espresso over vanilla ice cream', '\$6.49', Icons.local_cafe, 'Dessert'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.brown.shade100, Colors.brown.shade50],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_cafe, size: 50, color: Colors.brown),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Coffee Shop Menu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Premium coffee and specialty drinks',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Size:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: ['XS', 'S', 'M', 'L', 'XL'].map((size) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(size),
                selected: _selectedSize == size,
                onSelected: (selected) {
                  setState(() {
                    _selectedSize = size;
                  });
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTemperatureSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Temperature:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            {'name': 'Hot', 'icon': Icons.whatshot},
            {'name': 'Iced', 'icon': Icons.ac_unit},
            {'name': 'Blended', 'icon': Icons.blender},
          ].map((tempData) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tempData['icon'] as IconData,
                      size: 16,
                      color: _selectedTemperature == tempData['name'] ? Colors.brown : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(tempData['name'] as String),
                  ],
                ),
                selected: _selectedTemperature == tempData['name'],
                onSelected: (selected) {
                  setState(() {
                    _selectedTemperature = tempData['name'] as String;
                  });
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCoffeeItem(String name, String description, String price, IconData icon, String category) {
    // Get appropriate image URL based on category
    String imageUrl = 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=300&h=200&fit=crop';
    if (category == 'Cold') {
      imageUrl = 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=300&h=200&fit=crop';
    } else if (category == 'Chocolate') {
      imageUrl = 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=300&h=200&fit=crop';
    } else if (category == 'Dessert') {
      imageUrl = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=200&fit=crop';
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.brown.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, size: 35, color: Colors.brown),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.brown.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.brown, strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.brown.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        price,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => _addToCart(name, price, category),
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(String name, String price, String category) {
    setState(() {
      _cart.add({
        'name': name,
        'price': price,
        'category': category,
        'size': _selectedSize,
        'temperature': _selectedTemperature,
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name added to cart!'),
        backgroundColor: Colors.brown,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: _showCart,
        ),
      ),
    );
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Your Coffee Order',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_cart.isEmpty)
              const Text('Your cart is empty')
            else
              ..._cart.map((item) => ListTile(
                leading: const Icon(Icons.local_cafe),
                title: Text(item['name']),
                subtitle: Text('${item['size']} - ${item['temperature']}'),
                trailing: Text(item['price']),
              )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order placed successfully!')),
                );
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}

// Equipment Store Page - ListView with interactive features
class EquipmentStorePage extends StatefulWidget {
  const EquipmentStorePage({super.key});

  @override
  State<EquipmentStorePage> createState() => _EquipmentStorePageState();
}

class _EquipmentStorePageState extends State<EquipmentStorePage> {
  final List<Map<String, dynamic>> _cart = [];
  String _selectedCategory = 'All';
  String _sortBy = 'Name';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ Equipment Store'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => _showCart(),
              ),
              if (_cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${_cart.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: ListView.builder(
              itemCount: _getFilteredItems().length,
              itemBuilder: (context, index) {
                return _buildCoffeeBeanItem(_getFilteredItems()[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Category:', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                      items: ['All', 'Grinders', 'Machines', 'Accessories', 'Tools'].map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sort by:', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: _sortBy,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          _sortBy = newValue!;
                        });
                      },
                      items: ['Name', 'Price', 'Rating'].map((String sort) {
                        return DropdownMenuItem<String>(
                          value: sort,
                          child: Text(sort),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredItems() {
    List<Map<String, dynamic>> items = [
      {'name': 'Coffee Grinder Pro', 'price': 89.99, 'icon': Icons.blender, 'category': 'Grinders', 'rating': 4.8, 'description': 'Professional burr grinder for perfect grind consistency', 'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=200&fit=crop'},
      {'name': 'Espresso Machine Deluxe', 'price': 299.99, 'icon': Icons.local_cafe, 'category': 'Machines', 'rating': 4.9, 'description': 'Commercial-grade espresso machine with steam wand', 'imageUrl': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=300&h=200&fit=crop'},
      {'name': 'Digital Coffee Scale', 'price': 45.99, 'icon': Icons.scale, 'category': 'Accessories', 'rating': 4.7, 'description': 'Precision scale with timer for perfect brewing', 'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=200&fit=crop'},
      {'name': 'Milk Frother Pro', 'price': 29.99, 'icon': Icons.water_drop, 'category': 'Accessories', 'rating': 4.6, 'description': 'Automatic milk frother for perfect microfoam', 'imageUrl': 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=300&h=200&fit=crop'},
      {'name': 'Coffee Timer Pro', 'price': 19.99, 'icon': Icons.timer, 'category': 'Tools', 'rating': 4.5, 'description': 'Digital timer with multiple brewing presets', 'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=200&fit=crop'},
      {'name': 'Portafilter Set', 'price': 34.99, 'icon': Icons.filter_alt, 'category': 'Accessories', 'rating': 4.7, 'description': 'Professional portafilter with multiple baskets', 'imageUrl': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=300&h=200&fit=crop'},
      {'name': 'Coffee Tamper', 'price': 24.99, 'icon': Icons.compress, 'category': 'Tools', 'rating': 4.6, 'description': 'Stainless steel tamper for consistent tamping', 'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=200&fit=crop'},
      {'name': 'Ceramic Coffee Cups Set', 'price': 39.99, 'icon': Icons.local_drink, 'category': 'Accessories', 'rating': 4.8, 'description': 'Set of 6 ceramic cups for espresso', 'imageUrl': 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=300&h=200&fit=crop'},
      {'name': 'Coffee Filter Papers', 'price': 12.99, 'icon': Icons.filter_list, 'category': 'Accessories', 'rating': 4.4, 'description': 'Premium filter papers for pour-over brewing', 'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=200&fit=crop'},
      {'name': 'Coffee Thermometer', 'price': 15.99, 'icon': Icons.thermostat, 'category': 'Tools', 'rating': 4.5, 'description': 'Digital thermometer for precise temperature control', 'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=200&fit=crop'},
      {'name': 'Coffee Spoon Set', 'price': 18.99, 'icon': Icons.restaurant, 'category': 'Tools', 'rating': 4.6, 'description': 'Stainless steel measuring spoons', 'imageUrl': 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=300&h=200&fit=crop'},
      {'name': 'Coffee Storage Jar', 'price': 22.99, 'icon': Icons.inventory, 'category': 'Accessories', 'rating': 4.7, 'description': 'Airtight storage jar to keep beans fresh', 'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=200&fit=crop'},
      {'name': 'Coffee Grinder Brush', 'price': 8.99, 'icon': Icons.brush, 'category': 'Tools', 'rating': 4.3, 'description': 'Cleaning brush for grinder maintenance', 'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=200&fit=crop'},
      {'name': 'Coffee Measuring Scoop', 'price': 6.99, 'icon': Icons.science, 'category': 'Tools', 'rating': 4.4, 'description': 'Precision measuring scoop for coffee grounds', 'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=200&fit=crop'},
      {'name': 'Coffee Cleaning Tablets', 'price': 14.99, 'icon': Icons.cleaning_services, 'category': 'Accessories', 'rating': 4.5, 'description': 'Descaling tablets for machine maintenance', 'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=200&fit=crop'},
    ];

    // Filter by category
    if (_selectedCategory != 'All') {
      items = items.where((item) => item['category'] == _selectedCategory).toList();
    }

    // Sort items
    items.sort((a, b) {
      switch (_sortBy) {
        case 'Price':
          return (a['price'] as double).compareTo(b['price'] as double);
        case 'Rating':
          return (b['rating'] as double).compareTo(a['rating'] as double);
        default:
          return (a['name'] as String).compareTo(b['name'] as String);
      }
    });

    return items;
  }

  Widget _buildCoffeeBeanItem(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['imageUrl'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.brown.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item['icon'] as IconData, size: 40, color: Colors.brown),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.brown.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.brown, strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] as String,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['description'] as String,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.brown.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item['category'] as String,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(' ${item['rating']}'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${item['price']}',
                    style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _addToCart(item),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () => _addToFavorites(item),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      _cart.add(item);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} added to cart!'),
        backgroundColor: Colors.brown,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: _showCart,
        ),
      ),
    );
  }

  void _addToFavorites(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} added to favorites!'),
        backgroundColor: Colors.brown,
      ),
    );
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Shopping Cart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_cart.isEmpty)
              const Text('Your cart is empty')
            else
              ..._cart.map((item) => ListTile(
                leading: Icon(item['icon']),
                title: Text(item['name']),
                subtitle: Text(item['category']),
                trailing: Text('\$${item['price']}'),
              )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order placed successfully!')),
                );
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}

// Coffee Beans Page - GridView with shopping cart functionality
class CoffeeBeansPage extends StatefulWidget {
  const CoffeeBeansPage({super.key});

  @override
  State<CoffeeBeansPage> createState() => _CoffeeBeansPageState();
}

class _CoffeeBeansPageState extends State<CoffeeBeansPage> {
  final List<Map<String, dynamic>> _cart = [];
  String _selectedFilter = 'All';
  String _sortBy = 'Name';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('☕ Coffee Beans'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => _showCart(),
              ),
              if (_cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${_cart.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _getFilteredItems().length,
              itemBuilder: (context, index) {
                return _buildCoffeeBeanItem(_getFilteredItems()[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filter:', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: _selectedFilter,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilter = newValue!;
                    });
                  },
                  items: ['All', 'Light Roast', 'Medium Roast', 'Dark Roast', 'Espresso'].map((String filter) {
                    return DropdownMenuItem<String>(
                      value: filter,
                      child: Text(filter),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sort by:', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: _sortBy,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _sortBy = newValue!;
                    });
                  },
                  items: ['Name', 'Price', 'Rating'].map((String sort) {
                    return DropdownMenuItem<String>(
                      value: sort,
                      child: Text(sort),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredItems() {
    List<Map<String, dynamic>> items = [
      {'name': 'Arabica Beans', 'price': 12.99, 'icon': Icons.coffee, 'roast': 'Medium Roast', 'rating': 4.8, 'origin': 'Colombia', 'description': 'Smooth and balanced', 'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=200&fit=crop'},
      {'name': 'Robusta Beans', 'price': 10.99, 'icon': Icons.coffee, 'roast': 'Dark Roast', 'rating': 4.6, 'origin': 'Vietnam', 'description': 'Strong and bold', 'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=200&fit=crop'},
      {'name': 'Espresso Blend', 'price': 14.99, 'icon': Icons.local_cafe, 'roast': 'Espresso', 'rating': 4.9, 'origin': 'Italy', 'description': 'Perfect for espresso', 'imageUrl': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=300&h=200&fit=crop'},
      {'name': 'Decaf Coffee', 'price': 11.99, 'icon': Icons.coffee_maker, 'roast': 'Medium Roast', 'rating': 4.5, 'origin': 'Brazil', 'description': 'Caffeine-free option', 'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=200&fit=crop'},
      {'name': 'French Roast', 'price': 13.99, 'icon': Icons.local_fire_department, 'roast': 'Dark Roast', 'rating': 4.7, 'origin': 'France', 'description': 'Rich and smoky', 'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=200&fit=crop'},
      {'name': 'Light Roast', 'price': 9.99, 'icon': Icons.wb_sunny, 'roast': 'Light Roast', 'rating': 4.6, 'origin': 'Ethiopia', 'description': 'Bright and fruity', 'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=200&fit=crop'},
      {'name': 'Medium Roast', 'price': 10.99, 'icon': Icons.wb_sunny_outlined, 'roast': 'Medium Roast', 'rating': 4.7, 'origin': 'Guatemala', 'description': 'Well-balanced flavor', 'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=200&fit=crop'},
      {'name': 'Dark Roast', 'price': 11.99, 'icon': Icons.dark_mode, 'roast': 'Dark Roast', 'rating': 4.8, 'origin': 'Sumatra', 'description': 'Full-bodied and rich', 'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300&h=200&fit=crop'},
      {'name': 'Colombian Coffee', 'price': 15.99, 'icon': Icons.public, 'roast': 'Medium Roast', 'rating': 4.9, 'origin': 'Colombia', 'description': 'Premium Colombian beans', 'imageUrl': 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=300&h=200&fit=crop'},
      {'name': 'Ethiopian Coffee', 'price': 16.99, 'icon': Icons.public, 'roast': 'Light Roast', 'rating': 4.8, 'origin': 'Ethiopia', 'description': 'Complex and floral', 'imageUrl': 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=300&h=200&fit=crop'},
      {'name': 'Brazilian Coffee', 'price': 13.99, 'icon': Icons.public, 'roast': 'Medium Roast', 'rating': 4.7, 'origin': 'Brazil', 'description': 'Nutty and chocolatey', 'imageUrl': 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=300&h=200&fit=crop'},
      {'name': 'Jamaican Blue Mountain', 'price': 24.99, 'icon': Icons.landscape, 'roast': 'Medium Roast', 'rating': 4.9, 'origin': 'Jamaica', 'description': 'Premium luxury coffee', 'imageUrl': 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=300&h=200&fit=crop'},
      {'name': 'Kona Coffee', 'price': 22.99, 'icon': Icons.beach_access, 'roast': 'Medium Roast', 'rating': 4.8, 'origin': 'Hawaii', 'description': 'Smooth Hawaiian coffee', 'imageUrl': 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=300&h=200&fit=crop'},
      {'name': 'Sumatra Coffee', 'price': 14.99, 'icon': Icons.public, 'roast': 'Dark Roast', 'rating': 4.7, 'origin': 'Sumatra', 'description': 'Earthy and full-bodied', 'imageUrl': 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=300&h=200&fit=crop'},
      {'name': 'Guatemalan Coffee', 'price': 12.99, 'icon': Icons.public, 'roast': 'Medium Roast', 'rating': 4.6, 'origin': 'Guatemala', 'description': 'Spicy and complex', 'imageUrl': 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=300&h=200&fit=crop'},
      {'name': 'Costa Rican Coffee', 'price': 13.99, 'icon': Icons.public, 'roast': 'Light Roast', 'rating': 4.7, 'origin': 'Costa Rica', 'description': 'Clean and bright', 'imageUrl': 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=300&h=200&fit=crop'},
      {'name': 'Peruvian Coffee', 'price': 11.99, 'icon': Icons.public, 'roast': 'Medium Roast', 'rating': 4.5, 'origin': 'Peru', 'description': 'Mild and sweet', 'imageUrl': 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=300&h=200&fit=crop'},
      {'name': 'Mexican Coffee', 'price': 10.99, 'icon': Icons.public, 'roast': 'Medium Roast', 'rating': 4.4, 'origin': 'Mexico', 'description': 'Light and aromatic', 'imageUrl': 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=300&h=200&fit=crop'},
      {'name': 'Kenyan Coffee', 'price': 15.99, 'icon': Icons.public, 'roast': 'Light Roast', 'rating': 4.8, 'origin': 'Kenya', 'description': 'Wine-like acidity', 'imageUrl': 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=300&h=200&fit=crop'},
      {'name': 'Tanzanian Coffee', 'price': 14.99, 'icon': Icons.public, 'roast': 'Medium Roast', 'rating': 4.6, 'origin': 'Tanzania', 'description': 'Fruity and bright', 'imageUrl': 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=300&h=200&fit=crop'},
    ];

    // Filter by roast type
    if (_selectedFilter != 'All') {
      items = items.where((item) => item['roast'] == _selectedFilter).toList();
    }

    // Sort items
    items.sort((a, b) {
      switch (_sortBy) {
        case 'Price':
          return (a['price'] as double).compareTo(b['price'] as double);
        case 'Rating':
          return (b['rating'] as double).compareTo(a['rating'] as double);
        default:
          return (a['name'] as String).compareTo(b['name'] as String);
      }
    });

    return items;
  }

  Widget _buildCoffeeBeanItem(Map<String, dynamic> item) {
    return Card(
      elevation: 6,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.brown.shade50, Colors.brown.shade100],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 60,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.brown.shade200,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  item['imageUrl'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.brown.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(item['icon'] as IconData, size: 30, color: Colors.brown),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.brown.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.brown, strokeWidth: 1.5),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                item['name'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              item['origin'] as String,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.brown.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item['roast'] as String,
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 12),
                Text(' ${item['rating']}', style: const TextStyle(fontSize: 10)),
              ],
            ),
            Text(
              '\$${item['price']}',
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            ElevatedButton.icon(
              onPressed: () => _addToCart(item),
              icon: const Icon(Icons.add_shopping_cart, size: 12),
              label: const Text('Add', style: TextStyle(fontSize: 10)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: const Size(0, 28),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      _cart.add(item);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} added to cart!'),
        backgroundColor: Colors.brown,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: _showCart,
        ),
      ),
    );
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Shopping Cart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_cart.isEmpty)
              const Text('Your cart is empty')
            else
              ..._cart.map((item) => ListTile(
                leading: Icon(item['icon']),
                title: Text(item['name']),
                subtitle: Text('${item['origin']} - ${item['roast']}'),
                trailing: Text('\$${item['price']}'),
              )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order placed successfully!')),
                );
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}

// Cart Page - Shopping cart functionality
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<Map<String, dynamic>> _cartItems = [
    {'name': 'Coffee Bean T-Shirt', 'price': 24.99, 'quantity': 1, 'category': 'Fashion'},
    {'name': 'Espresso Machine Deluxe', 'price': 299.99, 'quantity': 1, 'category': 'Equipment'},
    {'name': 'Arabica Beans', 'price': 12.99, 'quantity': 2, 'category': 'Coffee'},
  ];

  @override
  Widget build(BuildContext context) {
    double total = _cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));

    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Shopping Cart'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItem(_cartItems[index], index);
              },
            ),
          ),
          _buildTotalSection(total),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.brown.shade100,
          child: Icon(
            _getCategoryIcon(item['category']),
            color: Colors.brown,
          ),
        ),
        title: Text(item['name']),
        subtitle: Text('${item['category']} - \$${item['price']} each'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => _updateQuantity(index, -1),
            ),
            Text('${item['quantity']}'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _updateQuantity(index, 1),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeItem(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection(double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order placed successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Proceed to Checkout', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Fashion':
        return Icons.checkroom;
      case 'Equipment':
        return Icons.devices;
      case 'Coffee':
        return Icons.coffee;
      default:
        return Icons.shopping_cart;
    }
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      _cartItems[index]['quantity'] += change;
      if (_cartItems[index]['quantity'] <= 0) {
        _cartItems.removeAt(index);
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }
}

// Gallery Page - Interactive image gallery with PageView
class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📸 Coffee Gallery'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareImage(),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => _addToFavorites(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: _getImages().length,
              itemBuilder: (context, index) {
                return _buildImagePage(index);
              },
            ),
          ),
          _buildImageInfo(),
          _buildPageIndicator(),
        ],
      ),
    );
  }

  Widget _buildImagePage(int index) {
    final images = _getImages();
    final image = images[index];
    
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 8,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.brown.shade100, Colors.brown.shade200],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          image['imageUrl'],
                          width: 200,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 200,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.brown.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(image['icon'], size: 60, color: Colors.brown),
                                  const SizedBox(height: 8),
                                  const Text('Image unavailable', style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 200,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.brown.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(color: Colors.brown),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        image['title'],
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                image['description'],
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageInfo() {
    final images = _getImages();
    final currentImage = images[_currentIndex];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentImage['title'],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_currentIndex + 1} of ${images.length}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up),
                onPressed: () => _likeImage(),
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () => _commentImage(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _getImages().asMap().entries.map((entry) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == entry.key ? Colors.brown : Colors.grey,
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Map<String, dynamic>> _getImages() {
    return [
      {
        'title': 'Fresh Coffee Beans',
        'description': 'Premium coffee beans freshly roasted to perfection',
        'icon': Icons.coffee,
        'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=400&h=300&fit=crop',
      },
      {
        'title': 'Espresso Machine',
        'description': 'Professional espresso machine for the perfect shot',
        'icon': Icons.local_cafe,
        'imageUrl': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400&h=300&fit=crop',
      },
      {
        'title': 'Coffee Grinder',
        'description': 'Burr grinder for consistent coffee grounds',
        'icon': Icons.blender,
        'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=400&h=300&fit=crop',
      },
      {
        'title': 'Coffee Cups',
        'description': 'Ceramic cups designed for optimal coffee tasting',
        'icon': Icons.local_drink,
        'imageUrl': 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=400&h=300&fit=crop',
      },
      {
        'title': 'Coffee Shop Interior',
        'description': 'Cozy atmosphere perfect for enjoying coffee',
        'icon': Icons.store,
        'imageUrl': 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=400&h=300&fit=crop',
      },
      {
        'title': 'Barista at Work',
        'description': 'Professional barista crafting the perfect cup',
        'icon': Icons.person,
        'imageUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
      },
      {
        'title': 'Coffee Latte Art',
        'description': 'Beautiful latte art showcasing barista skills',
        'icon': Icons.auto_awesome,
        'imageUrl': 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400&h=300&fit=crop',
      },
      {
        'title': 'Coffee Roasting',
        'description': 'Coffee beans being roasted to perfection',
        'icon': Icons.local_fire_department,
        'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=400&h=300&fit=crop',
      },
      {
        'title': 'Coffee Plantation',
        'description': 'Coffee plants growing in their natural habitat',
        'icon': Icons.park,
        'imageUrl': 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=400&h=300&fit=crop',
      },
      {
        'title': 'Coffee Accessories',
        'description': 'Essential accessories for coffee brewing',
        'icon': Icons.widgets,
        'imageUrl': 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=400&h=300&fit=crop',
      },
    ];
  }

  void _shareImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image shared!')),
    );
  }

  void _addToFavorites() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to favorites!')),
    );
  }

  void _likeImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image liked!')),
    );
  }

  void _commentImage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Comment'),
        content: const TextField(
          decoration: InputDecoration(hintText: 'Write your comment...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Comment added!')),
              );
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}

// Product Selector Page - ListWheelScrollView for coffee selection
class ProductSelectorPage extends StatefulWidget {
  const ProductSelectorPage({super.key});

  @override
  State<ProductSelectorPage> createState() => _ProductSelectorPageState();
}

class _ProductSelectorPageState extends State<ProductSelectorPage> {
  int _selectedIndex = 0;
  final FixedExtentScrollController _scrollController = FixedExtentScrollController();

  @override
  Widget build(BuildContext context) {
    final products = _getProducts();
    final selectedProduct = products[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎯 Product Selector'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListWheelScrollView.useDelegate(
              controller: _scrollController,
              itemExtent: 200,
              perspective: 0.005,
              diameterRatio: 1.2,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  return _buildWheelItem(products[index], index);
                },
                childCount: products.length,
              ),
            ),
          ),
          _buildProductInfo(selectedProduct),
          _buildActionButtons(selectedProduct),
        ],
      ),
    );
  }

  Widget _buildWheelItem(Map<String, dynamic> product, int index) {
    final isSelected = index == _selectedIndex;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.brown : Colors.brown.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.3 : 0.1),
            blurRadius: isSelected ? 12 : 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              product['icon'] as IconData,
              size: isSelected ? 80 : 60,
              color: isSelected ? Colors.white : Colors.brown,
            ),
            const SizedBox(height: 16),
            Text(
              product['name'] as String,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.brown,
                fontSize: isSelected ? 18 : 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSelected) ...[
              const SizedBox(height: 8),
              Text(
                '\$${product['price']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo(Map<String, dynamic> product) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            product['name'] as String,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            product['description'] as String,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoChip('Price', '\$${product['price']}', Icons.attach_money),
              _buildInfoChip('Rating', '${product['rating']}★', Icons.star),
              _buildInfoChip('Origin', product['origin'] as String, Icons.public),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.brown, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> product) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _addToCart(product),
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _addToFavorites(product),
              icon: const Icon(Icons.favorite_border),
              label: const Text('Favorite'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade200,
                foregroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getProducts() {
    return [
      {'name': 'Espresso', 'price': 3.50, 'icon': Icons.local_cafe, 'rating': 4.8, 'origin': 'Italy', 'description': 'Rich and intense coffee shot'},
      {'name': 'Americano', 'price': 3.00, 'icon': Icons.local_cafe, 'rating': 4.6, 'origin': 'USA', 'description': 'Espresso with hot water'},
      {'name': 'Latte', 'price': 4.50, 'icon': Icons.local_cafe, 'rating': 4.9, 'origin': 'Italy', 'description': 'Espresso with steamed milk'},
      {'name': 'Cappuccino', 'price': 4.00, 'icon': Icons.local_cafe, 'rating': 4.7, 'origin': 'Italy', 'description': 'Espresso with equal parts milk and foam'},
      {'name': 'Macchiato', 'price': 3.75, 'icon': Icons.local_cafe, 'rating': 4.5, 'origin': 'Italy', 'description': 'Espresso with a dollop of foam'},
      {'name': 'Mocha', 'price': 5.00, 'icon': Icons.local_cafe, 'rating': 4.8, 'origin': 'Yemen', 'description': 'Espresso with chocolate and milk'},
      {'name': 'Frappuccino', 'price': 5.50, 'icon': Icons.local_cafe, 'rating': 4.6, 'origin': 'USA', 'description': 'Blended coffee drink'},
      {'name': 'Cold Brew', 'price': 4.25, 'icon': Icons.local_cafe, 'rating': 4.7, 'origin': 'Japan', 'description': 'Slow-steeped cold coffee'},
    ];
  }

  void _addToCart(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart!'),
        backgroundColor: Colors.brown,
      ),
    );
  }

  void _addToFavorites(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to favorites!'),
        backgroundColor: Colors.brown,
      ),
    );
  }
}

// Team Page - DraggableScrollableSheet for team members
class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👥 Team Members'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Stack(
        children: [
          // Background content
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF8B4513), Color(0xFFD2691E)],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_cafe, size: 100, color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    'Coffee Shop Team',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Meet our amazing baristas',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Draggable sheet
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: _getTeamMembers().length,
                        itemBuilder: (context, index) {
                          return _buildTeamMemberCard(_getTeamMembers()[index]);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard(Map<String, dynamic> member) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.brown,
          radius: 30,
          child: Text(
            member['name']![0],
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        title: Text(
          member['name']!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(member['role']!, style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(member['email']!),
            Text(member['phone']!),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    member['experience']!,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    member['specialty']!,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () => _sendMessage(member),
            ),
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () => _callMember(member),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getTeamMembers() {
    return [
      {'name': 'John Smith', 'email': 'john@coffeeshop.com', 'phone': '+1-555-0101', 'role': 'Head Barista', 'experience': '5 years', 'specialty': 'Espresso'},
      {'name': 'Sarah Johnson', 'email': 'sarah@coffeeshop.com', 'phone': '+1-555-0102', 'role': 'Barista', 'experience': '3 years', 'specialty': 'Latte Art'},
      {'name': 'Mike Davis', 'email': 'mike@coffeeshop.com', 'phone': '+1-555-0103', 'role': 'Barista', 'experience': '2 years', 'specialty': 'Cold Brew'},
      {'name': 'Emily Brown', 'email': 'emily@coffeeshop.com', 'phone': '+1-555-0104', 'role': 'Cashier', 'experience': '1 year', 'specialty': 'Customer Service'},
      {'name': 'David Wilson', 'email': 'david@coffeeshop.com', 'phone': '+1-555-0105', 'role': 'Barista', 'experience': '4 years', 'specialty': 'Pour Over'},
      {'name': 'Lisa Anderson', 'email': 'lisa@coffeeshop.com', 'phone': '+1-555-0106', 'role': 'Manager', 'experience': '7 years', 'specialty': 'Operations'},
      {'name': 'Tom Garcia', 'email': 'tom@coffeeshop.com', 'phone': '+1-555-0107', 'role': 'Barista', 'experience': '2 years', 'specialty': 'Cappuccino'},
      {'name': 'Amy Martinez', 'email': 'amy@coffeeshop.com', 'phone': '+1-555-0108', 'role': 'Cashier', 'experience': '1 year', 'specialty': 'Customer Service'},
      {'name': 'Chris Taylor', 'email': 'chris@coffeeshop.com', 'phone': '+1-555-0109', 'role': 'Barista', 'experience': '3 years', 'specialty': 'Macchiato'},
      {'name': 'Jessica Lee', 'email': 'jessica@coffeeshop.com', 'phone': '+1-555-0110', 'role': 'Barista', 'experience': '2 years', 'specialty': 'Mocha'},
    ];
  }

  void _sendMessage(Map<String, dynamic> member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Message ${member['name']}'),
        content: const TextField(
          decoration: InputDecoration(hintText: 'Type your message...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Message sent to ${member['name']}!')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _callMember(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling ${member['name']}...')),
    );
  }
}

// Shopping List Page - Interactive shopping list with add/remove functionality
class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final List<Map<String, dynamic>> _shoppingItems = [];
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedCategory = 'Coffee';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Shopping List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddItemDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildAddItemSection(),
          Expanded(
            child: ListView.separated(
              itemCount: _shoppingItems.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey,
              ),
              itemBuilder: (context, index) {
                return _buildShoppingItem(_shoppingItems[index], index);
              },
            ),
          ),
          _buildTotalSection(),
        ],
      ),
    );
  }

  Widget _buildAddItemSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _itemController,
                  decoration: const InputDecoration(
                    hintText: 'Item name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    hintText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  items: ['Coffee', 'Equipment', 'Fashion', 'Accessories'].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addItem,
                child: const Text('Add'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingItem(Map<String, dynamic> item, int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getCategoryColor(item['category']!),
        child: Text(
          item['category']![0],
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        item['name']!,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          decoration: item['completed'] == true ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(item['category']!),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '\$${item['price']}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(width: 8),
          Checkbox(
            value: item['completed'] ?? false,
            onChanged: (bool? value) {
              setState(() {
                item['completed'] = value;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeItem(index),
          ),
        ],
      ),
      onTap: () {
        setState(() {
          item['completed'] = !(item['completed'] ?? false);
        });
      },
    );
  }

  Widget _buildTotalSection() {
    double total = _shoppingItems.fold(0, (sum, item) => sum + (item['price'] as double));
    int completedCount = _shoppingItems.where((item) => item['completed'] == true).length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Completed: $completedCount/${_shoppingItems.length}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _clearCompleted,
            child: const Text('Clear Completed'),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Coffee':
        return Colors.brown;
      case 'Equipment':
        return Colors.blue;
      case 'Fashion':
        return Colors.purple;
      case 'Accessories':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _addItem() {
    if (_itemController.text.isNotEmpty && _priceController.text.isNotEmpty) {
      setState(() {
        _shoppingItems.add({
          'name': _itemController.text,
          'price': double.tryParse(_priceController.text) ?? 0.0,
          'category': _selectedCategory,
          'completed': false,
        });
        _itemController.clear();
        _priceController.clear();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _shoppingItems.removeAt(index);
    });
  }

  void _clearCompleted() {
    setState(() {
      _shoppingItems.removeWhere((item) => item['completed'] == true);
    });
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _itemController,
              decoration: const InputDecoration(hintText: 'Item name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(hintText: 'Price'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _addItem();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

// Order Tracker Page - Enhanced todo list with order tracking
class OrderTrackerPage extends StatefulWidget {
  const OrderTrackerPage({super.key});

  @override
  State<OrderTrackerPage> createState() => _OrderTrackerPageState();
}

class _OrderTrackerPageState extends State<OrderTrackerPage> {
  final List<Map<String, dynamic>> _orders = [];
  final TextEditingController _orderController = TextEditingController();
  String _selectedStatus = 'Pending';

  @override
  void initState() {
    super.initState();
    _initializeOrders();
  }

  void _initializeOrders() {
    _orders.addAll([
      {'id': 'ORD-001', 'description': 'Espresso Machine Deluxe', 'status': 'Shipped', 'date': '2024-01-15', 'priority': 'High'},
      {'id': 'ORD-002', 'description': 'Coffee Bean T-Shirt (M)', 'status': 'Delivered', 'date': '2024-01-14', 'priority': 'Medium'},
      {'id': 'ORD-003', 'description': 'Arabica Beans (2x)', 'status': 'Processing', 'date': '2024-01-16', 'priority': 'Low'},
      {'id': 'ORD-004', 'description': 'Coffee Grinder Pro', 'status': 'Pending', 'date': '2024-01-17', 'priority': 'High'},
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Order Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddOrderDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: ListView.builder(
              itemCount: _getFilteredOrders().length,
              itemBuilder: (context, index) {
                return _buildOrderCard(_getFilteredOrders()[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              value: _selectedStatus,
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatus = newValue!;
                });
              },
              items: ['All', 'Pending', 'Processing', 'Shipped', 'Delivered'].map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _showAddOrderDialog,
            child: const Text('Add Order'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, int index) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(order['status']!),
          child: Text(
            order['id']!.substring(4),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          order['description']!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order['id']}'),
            Text('Date: ${order['date']}'),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order['status']!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order['status']!,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(order['priority']!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order['priority']!,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'update',
              child: const Text('Update Status'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: const Text('Delete'),
            ),
          ],
          onSelected: (value) {
            if (value == 'update') {
              _updateOrderStatus(index);
            } else if (value == 'delete') {
              _deleteOrder(index);
            }
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
      case 'Shipped':
        return Colors.purple;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _getFilteredOrders() {
    if (_selectedStatus == 'All') {
      return _orders;
    }
    return _orders.where((order) => order['status'] == _selectedStatus).toList();
  }

  void _updateOrderStatus(int index) {
    final order = _orders[index];
    final statuses = ['Pending', 'Processing', 'Shipped', 'Delivered'];
    final currentIndex = statuses.indexOf(order['status']!);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses.map((status) {
            return RadioListTile<String>(
              title: Text(status),
              value: status,
              groupValue: order['status'],
              onChanged: (String? value) {
                setState(() {
                  order['status'] = value;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _deleteOrder(int index) {
    setState(() {
      _orders.removeAt(index);
    });
  }

  void _showAddOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _orderController,
              decoration: const InputDecoration(hintText: 'Order description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _addOrder();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addOrder() {
    if (_orderController.text.isNotEmpty) {
      setState(() {
        _orders.add({
          'id': 'ORD-${(_orders.length + 1).toString().padLeft(3, '0')}',
          'description': _orderController.text,
          'status': 'Pending',
          'date': DateTime.now().toString().split(' ')[0],
          'priority': 'Medium',
        });
        _orderController.clear();
      });
    }
  }
}

// Coffee Guide Page - Interactive widget guide
class CoffeeGuidePage extends StatefulWidget {
  const CoffeeGuidePage({super.key});

  @override
  State<CoffeeGuidePage> createState() => _CoffeeGuidePageState();
}

class _CoffeeGuidePageState extends State<CoffeeGuidePage> {
  int _selectedGuideIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Coffee Guide'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildGuideSelector(),
            const SizedBox(height: 20),
            _buildGuideContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideSelector() {
    final guides = _getGuides();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Coffee Knowledge',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: guides.asMap().entries.map((entry) {
              final index = entry.key;
              final guide = entry.value;
              return ChoiceChip(
                label: Text(guide['title']!),
                selected: _selectedGuideIndex == index,
                onSelected: (selected) {
                  setState(() {
                    _selectedGuideIndex = index;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideContent() {
    final guides = _getGuides();
    final selectedGuide = guides[_selectedGuideIndex];
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(selectedGuide['icon'], size: 40, color: Colors.brown),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    selectedGuide['title']!,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              selectedGuide['description']!,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            if (selectedGuide['steps'] != null) ...[
              const Text(
                'Steps:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...(selectedGuide['steps'] as List<String>).asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _shareGuide(selectedGuide),
              icon: const Icon(Icons.share),
              label: const Text('Share Guide'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getGuides() {
    return [
      {
        'title': 'Espresso Basics',
        'icon': Icons.local_cafe,
        'description': 'Learn the fundamentals of making perfect espresso shots.',
        'steps': [
          'Grind coffee beans to fine consistency',
          'Dose 18-20g of coffee grounds',
          'Tamp evenly with 30lbs pressure',
          'Extract for 25-30 seconds',
          'Aim for 1:2 ratio (18g in, 36g out)',
        ],
      },
      {
        'title': 'Latte Art',
        'icon': Icons.auto_awesome,
        'description': 'Master the art of creating beautiful designs in your latte.',
        'steps': [
          'Steam milk to 150°F with microfoam',
          'Pour espresso shot into cup',
          'Start pouring milk from high position',
          'Lower pitcher as cup fills',
          'Create design with controlled movements',
        ],
      },
      {
        'title': 'Coffee Grinding',
        'icon': Icons.blender,
        'description': 'Understand how grind size affects your coffee extraction.',
        'steps': [
          'Choose appropriate grind size for brewing method',
          'Use burr grinder for consistency',
          'Grind just before brewing',
          'Adjust grind based on extraction time',
          'Clean grinder regularly',
        ],
      },
      {
        'title': 'Cold Brew',
        'icon': Icons.water_drop,
        'description': 'Learn to make smooth, refreshing cold brew coffee.',
        'steps': [
          'Use coarse grind coffee beans',
          'Mix 1:4 ratio coffee to water',
          'Steep for 12-24 hours at room temperature',
          'Strain through fine mesh or filter',
          'Dilute with water or milk to taste',
        ],
      },
      {
        'title': 'Coffee Storage',
        'icon': Icons.inventory,
        'description': 'Keep your coffee fresh and flavorful longer.',
        'steps': [
          'Store in airtight container',
          'Keep away from light and heat',
          'Avoid freezing or refrigerating',
          'Use within 2-4 weeks of roasting',
          'Grind only what you need',
        ],
      },
    ];
  }

  void _shareGuide(Map<String, dynamic> guide) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${guide['title']} guide shared!')),
    );
  }
}

// All Products Page - Complete product catalog
class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  final List<Map<String, dynamic>> _cart = [];
  String _selectedCategory = 'All';
  String _sortBy = 'Name';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛍️ All Products'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => _showCart(),
              ),
              if (_cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${_cart.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: ListView.builder(
              itemCount: _getFilteredProducts().length,
              itemBuilder: (context, index) {
                return _buildProductItem(_getFilteredProducts()[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Category:', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  items: ['All', 'Coffee', 'Equipment', 'Fashion', 'Accessories'].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sort by:', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: _sortBy,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _sortBy = newValue!;
                    });
                  },
                  items: ['Name', 'Price', 'Rating'].map((String sort) {
                    return DropdownMenuItem<String>(
                      value: sort,
                      child: Text(sort),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredProducts() {
    List<Map<String, dynamic>> products = [
      // Coffee products
      {'name': 'Arabica Beans', 'price': 12.99, 'rating': 4.8, 'category': 'Coffee', 'description': 'Premium Colombian beans'},
      {'name': 'Espresso Blend', 'price': 14.99, 'rating': 4.9, 'category': 'Coffee', 'description': 'Perfect for espresso'},
      {'name': 'Cold Brew', 'price': 8.99, 'rating': 4.6, 'category': 'Coffee', 'description': 'Ready-to-drink cold brew'},
      
      // Equipment products
      {'name': 'Espresso Machine', 'price': 299.99, 'rating': 4.9, 'category': 'Equipment', 'description': 'Professional espresso machine'},
      {'name': 'Coffee Grinder', 'price': 89.99, 'rating': 4.8, 'category': 'Equipment', 'description': 'Burr grinder for perfect grind'},
      {'name': 'Coffee Scale', 'price': 45.99, 'rating': 4.7, 'category': 'Equipment', 'description': 'Digital precision scale'},
      
      // Fashion products
      {'name': 'Coffee T-Shirt', 'price': 24.99, 'rating': 4.6, 'category': 'Fashion', 'description': 'Coffee-themed apparel'},
      {'name': 'Barista Apron', 'price': 19.99, 'rating': 4.5, 'category': 'Fashion', 'description': 'Professional apron'},
      {'name': 'Coffee Hoodie', 'price': 39.99, 'rating': 4.7, 'category': 'Fashion', 'description': 'Cozy coffee hoodie'},
      
      // Accessories
      {'name': 'Coffee Cups Set', 'price': 39.99, 'rating': 4.8, 'category': 'Accessories', 'description': 'Ceramic coffee cups'},
      {'name': 'Coffee Filters', 'price': 12.99, 'rating': 4.4, 'category': 'Accessories', 'description': 'Premium filter papers'},
      {'name': 'Coffee Timer', 'price': 19.99, 'rating': 4.6, 'category': 'Accessories', 'description': 'Digital brewing timer'},
    ];

    // Filter by category
    if (_selectedCategory != 'All') {
      products = products.where((product) => product['category'] == _selectedCategory).toList();
    }

    // Sort products
    products.sort((a, b) {
      switch (_sortBy) {
        case 'Price':
          return (a['price'] as double).compareTo(b['price'] as double);
        case 'Rating':
          return (b['rating'] as double).compareTo(a['rating'] as double);
        default:
          return (a['name'] as String).compareTo(b['name'] as String);
      }
    });

    return products;
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getCategoryIcon(product['category']!),
                size: 50,
                color: Colors.brown,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] as String,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['description'] as String,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.brown.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product['category'] as String,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(' ${product['rating']}'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product['price']}',
                    style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _addToCart(product),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () => _addToFavorites(product),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Coffee':
        return Icons.coffee;
      case 'Equipment':
        return Icons.devices;
      case 'Fashion':
        return Icons.checkroom;
      case 'Accessories':
        return Icons.widgets;
      default:
        return Icons.shopping_cart;
    }
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      _cart.add(product);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart!'),
        backgroundColor: Colors.brown,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: _showCart,
        ),
      ),
    );
  }

  void _addToFavorites(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to favorites!'),
        backgroundColor: Colors.brown,
      ),
    );
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Shopping Cart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_cart.isEmpty)
              const Text('Your cart is empty')
            else
              ..._cart.map((item) => ListTile(
                leading: Icon(_getCategoryIcon(item['category'])),
                title: Text(item['name']),
                subtitle: Text(item['category']),
                trailing: Text('\$${item['price']}'),
              )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order placed successfully!')),
                );
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}


