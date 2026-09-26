import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC9jeLa4fifRH24dewecrUfv-tVoErIonc",
      appId: "1:891475422514:web:cb7dee5c5edf2e45e37b2b",
      messagingSenderId: "891475422514",
      projectId: "wraps-on-wheels",
      storageBucket: "wraps-on-wheels.firebasestorage.app",
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
      title: 'Wraps On Wheels',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF140D07),
        primaryColor: const Color(0xFFFF5722),
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
        if (snapshot.hasData) {
          return const MainNavigationScreen();
        }
        return const LoginPage();
      },
    );
  }
}

// ---------------- LOGIN PAGE ----------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An error occurred during login.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140D07),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.soup_kitchen,
                  size: 70,
                  color: Color(0xFFFF5722),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Wraps On Wheels',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Staff & Kitchen POS Login',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                if (_errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B1817),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Staff Email',
                    labelStyle: const TextStyle(color: Color(0xFFFF5722)),
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFFF5722)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFFF5722), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFFF5722), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5722),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- MAIN DASHBOARD SCREEN ----------------
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
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
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF140D07),
        selectedItemColor: const Color(0xFFFF5722),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.kitchen_outlined), label: 'Kitchen'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Counter'),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.build_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}

// ---------------- COUNTER SCREEN (POS & BILLING) ----------------
class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final Map<String, int> _cart = {};

  final List<Map<String, dynamic>> _menuItems = [
    {'name': 'Chicken Shawarma Wrap', 'price': 120, 'category': 'Wraps'},
    {'name': 'Paneer Tikka Wrap', 'price': 100, 'category': 'Wraps'},
    {'name': 'Egg Roll Wrap', 'price': 70, 'category': 'Wraps'},
    {'name': 'Fresh Orange Juice', 'price': 60, 'category': 'Juice'},
    {'name': 'Mango Smoothie Juice', 'price': 80, 'category': 'Juice'},
    {'name': 'Cold Coffee', 'price': 50, 'category': 'Beverages'},
  ];

  void _addItem(String name) {
    setState(() {
      _cart[name] = (_cart[name] ?? 0) + 1;
    });
  }

  void _removeItem(String name) {
    setState(() {
      if (_cart.containsKey(name)) {
        if (_cart[name]! > 1) {
          _cart[name] = _cart[name]! - 1;
        } else {
          _cart.remove(name);
        }
      }
    });
  }

  int get _totalAmount {
    int total = 0;
    _cart.forEach((name, qty) {
      final item = _menuItems.firstWhere((element) => element['name'] == name);
      total += (item['price'] as int) * qty;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter POS Billing'),
        backgroundColor: const Color(0xFF140D07),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: _menuItems.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.white12),
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final qty = _cart[item['name']] ?? 0;
                return ListTile(
                  title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('₹${item['price']}', style: const TextStyle(color: Color(0xFFFF5722))),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (qty > 0) ...[
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                          onPressed: () => _removeItem(item['name']),
                        ),
                        Text('$qty', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Color(0xFFFF5722)),
                        onPressed: () => _addItem(item['name']),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF1C130B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Bill:', style: TextStyle(color: Colors.grey)),
                    Text('₹$_totalAmount', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _totalAmount == 0
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Order Created & Sent to Kitchen!')),
                          );
                          setState(() => _cart.clear());
                        },
                  icon: const Icon(Icons.print),
                  label: const Text('Print Receipt'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5722),
                    foregroundColor: Colors.white,
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

// ---------------- KITCHEN SCREEN ----------------
class KitchenScreen extends StatelessWidget {
  const KitchenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kitchen Live Orders'), backgroundColor: const Color(0xFF140D07)),
      body: const Center(
        child: Text('No active kitchen orders right now.', style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}

// ---------------- ORDERS SCREEN ----------------
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History'), backgroundColor: const Color(0xFF140D07)),
      body: const Center(
        child: Text('Past completed orders will appear here.', style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}

// ---------------- SETTINGS SCREEN ----------------
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), backgroundColor: const Color(0xFF140D07)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF22160C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Text(user?.email?[0].toUpperCase() ?? 'U'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.email?.split('@').first ?? 'Staff', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('${user?.email ?? ''} • Staff', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async => await FirebaseAuth.instance.signOut(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22160C),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Sign out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
