import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const WrapsApp());
}

class WrapsApp extends StatelessWidget {
  const WrapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wraps On Wheels',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF12100E),
        primaryColor: const Color(0xFFE65100),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE65100),
          surface: Color(0xFF1E1A17),
        ),
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
  int _currentIndex = 1;

  final List<Widget> _pages = const [
    KitchenScreen(),
    CounterScreen(),
    OrdersScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF191512),
        selectedItemColor: const Color(0xFFE65100),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.egg_outlined),
            activeIcon: Icon(Icons.egg),
            label: 'Kitchen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Counter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined),
            activeIcon: Icon(Icons.build),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// ------------------- COUNTER SCREEN -------------------
class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _tabIndex = 0;
  String _searchQuery = "";

  // 1 FEET SHAWARMA (Chicken / Beef)
  final List<Map<String, dynamic>> feetShawarma = [
    {"name": "1 Feet · Normal (Ch/Bf)", "price": "240 / 250", "spicy": false},
    {"name": "1 Feet · BBQ (Ch/Bf)", "price": "240 / 250", "spicy": false},
    {"name": "1 Feet · Tandoori (Ch/Bf)", "price": "240 / 250", "spicy": false},
    {"name": "1 Feet · Peri Peri (Ch/Bf)", "price": "240 / 250", "spicy": true},
    {"name": "1 Feet · Jalapeno (Ch/Bf)", "price": "240 / 250", "spicy": true},
    {"name": "1 Feet · Jamaican Jerk", "price": "240 / 250", "spicy": true},
    {"name": "1 Feet · Hot N Spicy", "price": "240 / 250", "spicy": true},
    {"name": "1 Feet · Korean", "price": "240 / 250", "spicy": true},
    {"name": "1 Feet · Cheese Burst", "price": "240 / 250", "spicy": false},
    {"name": "1 Feet · Honey Mustard", "price": "240 / 250", "spicy": false},
  ];

  // SHAWARMA ROLLS (Rumali)
  final List<Map<String, dynamic>> rolls = [
    {"name": "Roll · Normal (Ch/Bf)", "price": "140 / 160", "spicy": false},
    {"name": "Roll · BBQ (Ch/Bf)", "price": "150 / 160", "spicy": false},
    {"name": "Roll · Tandoori (Ch/Bf)", "price": "150 / 160", "spicy": false},
    {"name": "Roll · Peri Peri (Ch/Bf)", "price": "150 / 160", "spicy": true},
    {"name": "Roll · Jalapeno (Ch/Bf)", "price": "150 / 160", "spicy": true},
    {"name": "Roll · Jamaican Jerk", "price": "150 / 160", "spicy": true},
    {"name": "Roll · Hot N Spicy", "price": "150 / 160", "spicy": true},
    {"name": "Roll · Korean", "price": "150 / 160", "spicy": true},
    {"name": "Roll · Cheese Burst", "price": "150 / 160", "spicy": false},
    {"name": "Roll · Honey Mustard", "price": "150 / 160", "spicy": false},
  ];

  // SHAWARMA PLATES (Rumali)
  final List<Map<String, dynamic>> plates = [
    {"name": "Plate · Normal (Ch/Bf)", "price": "240 / 250", "spicy": false},
    {"name": "Plate · BBQ (Ch/Bf)", "price": "240 / 250", "spicy": false},
    {"name": "Plate · Tandoori (Ch/Bf)", "price": "240 / 250", "spicy": false},
    {"name": "Plate · Peri Peri (Ch/Bf)", "price": "240 / 250", "spicy": true},
    {"name": "Plate · Jalapeno (Ch/Bf)", "price": "240 / 250", "spicy": true},
    {"name": "Plate · Jamaican Jerk", "price": "240 / 250", "spicy": true},
    {"name": "Plate · Hot N Spicy", "price": "240 / 250", "spicy": true},
    {"name": "Plate · Korean", "price": "240 / 250", "spicy": true},
    {"name": "Plate · Cheese Burst", "price": "240 / 250", "spicy": false},
    {"name": "Plate · Honey Mustard", "price": "240 / 250", "spicy": false},
  ];

  // LOADED FRIES (Full / Half)
  final List<Map<String, dynamic>> fries = [
    {"name": "Chicken Loaded Fries", "price": "250 / 160", "spicy": false},
    {"name": "Cheeseburst Loaded Fries", "price": "280 / 170", "spicy": false},
    {"name": "Beef Loaded Fries", "price": "260 / 170", "spicy": false},
    {"name": "Beef Cheeseburst Fries", "price": "300 / 180", "spicy": false},
  ];

  // ADD-ONS
  final List<Map<String, dynamic>> addons = [
    {"name": "Full Meat Add-on", "price": "40", "spicy": false},
    {"name": "Cheese Add-on", "price": "20", "spicy": false},
    {"name": "Rumali Roti Extra", "price": "10", "spicy": false},
    {"name": "Mix Add-on", "price": "20", "spicy": false},
  ];

  // JUICE MENU: LIME
  final List<Map<String, dynamic>> lime = [
    {"name": "Lime Juice", "price": "25", "spicy": false},
    {"name": "Lime Soda Salt", "price": "30", "spicy": false},
    {"name": "Lime Soda Sugar", "price": "30", "spicy": false},
    {"name": "Mint Lime", "price": "40", "spicy": false},
  ];

  // JUICE MENU: MOJITOS
  final List<Map<String, dynamic>> mojitos = [
    {"name": "Green Apple Mojito", "price": "50", "spicy": false},
    {"name": "Mango Mojito", "price": "60", "spicy": false},
    {"name": "Blueberry Mojito", "price": "60", "spicy": false},
    {"name": "Passion Fruit Mojito", "price": "60", "spicy": false},
  ];

  // JUICE MENU: AVIL MILK
  final List<Map<String, dynamic>> avilMilk = [
    {"name": "Normal Avil Milk", "price": "50", "spicy": false},
    {"name": "Diet Avil Milk", "price": "50", "spicy": false},
    {"name": "Chocolate Avil Milk", "price": "70", "spicy": false},
    {"name": "Vanilla Avil Milk", "price": "70", "spicy": false},
    {"name": "Caramel Avil Milk", "price": "70", "spicy": false},
    {"name": "Peanut Avil Milk", "price": "80", "spicy": false},
  ];

  // JUICE MENU: SHAKES
  final List<Map<String, dynamic>> shakes = [
    {"name": "Sharjah Shake", "price": "50", "spicy": false},
    {"name": "Chocolate Shake", "price": "60", "spicy": false},
    {"name": "Vanilla Shake", "price": "60", "spicy": false},
    {"name": "Butterscotch Shake", "price": "60", "spicy": false},
  ];

  Future<void> sendWhatsAppOrder(String itemName, String price) async {
    final text = Uri.encodeComponent(
        "New Order from Counter:\n- $itemName (₹$price)\n\nPlease prepare it.");
    final url = Uri.parse("https://wa.me/919310758470?text=$text");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text(
            "Counter",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _tabIndex = 0),
                child: Column(
                  children: [
                    Text(
                      "NEW ORDER",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _tabIndex == 0 ? const Color(0xFFE65100) : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (_tabIndex == 0)
                      Container(height: 2, width: 90, color: const Color(0xFFE65100)),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () => setState(() => _tabIndex = 1),
                child: Column(
                  children: [
                    Text(
                      "PAYMENTS",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _tabIndex == 1 ? const Color(0xFFE65100) : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (_tabIndex == 1)
                      Container(height: 2, width: 80, color: const Color(0xFFE65100)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF221D1A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
              decoration: const InputDecoration(
                icon: Icon(Icons.search, color: Colors.grey),
                hintText: "Search dish or juice...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildCategoryHeader("1 Feet Shawarma"),
                _buildGrid(feetShawarma),
                _buildCategoryHeader("Shawarma Rolls · Rumali"),
                _buildGrid(rolls),
                _buildCategoryHeader("Shawarma Plates · Rumali"),
                _buildGrid(plates),
                _buildCategoryHeader("Loaded Fries (Full / Half)"),
                _buildGrid(fries),
                _buildCategoryHeader("Add-Ons"),
                _buildGrid(addons),
                _buildCategoryHeader("Juice Menu · Lime"),
                _buildGrid(lime),
                _buildCategoryHeader("Juice Menu · Mojitos"),
                _buildGrid(mojitos),
                _buildCategoryHeader("Juice Menu · Avil Milk"),
                _buildGrid(avilMilk),
                _buildCategoryHeader("Juice Menu · Shakes"),
                _buildGrid(shakes),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      ),
    );
  }

  Widget _buildGrid(List<Map<String, dynamic>> items) {
    final filtered = items
        .where((i) => i["name"].toString().toLowerCase().contains(_searchQuery))
        .toList();

    if (filtered.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, idx) {
        final item = filtered[idx];
        return InkWell(
          onTap: () => sendWhatsAppOrder(item["name"], item["price"]),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF221D1A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item["name"],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item["spicy"] == true)
                      const Text(" 🌶️", style: TextStyle(fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "₹${item["price"]} +",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE65100),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ------------------- KITCHEN SCREEN -------------------
class KitchenScreen extends StatelessWidget {
  const KitchenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Kitchen", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF221D1A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE65100),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text("Orders", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("By dish", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("NEW", style: TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold)),
              Text("COOKING", style: TextStyle(color: Colors.grey)),
              Text("READY", style: TextStyle(color: Colors.grey)),
              Text("DONE", style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 4),
          Container(height: 2, width: 45, color: const Color(0xFFE65100)),
          const Expanded(
            child: Center(
              child: Text(
                "No new orders. Ears open for the ding 🔔",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- ORDERS SCREEN -------------------
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Orders", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE65100),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text("Today", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF221D1A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text("Yesterday", style: TextStyle(color: Colors.grey)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF221D1A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Text("25/09/2026", style: TextStyle(color: Colors.white70, fontSize: 13)),
                    Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text("0 orders · ₹0 collected", style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF332920),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text("All", style: TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold)),
              ),
              const Text("Open", style: TextStyle(color: Colors.grey)),
              const Text("Delivered", style: TextStyle(color: Colors.grey)),
              const Text("Cancelled", style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF221D1A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: Colors.grey),
                hintText: "Token, name, table or dish",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "No orders here.",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- SETTINGS SCREEN -------------------
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Settings & Printer Configuration",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }
}
