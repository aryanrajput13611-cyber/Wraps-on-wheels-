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

// -------------------------------------------------------------
// AUTH GATE: चेक करेगा कि यूज़र पहले से लॉग इन है या नहीं
// -------------------------------------------------------------
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Login failed. Please check credentials.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF110D0B),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.soup_kitchen, size: 70, color: Color(0xFFFF5722)),
                const SizedBox(height: 16),
                const Text(
                  'Wraps On Wheels',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Staff & Kitchen POS Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white54),
                ),
                const SizedBox(height: 32),
                if (_errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.redAccent),
                    ),
                    child: Text(_errorMessage, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                  ),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Staff Email',
                    labelStyle: const TextStyle(color: Colors.white60),
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.white60),
                    filled: true,
                    fillColor: const Color(0xFF1D1815),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white60),
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.white60),
                    filled: true,
                    fillColor: const Color(0xFF1D1815),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5722),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Log In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kitchen', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
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
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: viewByOrders ? Colors.white : Colors.white70),
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
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: !viewByOrders ? Colors.white : Colors.white70),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                    border: Border(bottom: BorderSide(color: isSel ? const Color(0xFFFF9800) : Colors.transparent, width: 2.5)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: isSel ? const Color(0xFFFF9800) : Colors.white60, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
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
                  child: Text('No new orders. Ears open for the ding 🔔', style: TextStyle(color: Colors.white70, fontSize: 15)),
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
                                  style: const TextStyle(color: Color(0xFFFF7043), fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text('₹$total', style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text('Customer: $custName', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          if (dining.toString().isNotEmpty)
                            Text('Members: $dining', style: const TextStyle(fontSize: 13, color: Color(0xFFFF9800))),
                          if (note.toString().isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.amber.withOpacity(0.4)),
                              ),
                              child: Text('Note: $note', style: const TextStyle(fontSize: 13, color: Colors.amberAccent, fontStyle: FontStyle.italic)),
                            ),
                          ],
                          const Divider(color: Color(0xFF2C2420), height: 24),
                          ...items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${item['name']}  x${item['quantity']}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
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
                                onPressed: () => firestore.collection('orders').doc(doc.id).update({'status': 'CANCELLED'}),
                                child: const Text('Cancel Order', style: TextStyle(color: Colors.redAccent)),
                              ),
                              const SizedBox(width: 8),
                              if (selectedFilter != 'DONE')
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedFilter == 'NEW'
                                        ? const Color(0xFFFF5722)
                                        : const Color(0xFFFF9800),
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    String next = selectedFilter == 'NEW'
                                        ? 'COOKING'
                                        : selectedFilter == 'COOKING'
                                            ? 'READY'
                                            : 'DONE';
                                    firestore.collection('orders').doc(doc.id).update({'status': next});
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
// 2. COUNTER SCREEN
// -------------------------------------------------------------
class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Counter Screen", style: TextStyle(color: Colors.white70)));
  }
}

// -------------------------------------------------------------
// 3. ORDERS HISTORY SCREEN
// -------------------------------------------------------------
class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Orders History", style: TextStyle(color: Colors.white70)));
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Signed in as', style: TextStyle(fontSize: 13, color: Colors.white54)),
              const SizedBox(height: 8),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white12,
                    child: Text(email.isNotEmpty ? email[0].toUpperCase() : 'S', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
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
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            }
          },
          child: const Text('Sign out', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
