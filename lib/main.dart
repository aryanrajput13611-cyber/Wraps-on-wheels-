import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC9jeLa4fifRH24dewecrUfv-tVoErIonc",
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
        scaffoldBackgroundColor: const Color(0xFF110D0B),
        cardColor: const Color(0xFF1D1815),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF5722),
          surface: Color(0xFF1D1815),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Color(0xFFFF5722))),
          );
        }
        if (snapshot.hasData) {
          return const MainNavigationScreen();
        }
        return const LoginScreen();
      },
    );
  }
}

// -------------------------------------------------------------
// LOGIN SCREEN
// -------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String _err = '';

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _err = '';
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _err = e.message ?? 'Login failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF110D0B),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Icon(Icons.soup_kitchen, size: 70, color: Color(0xFFFF5722)),
              const SizedBox(height: 14),
              const Text('Wraps On Wheels', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const Text('Staff & Kitchen POS Login', style: TextStyle(color: Colors.white54, fontSize: 13)),
              const SizedBox(height: 28),
              if (_err.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.redAccent),
                  ),
                  child: Text(_err, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                ),
              TextField(
                controller: _email,
                decoration: InputDecoration(
                  labelText: 'Staff Email',
                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF1D1815),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF1D1815),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5722),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Log In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// MAIN NAVIGATION
// -------------------------------------------------------------
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
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.egg_alt_outlined), activeIcon: Icon(Icons.egg_alt), label: 'Kitchen'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_outlined), activeIcon: Icon(Icons.receipt), label: 'Counter'),
            BottomNavigationBarItem(icon: Icon(Icons.description_outlined), activeIcon: Icon(Icons.description), label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.build_outlined), activeIcon: Icon(Icons.build), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 1. KITCHEN SCREEN (हूबहू स्क्रीन 1 जैसा)
// -------------------------------------------------------------
class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  String selectedFilter = 'COOKING';
  bool viewByOrders = true;

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kitchen', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              Container(
                decoration: BoxDecoration(color: const Color(0xFF261E1A), borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFFF5722), borderRadius: BorderRadius.circular(16)),
                      child: const Text('Orders', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      child: const Text('By dish', style: TextStyle(fontSize: 13, color: Colors.white60)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Filter tabs with order counts
        StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('orders').snapshots(),
          builder: (context, snapshot) {
            final docs = snapshot.data?.docs ?? [];
            final newC = docs.where((d) => (d.data() as Map)['status'] == 'NEW').length;
            final cookC = docs.where((d) => (d.data() as Map)['status'] == 'COOKING').length;
            final readyC = docs.where((d) => (d.data() as Map)['status'] == 'READY').length;
            final doneC = docs.where((d) => (d.data() as Map)['status'] == 'DONE').length;

            final tabs = [
              {'status': 'NEW', 'label': 'NEW ($newC)'},
              {'status': 'COOKING', 'label': 'COOKING ($cookC)'},
              {'status': 'READY', 'label': 'READY ($readyC)'},
              {'status': 'DONE', 'label': 'DONE ($doneC)'},
            ];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: tabs.map((t) {
                  final isSel = selectedFilter == t['status'];
                  return GestureDetector(
                    onTap: () => setState(() => selectedFilter = t['status'] as String),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: isSel ? const Color(0xFFFF9800) : Colors.transparent, width: 2.5)),
                      ),
                      child: Text(
                        t['label'] as String,
                        style: TextStyle(
                          color: isSel ? const Color(0xFFFF9800) : Colors.white60,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('orders').where('status', isEqualTo: selectedFilter).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFFF5722)));
              final orders = snapshot.data!.docs;

              if (orders.isEmpty) {
                return const Center(child: Text('No orders in this state 🔔', style: TextStyle(color: Colors.white54)));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final doc = orders[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final token = data['token'] ?? (index + 20).toString();
                  final name = data['customerName'] ?? 'Guest';
                  final source = data['source'] ?? 'Counter';
                  final total = data['total'] ?? 0;
                  final items = (data['items'] as List<dynamic>?) ?? [];
                  final note = data['note'] ?? '';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1815),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF2C2420)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with big token number
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(token.toString(), style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: Color(0xFFFF7043), height: 1.0)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                  const SizedBox(height: 2),
                                  Text('$source • ₹$total', style: const TextStyle(color: Colors.white60, fontSize: 13)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('24m', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xFFFF9800)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text('MARK PAID', style: TextStyle(color: Color(0xFFFF9800), fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Items list with COOK / READY badges
                        ...items.map((item) {
                          final iname = item['name'] ?? 'Item';
                          final iqty = item['quantity'] ?? 1;
                          final isShake = iname.toString().contains('Shake') || iname.toString().contains('Mojito');
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('$iname × $iqty', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                                      const Text('Chicken', style: TextStyle(fontSize: 12, color: Color(0xFFFF7043))),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isShake ? Colors.green.withOpacity(0.15) : const Color(0xFF2C2420),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: isShake ? Colors.green : Colors.white24),
                                  ),
                                  child: Text(
                                    isShake ? 'READY ✓' : 'COOK',
                                    style: TextStyle(color: isShake ? Colors.greenAccent : Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        if (note.toString().isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF331E17),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('📝 (${note.toUpperCase()})', style: const TextStyle(color: Color(0xFFFF7043), fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ],
                        const SizedBox(height: 16),
                        // Action READY Bell Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF48B884),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              String next = selectedFilter == 'NEW'
                                  ? 'COOKING'
                                  : selectedFilter == 'COOKING'
                                      ? 'READY'
                                      : 'DONE';
                              firestore.collection('orders').doc(doc.id).update({'status': next});
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  selectedFilter == 'COOKING'
                                      ? 'READY '
                                      : selectedFilter == 'NEW'
                                          ? 'START COOKING '
                                          : 'SERVED ',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                                ),
                                const Text('🔔', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ],
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
// 2. COUNTER SCREEN (हूबहू स्क्रीन 2, 3, 4 जैसा)
// -------------------------------------------------------------
class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final Map<String, dynamic> currentOrder = {};
  int selectedChair = 1;
  final TextEditingController noteCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  bool isPaid = true;
  String selectedMeat = 'Chicken';
  final List<String> selectedAddons = [];

  final List<Map<String, dynamic>> menu = [
    {'name': '1 Feet • Normal', 'price': 240, 'chili': false},
    {'name': '1 Feet • BBQ', 'price': 240, 'chili': false},
    {'name': '1 Feet • Tandoori', 'price': 240, 'chili': false},
    {'name': '1 Feet • Peri Peri', 'price': 240, 'chili': true},
    {'name': '1 Feet • Jalapeno', 'price': 240, 'chili': true},
    {'name': '1 Feet • Jamaican Jerk', 'price': 240, 'chili': true},
    {'name': 'Normal Roll', 'price': 140, 'chili': false},
    {'name': 'BBQ Roll', 'price': 150, 'chili': false},
    {'name': 'Cheese Burst Roll', 'price': 150, 'chili': false},
  ];

  void _openCustomizer(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D1815),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setMState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
                  ),
                  const SizedBox(height: 14),
                  Text(item['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('₹${item['price']}', style: const TextStyle(color: Colors.white60, fontSize: 14)),
                  const SizedBox(height: 14),
                  const Text('Meat • Choose one • required', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Chicken'),
                        selected: selectedMeat == 'Chicken',
                        selectedColor: const Color(0xFF381F17),
                        onSelected: (s) => setMState(() => selectedMeat = 'Chicken'),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Beef +₹10'),
                        selected: selectedMeat == 'Beef',
                        selectedColor: const Color(0xFF381F17),
                        onSelected: (s) => setMState(() => selectedMeat = 'Beef'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text('Add-ons • Add extras', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      {'name': 'Full Meat', 'p': 40},
                      {'name': 'Extra Cheese', 'p': 20},
                      {'name': 'Extra Rumali', 'p': 10},
                      {'name': 'Mix', 'p': 20},
                    ].map((add) {
                      final title = "${add['name']} +₹${add['p']}";
                      final isSelected = selectedAddons.contains(title);
                      return FilterChip(
                        label: Text(title),
                        selected: isSelected,
                        selectedColor: const Color(0xFF381F17),
                        onSelected: (sel) {
                          setMState(() {
                            isSelected ? selectedAddons.remove(title) : selectedAddons.add(title);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5722),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        setState(() {
                          currentOrder['item'] = item['name'];
                          currentOrder['price'] = item['price'] + (selectedMeat == 'Beef' ? 10 : 0);
                        });
                        Navigator.pop(ctx);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Add to order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('₹${item['price'] + (selectedMeat == 'Beef' ? 10 : 0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Counter', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 6),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFFF9800), width: 2.5))),
                  child: const Text('NEW ORDER', style: TextStyle(color: Color(0xFFFF9800), fontWeight: FontWeight.bold, fontSize: 13)),
                ),
                const SizedBox(width: 24),
                const Text('PAYMENTS (10)', style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
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
              itemCount: menu.length,
              itemBuilder: (ctx, idx) {
                final m = menu[idx];
                final isSelected = currentOrder['item'] == m['name'];
                return GestureDetector(
                  onTap: () => _openCustomizer(m),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1815),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? const Color(0xFFFF5722) : const Color(0xFF2A221E)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(m['name'], maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text('₹${m['price']} +', style: const TextStyle(color: Color(0xFFFF9800), fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Bottom Ordering Drawer / Panel
          if (currentOrder.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Color(0xFF161210),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(top: BorderSide(color: Color(0xFF2C2420))),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${currentOrder['item']} ($selectedMeat) - 1 +", style: const TextStyle(color: Color(0xFFFF9800), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  // Chair Selector
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [1, 2, 3, 4, 5].map((c) {
                        final isSel = selectedChair == c;
                        return GestureDetector(
                          onTap: () => setState(() => selectedChair = c),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFF381F17) : const Color(0xFF1D1815),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isSel ? const Color(0xFFFF7043) : const Color(0xFF2A221E)),
                            ),
                            child: Row(children: [const Text('🪑 '), Text('$c')]),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: noteCtrl,
                    decoration: InputDecoration(
                      hintText: 'Note for kitchen (no mayo, cut in half...)',
                      filled: true,
                      fillColor: const Color(0xFF1D1815),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameCtrl,
                          decoration: InputDecoration(
                            hintText: 'Name / who',
                            filled: true,
                            fillColor: const Color(0xFF1D1815),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(color: const Color(0xFF1D1815), borderRadius: BorderRadius.circular(8)),
                        child: const Text('EAT\nHERE', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(() => isPaid = !isPaid),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isPaid ? const Color(0xFF1C3D2E) : const Color(0xFF1D1815),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isPaid ? Colors.green : Colors.white24),
                          ),
                          child: Text(isPaid ? 'PAID\n✓' : 'UNPAID', textAlign: TextAlign.center, style: TextStyle(color: isPaid ? Colors.greenAccent : Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5722),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () async {
                        final firestore = FirebaseFirestore.instance;
                        await firestore.collection('orders').add({
                          'token': (20 + (DateTime.now().second % 30)).toString(),
                          'customerName': nameCtrl.text.isEmpty ? 'Guest' : nameCtrl.text,
                          'source': 'Counter',
                          'table': '🪑 $selectedChair',
                          'items': [
                            {'name': "${currentOrder['item']} ($selectedMeat)", 'quantity': 1, 'price': currentOrder['price']}
                          ],
                          'note': noteCtrl.text,
                          'total': currentOrder['price'],
                          'status': 'NEW',
                          'paid': isPaid,
                          'createdAt': FieldValue.serverTimestamp(),
                        });
                        setState(() => currentOrder.clear());
                      },
                      child: Text('Place order • ₹${currentOrder['price']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 3. ORDERS HISTORY SCREEN (हूबहू स्क्रीन 5 जैसा)
// -------------------------------------------------------------
class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
                    decoration: BoxDecoration(color: const Color(0xFFFF5722), borderRadius: BorderRadius.circular(20)),
                    child: const Text('Today', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xFF1D1815), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF2C2420))),
                    child: const Text('Yesterday', style: TextStyle(color: Colors.white70)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text('22 orders • ₹3,000 collected • ₹4,230 still to collect', style: TextStyle(color: Colors.white54, fontSize: 13)),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('orders').orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFFF5722)));
              final orders = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: orders.length,
                itemBuilder: (ctx, idx) {
                  final d = orders[idx].data() as Map<String, dynamic>;
                  final token = d['token'] ?? (idx + 18).toString();
                  final name = d['customerName'] ?? 'Guest';
                  final total = d['total'] ?? 0;
                  final status = d['status'] ?? 'CONFIRMED';
                  final items = (d['items'] as List<dynamic>?) ?? [];
                  final firstItem = items.isNotEmpty ? items[0]['name'] : 'Normal Roll';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1815),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF261E1A)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(token.toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('🪑 $name', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 2),
                              Text('$firstItem ×1', style: const TextStyle(color: Colors.white60, fontSize: 13)),
                              const SizedBox(height: 2),
                              const Text('5:51 pm • Counter', style: TextStyle(color: Colors.white38, fontSize: 11)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: const Color(0xFF381F17), borderRadius: BorderRadius.circular(4)),
                              child: Text(status.toString(), style: const TextStyle(color: Color(0xFFFF9800), fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 6),
                            Text('₹$total', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('₹$total due', style: const TextStyle(color: Color(0xFFFF9800), fontSize: 11)),
                          ],
                        ),
                      ],
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
// 4. SETTINGS SCREEN
// -------------------------------------------------------------
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'Staff';

    return ListView(
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
          child: Row(
            children: [
              CircleAvatar(backgroundColor: Colors.white12, child: Text(email[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(email.split('@')[0], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('$email • Staff', style: const TextStyle(color: Colors.white54, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF261E1A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => FirebaseAuth.instance.signOut(),
          child: const Text('Sign out', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
