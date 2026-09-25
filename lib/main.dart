import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC9jeLa4fifRH24dewecrUt",
      appId: "1:891475422514:web:cb7dee5c5edf2e45e37b2b",
      messagingSenderId: "891475422514",
      projectId: "wraps-on-wheels",
    ),
  );
  runApp(const WrapsApp());
}

class WrapsApp extends StatelessWidget {
  const WrapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wraps On Wheels',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF110D0B),
        cardColor: const Color(0xFF1D1815),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF5722),
          surface: Color(0xFF1D1815),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    KitchenScreen(),
    CounterScreen(),
    OrdersHistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_currentIndex]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF261E1A), width: 1)),
          color: Color(0xFF110D0B),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xFF110D0B),
          selectedItemColor: const Color(0xFFFF9800),
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.egg_alt_outlined),
              activeIcon: Icon(Icons.egg_alt),
              label: 'Kitchen',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_outlined),
              activeIcon: Icon(Icons.receipt),
              label: 'Counter',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              activeIcon: Icon(Icons.description),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build_outlined),
              activeIcon: Icon(Icons.build),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 1. KITCHEN SCREEN
// -------------------------------------------------------------
class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  String selectedFilter = 'NEW';
  bool viewByOrders = true;

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return Column(
      children: [
        // Top Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kitchen',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF261E1A),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => viewByOrders = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: viewByOrders ? const Color(0xFFFF5722) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Orders',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: viewByOrders ? Colors.white : Colors.white70,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => viewByOrders = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: !viewByOrders ? const Color(0xFFFF5722) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'By dish',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: !viewByOrders ? Colors.white : Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Filter Tabs (NEW, COOKING, READY, DONE)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['NEW', 'COOKING', 'READY', 'DONE'].map((status) {
              final isSel = selectedFilter == status;
              return GestureDetector(
                onTap: () => setState(() => selectedFilter = status),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSel ? const Color(0xFFFF9800) : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: isSel ? const Color(0xFFFF9800) : Colors.white60,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),

        // Orders Stream
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection('orders')
                .where('status', isEqualTo: selectedFilter)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFFF5722)));
              }

              final orders = snapshot.data?.docs ?? [];

              if (orders.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No new orders. Ears open for the ding 🔔',
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final doc = orders[index];
                  final data = doc.data() as Map<String, dynamic>;

                  final items = (data['items'] as List<dynamic>?) ?? [];
                  final table = data['table'] ?? data['tableNumber'] ?? 'Takeaway';
                  final total = data['total'] ?? data['totalAmount'] ?? 0;
                  final custName = data['customerName'] ?? 'Guest';
                  final dining = data['diningGroup'] ?? '';
                  final note = data['note'] ?? '';

                  return Card(
                    color: const Color(0xFF1D1815),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: selectedFilter == 'NEW' ? const Color(0xFFFF5722) : const Color(0xFF2C2420),
                      ),
                    ),
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF381F17),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  table.toString(),
                                  style: const TextStyle(
                                    color: Color(0xFFFF7043),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '₹$total',
                                style: const TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Customer: $custName',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          if (dining.toString().isNotEmpty)
                            Text(
                              'Members: $dining',
                              style: const TextStyle(fontSize: 13, color: Color(0xFFFF9800)),
                            ),
                          if (note.toString().isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.amber.withOpacity(0.4)),
                              ),
                              child: Text(
                                'Note: $note',
                                style: const TextStyle(fontSize: 13, color: Colors.amberAccent, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                          const Divider(color: Color(0xFF2C2420), height: 24),
                          ...items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${item['name']}  x${item['quantity']}",
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                  ),
                                  Text('₹${(item['price'] ?? 0) * (item['quantity'] ?? 1)}', style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  firestore.collection('orders').doc(doc.id).update({'status': 'CANCELLED'});
                                },
                                child: const Text('Cancel Order', style: TextStyle(color: Colors.redAccent)),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedFilter == 'NEW'
                                      ? const Color(0xFFFF5722)
                                      : selectedFilter == 'COOKING'
                                          ? const Color(0xFFFF9800)
                                          : const Color(0xFF4CAF50),
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  String nextStatus = selectedFilter == 'NEW'
                                      ? 'COOKING'
                                      : selectedFilter == 'COOKING'
                                          ? 'READY'
                                          : 'DONE';
                                  firestore.collection('orders').doc(doc.id).update({'status': nextStatus});
                                },
                                child: Text(
                                  selectedFilter == 'NEW'
                                      ? 'Start Cooking'
                                      : selectedFilter == 'COOKING'
                                          ? 'Mark Ready'
                                          : 'Serve Order',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------
// 2. COUNTER SCREEN (POS Menu Grid)
// -------------------------------------------------------------
class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dishes = [
      {'name': '1 Feet • Normal', 'price': 240, 'chili': false},
      {'name': '1 Feet • BBQ', 'price': 240, 'chili': false},
      {'name': '1 Feet • Tandoori', 'price': 240, 'chili': false},
      {'name': '1 Feet • Peri Peri', 'price': 240, 'chili': true},
      {'name': '1 Feet • Jalapeno', 'price': 240, 'chili': true},
      {'name': '1 Feet • Jamaican Jerk', 'price': 240, 'chili': true},
      {'name': '1 Feet • Hot N Spicy', 'price': 240, 'chili': true},
      {'name': '1 Feet • Korean', 'price': 240, 'chili': true},
      {'name': '1 Feet • Cheese Burst', 'price': 240, 'chili': false},
      {'name': '1 Feet • Honey Mustard', 'price': 240, 'chili': false},
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Counter',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 6),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFFFF9800), width: 2.5)),
                  ),
                  child: const Text(
                    'NEW ORDER',
                    style: TextStyle(color: Color(0xFFFF9800), fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 24),
                const Text(
                  'PAYMENTS',
                  style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1815),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2C2420)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.white54, size: 20),
                  SizedBox(width: 10),
                  Text('Search dish...', style: TextStyle(color: Colors.white38, fontSize: 14)),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              '1 Feet Shawarma',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: dishes.length,
              itemBuilder: (context, index) {
                final d = dishes[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1815),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2A221E)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              d['name'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (d['chili'] == true) const Text(' 🌶️', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '₹${d['price']} +',
                        style: const TextStyle(color: Color(0xFFFF9800), fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 3. ORDERS HISTORY SCREEN
// -------------------------------------------------------------
class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Orders', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5722),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Today', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1815),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF2C2420)),
                  ),
                  child: const Text('Yesterday', style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text('0 orders • ₹0 collected', style: TextStyle(color: Colors.white54, fontSize: 13)),
            const Spacer(),
            const Center(child: Text('No orders here.', style: TextStyle(color: Colors.white54, fontSize: 15))),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 4. SETTINGS SCREEN
// -------------------------------------------------------------
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Settings', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const Text('Wraps On Wheels', style: TextStyle(color: Colors.white54, fontSize: 14)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1D1815),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF2C2420)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('Notifications 🔔', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'This phone gets an alert when a QR order waits more than 3 minutes.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF381F17),
                    foregroundColor: const Color(0xFFFF9800),
                    side: const BorderSide(color: Color(0xFFFF7043)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {},
                  child: const Text('Send a test'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
