import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC9jeLa4fifRH24dewecrUt",
      appId: "1:891475422514:web:cb7dee5c5e",
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
      debugShowCheckedModeBanner: false,
      title: 'Wraps On Wheels POS',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F12),
        primaryColor: const Color(0xFFFF5A1F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF5A1F),
          secondary: Color(0xFFFF7A00),
          surface: Color(0xFF18181D),
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

  final List<Widget> _pages = const [
    KitchenScreen(),
    CounterScreen(),
    OrdersHistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF141418),
        indicatorColor: const Color(0xFFFF5A1F).withOpacity(0.2),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.soup_kitchen_outlined),
            selectedIcon: Icon(Icons.soup_kitchen, color: Color(0xFFFF5A1F)),
            label: 'Kitchen',
          ),
          NavigationDestination(
            icon: Icon(Icons.point_of_sale_outlined),
            selectedIcon: Icon(Icons.point_of_sale, color: Color(0xFFFF5A1F)),
            label: 'Counter',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long, color: Color(0xFFFF5A1F)),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: Color(0xFFFF5A1F)),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// ---------------- KITCHEN SCREEN ----------------
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
        backgroundColor: const Color(0xFF141418),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: ['NEW', 'COOKING', 'READY', 'DONE'].map((status) {
                final isSelected = selectedFilter == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(status),
                    selected: isSelected,
                    selectedColor: const Color(0xFFFF5A1F),
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
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFF5A1F)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_none, size: 60, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text('No $selectedFilter orders right now.', style: const TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final doc = orders[index];
              final data = doc.data() as Map<String, dynamic>;
              final items = (data['items'] as List<dynamic>?) ?? [];
              final table = data['tableNumber'] ?? 'Takeaway';
              final total = data['totalAmount'] ?? 0;

              return Card(
                color: const Color(0xFF18181D),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5A1F).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(table, style: const TextStyle(color: Color(0xFFFF5A1F), fontWeight: FontWeight.bold)),
                          ),
                          Text('₹$total', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                        ],
                      ),
                      const Divider(color: Colors.white12, height: 20),
                      ...items.map((it) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${it['name']}  x${it['quantity']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              Text('₹${(it['price'] ?? 0) * (it['quantity'] ?? 1)}', style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (selectedFilter == 'NEW') ...[
                            TextButton(
                              onPressed: () => _updateStatus(doc.id, 'CANCELLED'),
                              child: const Text('Cancel Order', style: TextStyle(color: Colors.redAccent)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5A1F)),
                              onPressed: () => _updateStatus(doc.id, 'COOKING'),
                              child: const Text('Confirm (Cook)'),
                            ),
                          ] else if (selectedFilter == 'COOKING') ...[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                              onPressed: () => _updateStatus(doc.id, 'READY'),
                              child: const Text('Mark as Ready'),
                            ),
                          ] else if (selectedFilter == 'READY') ...[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              onPressed: () => _updateStatus(doc.id, 'DONE'),
                              child: const Text('Serve & Complete'),
                            ),
                          ],
                        ],
                      )
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

  void _updateStatus(String docId, String newStatus) {
    FirebaseFirestore.instance.collection('orders').doc(docId).update({'status': newStatus});
  }
}

// ---------------- ORDERS HISTORY & EDIT SCREEN ----------------
class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Orders & Actions'),
        backgroundColor: const Color(0xFF141418),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('orders').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No orders found', style: TextStyle(color: Colors.grey)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final doc = docs[i];
              final data = doc.data() as Map<String, dynamic>;
              final status = data['status'] ?? 'NEW';
              final items = (data['items'] as List<dynamic>?) ?? [];

              return Card(
                color: const Color(0xFF18181D),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text('${data['tableNumber']} - ₹${data['totalAmount']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Items: ${items.length} | Status: $status\n${items.map((e) => "${e['name']}(x${e['quantity']})").join(", ")}'),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (val) {
                      if (val == 'cancel') {
                        firestore.collection('orders').doc(doc.id).update({'status': 'CANCELLED'});
                      } else if (val == 'delete') {
                        firestore.collection('orders').doc(doc.id).delete();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'cancel', child: Text('Cancel Order', style: TextStyle(color: Colors.orange))),
                      const PopupMenuItem(value: 'delete', child: Text('Delete Record', style: TextStyle(color: Colors.red))),
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

// ---------------- COUNTER SCREEN ----------------
class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final List<Map<String, dynamic>> menu = [
    {"name": "1 Feet Shawarma (Chicken)", "price": 220},
    {"name": "1 Feet Shawarma (Beef)", "price": 250},
    {"name": "Rumali Roll (Chicken)", "price": 130},
    {"name": "Plate Shawarma", "price": 180},
    {"name": "Loaded Fries", "price": 120},
    {"name": "Fresh Lime", "price": 30},
    {"name": "Blue Curacao Mojito", "price": 90},
    {"name": "Avil Milk Special", "price": 80},
  ];

  final Map<String, int> cart = {};
  String selectedTable = 'Table 1';

  @override
  Widget build(BuildContext context) {
    int total = 0;
    cart.forEach((k, v) {
      final item = menu.firstWhere((e) => e['name'] == k);
      total += (item['price'] as int) * v;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter POS'),
        backgroundColor: const Color(0xFF141418),
        actions: [
          DropdownButton<String>(
            value: selectedTable,
            dropdownColor: const Color(0xFF1E1E24),
            underline: const SizedBox(),
            items: ['Table 1', 'Table 2', 'Table 3', 'Table 4', 'Takeaway']
                .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white))))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => selectedTable = val);
            },
          ),
          const SizedBox(width: 14),
        ],
      ),
      body: ListView.builder(
        itemCount: menu.length,
        itemBuilder: (context, i) {
          final it = menu[i];
          final qty = cart[it['name']] ?? 0;
          return ListTile(
            title: Text(it['name']),
            subtitle: Text('₹${it['price']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (qty > 0)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                    onPressed: () {
                      setState(() {
                        if (qty == 1) cart.remove(it['name']);
                        else cart[it['name']] = qty - 1;
                      });
                    },
                  ),
                if (qty > 0) Text('$qty', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Color(0xFFFF5A1F)),
                  onPressed: () {
                    setState(() {
                      cart[it['name']] = qty + 1;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFF18181D),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total: ₹$total', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5A1F)),
              onPressed: cart.isEmpty ? null : () async {
                final orderItems = cart.entries.map((e) {
                  final it = menu.firstWhere((m) => m['name'] == e.key);
                  return {'name': e.key, 'price': it['price'], 'quantity': e.value};
                }).toList();

                await FirebaseFirestore.instance.collection('orders').add({
                  'tableNumber': selectedTable,
                  'items': orderItems,
                  'totalAmount': total,
                  'status': 'NEW',
                  'createdAt': FieldValue.serverTimestamp(),
                });

                setState(() => cart.clear());
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order Sent to Kitchen!')));
              },
              child: const Text('Send Order'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- SETTINGS SCREEN ----------------
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), backgroundColor: const Color(0xFF141418)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            leading: Icon(Icons.store, color: Color(0xFFFF5A1F)),
            title: Text('Restaurant Name'),
            subtitle: Text('Wraps On Wheels'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.cloud_done, color: Colors.green),
            title: Text('Database Connection'),
            subtitle: Text('Firebase Connected (Online)'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.volume_up, color: Colors.blueAccent),
            title: const Text('Sound Alerts'),
            subtitle: const Text('Ding tone enabled for new orders'),
            trailing: Switch(value: true, onChanged: (v) {}),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('App Version'),
            subtitle: Text('1.0.0 (Live Cloud System)'),
          ),
        ],
      ),
    );
  }
}
