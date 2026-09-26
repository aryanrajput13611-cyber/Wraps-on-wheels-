import 'package:flutter/material.dart';

void main() {
  runApp(const FashionApp());
}

class FashionApp extends StatelessWidget {
  const FashionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fashion',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF8F5),
        primaryColor: const Color(0xFFE86B35),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE86B35)),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}

// ================= GLOBAL STATE & MODELS =================
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String image;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.description,
  });
}

class CartItem {
  final Product product;
  final String size;
  int quantity;

  CartItem({required this.product, required this.size, this.quantity = 1});
}

List<Product> globalProducts = [
  Product(
    id: "1",
    name: "Men's Pullover Hoodie",
    category: "Tops",
    price: 130.00,
    image: "https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=500&q=80",
    description: "Microsuede Cropped hoodie with elegant, soft finish. Pure cotton material designed for daily premium comfort.",
  ),
  Product(
    id: "2",
    name: "Classic Beige Sweatshirt",
    category: "Tops",
    price: 95.00,
    image: "https://images.unsplash.com/photo-1578768079052-aa76e520028b?w=500&q=80",
    description: "Relaxed fit round-neck warm pullover designed with high quality fleece lining.",
  ),
  Product(
    id: "3",
    name: "White Jordan Sneakers",
    category: "Footwear",
    price: 180.00,
    image: "https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=500&q=80",
    description: "Clean retro street style sneakers crafted with lightweight cushioning and soft rubber soles.",
  ),
];

List<Product> globalFavorites = [globalProducts[0]];
List<CartItem> globalCart = [
  CartItem(product: globalProducts[2], size: "M", quantity: 1),
  CartItem(product: globalProducts[0], size: "L", quantity: 1),
];

// ================= AUTH SCREENS (LOGIN, SIGNUP, FORGOT) =================
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isPhoneAuth = false;
  bool isPasswordVisible = false;

  final TextEditingController emailOrPhoneCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();

  void _submit() {
    if (emailOrPhoneCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }
    // Navigate to Dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  void _showForgotPasswordSheet() {
    final TextEditingController resetCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Reset Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Enter your registered email or phone to receive a reset code.", style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 16),
            TextField(
              controller: resetCtrl,
              decoration: InputDecoration(
                hintText: "Email or Phone Number",
                filled: true,
                fillColor: const Color(0xFFFBF8F5),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Reset link/code sent successfully!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE86B35),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Send Reset Instructions", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Brand Logo
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE86B35),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFFE86B35).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 16),
                const Text(
                  "FASHION",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.black87),
                ),
                Text(
                  isLogin ? "Welcome back! Login to explore trends" : "Create an account to start shopping & selling",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 28),

                // Toggle Login / Signup
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isLogin = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isLogin ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold, color: isLogin ? const Color(0xFFE86B35) : Colors.black54)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isLogin = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: !isLogin ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold, color: !isLogin ? const Color(0xFFE86B35) : Colors.black54)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Auth Mode (Email vs Phone)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => setState(() => isPhoneAuth = !isPhoneAuth),
                      icon: Icon(isPhoneAuth ? Icons.email_outlined : Icons.phone_android, size: 16, color: const Color(0xFFE86B35)),
                      label: Text(
                        isPhoneAuth ? "Use Email ID" : "Use Phone Number",
                        style: const TextStyle(color: Color(0xFFE86B35), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                if (!isLogin) ...[
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      hintText: "Full Name",
                      prefixIcon: const Icon(Icons.person_outline),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                TextField(
                  controller: emailOrPhoneCtrl,
                  keyboardType: isPhoneAuth ? TextInputType.phone : TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: isPhoneAuth ? "Phone Number (e.g. +91 9876543210)" : "Email ID",
                    prefixIcon: Icon(isPhoneAuth ? Icons.phone_outlined : Icons.alternate_email),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: passwordCtrl,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                      onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),

                if (isLogin) ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _showForgotPasswordSheet,
                      child: const Text("Forgot Password?", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 14),
                ],

                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE86B35),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      isLogin ? "Log In" : "Create Account",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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

// ================= MAIN NAVIGATION SCREEN =================
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(onTabSelect: (i) => setState(() => _currentIndex = i)),
      const SavedScreen(),
      const CartScreen(),
      ProfileScreen(onAddProduct: () => setState(() {})),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFFE86B35),
          unselectedItemColor: Colors.grey.shade400,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// ================= HOME SCREEN =================
class HomeScreen extends StatefulWidget {
  final Function(int) onTabSelect;
  const HomeScreen({super.key, required this.onTabSelect});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;
  final List<String> categories = ["All", "Tops", "Footwear", "Bottoms"];

  @override
  Widget build(BuildContext context) {
    final filtered = selectedCategoryIndex == 0
        ? globalProducts
        : globalProducts.where((p) => p.category == categories[selectedCategoryIndex]).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE86B35),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("FASHION", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1)),
                        Text("Good Morning • Discover Trends", style: TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none_outlined),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  hintText: "Search clothes, shoes...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Categories
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final isSelected = selectedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => selectedCategoryIndex = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFE86B35) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          if (!isSelected) BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 22),

            // Featured Card
            if (filtered.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductDetailScreen(product: filtered[0])),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF9E8B76),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.network(
                              filtered[0].image,
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (globalFavorites.contains(filtered[0])) {
                                    globalFavorites.remove(filtered[0]);
                                  } else {
                                    globalFavorites.add(filtered[0]);
                                  }
                                });
                              },
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white.withOpacity(0.85),
                                child: Icon(
                                  globalFavorites.contains(filtered[0]) ? Icons.favorite : Icons.favorite_border,
                                  size: 18,
                                  color: const Color(0xFFE86B35),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(filtered[0].name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(filtered[0].category, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                          Text("\$${filtered[0].price.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 22),

            // New Arrivals
            const Text("New arrivals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, idx) {
                final prod = filtered[idx];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductDetailScreen(product: prod)),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(prod.image, height: 130, width: double.infinity, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 8),
                        Text(prod.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text("\$${prod.price.toStringAsFixed(2)}", style: const TextStyle(color: Color(0xFFE86B35), fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ================= SAVED SCREEN (WISHLIST) =================
class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wishlist & Saved", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: globalFavorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                  SizedBox(height: 12),
                  Text("No saved items yet!", style: TextStyle(color: Colors.grey, fontSize: 15)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: globalFavorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = globalFavorites[index];
                return ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(item.image, width: 50, height: 50, fit: BoxFit.cover),
                  ),
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text("\$${item.price.toStringAsFixed(2)}", style: const TextStyle(color: Color(0xFFE86B35), fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () {
                      setState(() {
                        globalFavorites.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}

// ================= DETAILS & BUY SCREEN =================
class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedSize = "M";
  final List<String> sizes = ["S", "M", "L", "XL", "2XL"];

  void _showOrderSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle, color: Color(0xFFE86B35), size: 54),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Order Placed Successfully!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text("You purchased ${widget.product.name} (Size: $selectedSize) for \$${widget.product.price.toStringAsFixed(2)}.", textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE86B35)),
            child: const Text("Continue Shopping", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text("Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(
              globalFavorites.contains(widget.product) ? Icons.favorite : Icons.favorite_border,
              color: const Color(0xFFE86B35),
            ),
            onPressed: () {
              setState(() {
                if (globalFavorites.contains(widget.product)) {
                  globalFavorites.remove(widget.product);
                } else {
                  globalFavorites.add(widget.product);
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(color: const Color(0xFF9E8B76), borderRadius: BorderRadius.circular(24)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(widget.product.image, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(widget.product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        children: [
                          _buildColorCircle(const Color(0xFFE86B35)),
                          _buildColorCircle(Colors.blueGrey),
                          _buildColorCircle(Colors.black87),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text("\$${widget.product.price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, color: Color(0xFFE86B35), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 18),
                  const Text("Select Size", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  Row(
                    children: sizes.map((size) {
                      final isSelected = selectedSize == size;
                      return GestureDetector(
                        onTap: () => setState(() => selectedSize = size),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFE86B35) : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isSelected ? const Color(0xFFE86B35) : Colors.grey.shade300),
                          ),
                          child: Center(
                            child: Text(size, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 6),
                  Text(widget.product.description, style: TextStyle(color: Colors.grey.shade700, height: 1.5, fontSize: 13)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        globalCart.add(CartItem(product: widget.product, size: selectedSize));
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added to cart!")));
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE86B35)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Add to Cart", style: TextStyle(color: Color(0xFFE86B35), fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _showOrderSuccess,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE86B35),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Buy Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorCircle(Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      width: 16,
      height: 16,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ================= CART SCREEN =================
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double get subtotal => globalCart.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("My Cart", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: globalCart.isEmpty
          ? const Center(child: Text("Your cart is empty!"))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: globalCart.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = globalCart[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(item.product.image, width: 70, height: 70, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  const SizedBox(height: 4),
                                  Text("Size: ${item.size} • Cotton", style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                                  const SizedBox(height: 8),
                                  Text("\$${item.product.price.toStringAsFixed(2)}", style: const TextStyle(color: Color(0xFFE86B35), fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, size: 20, color: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      if (item.quantity > 1) {
                                        item.quantity--;
                                      } else {
                                        globalCart.removeAt(index);
                                      }
                                    });
                                  },
                                ),
                                Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle, size: 20, color: Color(0xFFE86B35)),
                                  onPressed: () => setState(() => item.quantity++),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Sub Total :", style: TextStyle(color: Colors.grey)),
                          Text("\$${subtotal.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Discount :", style: TextStyle(color: Colors.grey)),
                          Text("\$0.00", style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("\$${subtotal.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, color: Color(0xFFE86B35), fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Checkout Success"),
                                content: Text("Total payment of \$${subtotal.toStringAsFixed(2)} confirmed!"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() => globalCart.clear());
                                    },
                                    child: const Text("OK"),
                                  )
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE86B35),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Checkout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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

// ================= PROFILE & SELL PRODUCT SCREEN =================
class ProfileScreen extends StatelessWidget {
  final VoidCallback onAddProduct;
  const ProfileScreen({super.key, required this.onAddProduct});

  void _showSellDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final imgCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String category = "Tops";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  children: [
                    Icon(Icons.storefront, color: Color(0xFFE86B35)),
                    SizedBox(width: 8),
                    Text("Sell Your Fashion Item", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Product Title", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Price (\$)", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: imgCtrl,
                  decoration: const InputDecoration(
                    labelText: "Image URL (Unsplash or Web)",
                    hintText: "https://...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(labelText: "Category", border: OutlineInputBorder()),
                  items: ["Tops", "Footwear", "Bottoms"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setModalState(() => category = v!),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameCtrl.text.isNotEmpty && priceCtrl.text.isNotEmpty) {
                        globalProducts.insert(
                          0,
                          Product(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            name: nameCtrl.text,
                            category: category,
                            price: double.tryParse(priceCtrl.text) ?? 50.0,
                            image: imgCtrl.text.isNotEmpty
                                ? imgCtrl.text
                                : "https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=500&q=80",
                            description: descCtrl.text.isNotEmpty ? descCtrl.text : "Stylish modern fashion item.",
                          ),
                        );
                        Navigator.pop(context);
                        onAddProduct();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Item Listed For Sale Successfully!")));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE86B35)),
                    child: const Text("List Product", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFE86B35),
              child: Icon(Icons.person, color: Colors.white, size: 44),
            ),
            const SizedBox(height: 12),
            const Text("Fashion Member", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("+91 9876543210 • Verified Account", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 24),

            // Sell Button Feature
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFE86B35), Color(0xFFFF8A50)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.sell_outlined, color: Colors.white, size: 28),
                title: const Text("Sell Your Items", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text("Upload clothes to sell & earn", style: TextStyle(color: Colors.white70, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                onTap: () => _showSellDialog(context),
              ),
            ),
            const SizedBox(height: 16),

            // Options
            _buildProfileTile(Icons.shopping_bag_outlined, "My Orders"),
            _buildProfileTile(Icons.location_on_outlined, "Shipping Addresses"),
            _buildProfileTile(Icons.payment_outlined, "Payment Methods"),
            _buildProfileTile(Icons.settings_outlined, "Settings"),
            const SizedBox(height: 12),

            // Logout
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text("Log Out", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
