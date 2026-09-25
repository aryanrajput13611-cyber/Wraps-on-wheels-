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
      title: 'Wraps On Wheels POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFFFF5722),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF5722),
          secondary: Color(0xFFFF5722),
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
    Center(child: Text("Counter / POS Screen", style: TextStyle(color: Colors.white70))),
    Center(child: Text("All Orders & History", style: TextStyle(color: Colors.white70))),
    Center(child: Text("Settings", style: TextStyle(color: Colors.white70))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: const Color(0xFF1E1E1E),
        indicatorColor: const Color(0xFFFF5722),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.soup_kitchen_outlined),
            selectedIcon: Icon(Icons.soup_kitchen),
            label: 'Kitchen',
          ),
          NavigationDestination(
            icon: Icon(Icons.point_of_sale_outlined),
            selectedIcon: Icon(Icons.point_of_sale),
            label: 'Counter',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
//                     KITCHEN SCREEN
// -------------------------------------------------------------
class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  String selectedFilter = 'NEW';

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Display', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: ['NEW', 'COOKING', 'READY', 'DONE'].map((status) {
                final isSelected = selectedFilter == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      status,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFFFF5722),
                    backgroundColor: const Color(0xFF2A2A2A),
                    onSelected: (val) {
                      if (val) setState(() => selectedFilter = status);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('orders')
            .where('status', isEqualTo: selectedFilter)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFF5722)));
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
          }

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_none, size: 64, color: Colors.white24),
                  const SizedBox(height: 12),
                  Text(
                    'No $selectedFilter orders right now.',
                    style: const TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final doc = orders[index];
              final data = doc.data() as Map<String, dynamic>;

              final items = (data['items'] as List<dynamic>?) ?? [];
              final table = data['table'] ?? data['tableNumber'] ?? 'Takeaway';
              final total = data['total'] ?? data['totalAmount'] ?? 0;
              final customerName = data['customerName'] ?? 'Guest';
              final diningGroup = data['diningGroup'] ?? '';
              final note = data['note'] ?? '';

              return Card(
                color: const Color(0xFF1E1E1E),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: selectedFilter == 'NEW' ? const Color(0xFFFF5722) : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Table Tag & Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5722).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              table.toString(),
                              style: const TextStyle(
                                color: Color(0xFFFF5722),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            '₹$total',
                            style: const TextStyle(
                              color: Color(0xFF4CAF50),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Customer Details
                      Text(
                        'Customer: $customerName',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (diningGroup.toString().isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Members: $diningGroup',
                          style: const TextStyle(fontSize: 13, color: Colors.orangeAccent),
                        ),
                      ],
                      if (note.toString().isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.yellowAccent.withOpacity(0.4)),
                          ),
                          child: Text(
                            'Note: $note',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.yellowAccent,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                      const Divider(color: Colors.white24, height: 24),

                      // Items List
                      ...items.map((item) {
                        final iName = item['name'] ?? 'Item';
                        final iQty = item['quantity'] ?? 1;
                        final iPrice = item['price'] ?? 0;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '$iName  x$iQty',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                '₹${iPrice * iQty}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 16),

                      // Action Buttons
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
                          if (selectedFilter == 'NEW')
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF5722),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                firestore.collection('orders').doc(doc.id).update({'status': 'COOKING'});
                              },
                              child: const Text('Start Cooking'),
                            ),
                          if (selectedFilter == 'COOKING')
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber[700],
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                firestore.collection('orders').doc(doc.id).update({'status': 'READY'});
                              },
                              child: const Text('Mark Ready'),
                            ),
                          if (selectedFilter == 'READY')
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                firestore.collection('orders').doc(doc.id).update({'status': 'DONE'});
                              },
                              child: const Text('Complete / Served'),
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
    );
  }
}
