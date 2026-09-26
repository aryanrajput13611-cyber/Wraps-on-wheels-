import 'package:flutter/material.dart';
​void main() {
runApp(const FashionApp());
}
​class FashionApp extends StatelessWidget {
const FashionApp({super.key});
​@override
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
​// ================= GLOBAL DATA & MODELS =================
class Product {
final String id;
final String name;
final String category;
final double price;
final String image;
final String description;
​Product({
required this.id,
required this.name,
required this.category,
required this.price,
required this.image,
required this.description,
});
}
​class CartItem {
final Product product;
final String size;
int quantity;
​CartItem({required this.product, required this.size, this.quantity = 1});
}
​class OrderItem {
final String orderId;
final String title;
final double price;
final String date;
final String status;
final int currentStep;
​OrderItem({
required this.orderId,
required this.title,
required this.price,
required this.date,
required this.status,
required this.currentStep,
});
}
​class AddressItem {
final String name;
final String address;
final String phone;
bool isSelected;
​AddressItem({
required this.name,
required this.address,
required this.phone,
this.isSelected = false,
});
}
​List<Product> globalProducts = [
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
Product(
id: "4",
name: "Designer UV Sunglasses",
category: "Accessories",
price: 45.00,
image: "https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=500&q=80",
description: "Polarized UV400 protective stylish unisex sunglasses.",
),
];
​List<Product> globalFavorites = [globalProducts[0]];
List<CartItem> globalCart = [
CartItem(product: globalProducts[2], size: "M", quantity: 1),
];
​List<OrderItem> globalOrders = [
OrderItem(
orderId: "ORD#9482",
title: "Men's Pullover Hoodie",
price: 130.00,
date: "26 Sep 2026",
status: "Out for Delivery",
currentStep: 3,
),
];
​List<AddressItem> globalAddresses = [
AddressItem(
name: "Sunan Kumar",
address: "Wraps on wheels, Attakulangara, Main Road, FPSRA87, Thiruvananthapuram",
phone: "9310758470",
isSelected: true,
),
];
​// Profile State
String userProfileName = "Sunan Kumar";
String userProfilePhone = "9310758470";
String userProfileEmail = "sunankumar77@gmail.com";
String userProfilePic = "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80";
String selectedPaymentMethod = "UPI (Google Pay / PhonePe)";
bool notificationEnabled = true;
String currentLanguage = "English";
​final List<String> defaultAvatars = [
"https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80",
"https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=300&q=80",
"https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&q=80",
"https://images.unsplash.com/photo-1517841905240-472988babdf9?w=300&q=80",
"https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&q=80",
"https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300&q=80",
];
​// ================= AUTH SCREEN (LOGIN, SIGNUP, PHONE/EMAIL, FORGOT) =================
class AuthScreen extends StatefulWidget {
const AuthScreen({super.key});
​@override
State<AuthScreen> createState() => _AuthScreenState();
}
​class _AuthScreenState extends State<AuthScreen> {
bool isLogin = true;
bool usePhoneAuth = false;
bool isPasswordVisible = false;
​final TextEditingController nameController = TextEditingController();
final TextEditingController inputController = TextEditingController(text: "sunankumar77@gmail.com");
final TextEditingController passwordController = TextEditingController(text: "815313Aam");
​void _submitAuth() {
final input = inputController.text.trim();
final pwd = passwordController.text.trim();
​if (input.isEmpty || pwd.isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("Please fill all required fields")),
);
return;
}
​if (!isLogin && nameController.text.trim().isNotEmpty) {
userProfileName = nameController.text.trim();
}
​if (input.contains('@')) {
userProfileEmail = input;
} else {
userProfilePhone = input;
}
​Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
);
}
​void _openForgotPassword() {
final resetCtrl = TextEditingController(text: inputController.text);
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
const Row(
children: [
Icon(Icons.lock_reset, color: Color(0xFFE86B35)),
SizedBox(width: 8),
Text("Forgot Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
],
),
const SizedBox(height: 8),
const Text(
"Enter your registered Email ID or Phone Number to receive a 6-digit OTP verification code.",
style: TextStyle(color: Colors.grey, fontSize: 13),
),
const SizedBox(height: 16),
TextField(
controller: resetCtrl,
decoration: InputDecoration(
hintText: "Email or Phone Number",
prefixIcon: const Icon(Icons.verified_user_outlined),
filled: true,
fillColor: const Color(0xFFFBF8F5),
border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
),
),
const SizedBox(height: 18),
SizedBox(
width: double.infinity,
height: 48,
child: ElevatedButton(
onPressed: () {
Navigator.pop(context);
_showOtpVerificationDialog(resetCtrl.text);
},
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFFE86B35),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
),
child: const Text("Send Reset OTP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
),
)
],
),
),
);
}
​void _showOtpVerificationDialog(String target) {
final otpCtrl = TextEditingController();
showDialog(
context: context,
builder: (c) => AlertDialog(
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
title: const Text("Enter 6-Digit OTP"),
content: Column(
mainAxisSize: MainAxisSize.min,
children: [
Text("OTP code has been sent to $target. Enter code (e.g. 123456):", style: const TextStyle(fontSize: 13, color: Colors.grey)),
const SizedBox(height: 14),
TextField(
controller: otpCtrl,
keyboardType: TextInputType.number,
maxLength: 6,
textAlign: TextAlign.center,
style: const TextStyle(letterSpacing: 6, fontWeight: FontWeight.bold, fontSize: 18),
decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "123456"),
),
],
),
actions: [
TextButton(onPressed: () => Navigator.pop(c), child: const Text("Cancel")),
ElevatedButton(
onPressed: () {
Navigator.pop(c);
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("OTP Verified! You can now login with your new password.")),
);
},
style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE86B35)),
child: const Text("Verify & Reset", style: TextStyle(color: Colors.white)),
)
],
),
);
}
​@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFFFBF8F5),
body: SafeArea(
child: Center(
child: SingleChildScrollView(
padding: const EdgeInsets.symmetric(horizontal: 26.0),
child: Column(
children: [
// App Logo
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
const SizedBox(height: 14),
const Text("FASHION", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 2)),
Text(
isLogin ? "Welcome back! Login to explore trends" : "Create account to buy & track orders",
style: const TextStyle(color: Colors.grey, fontSize: 13),
),
const SizedBox(height: 24),
​// Toggle Login / Sign Up
Container(
padding: const EdgeInsets.all(4),
decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(14)),
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
boxShadow: isLogin ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
),
child: Center(
child: Text(
"Login",
style: TextStyle(fontWeight: FontWeight.bold, color: isLogin ? const Color(0xFFE86B35) : Colors.black54),
),
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
boxShadow: !isLogin ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
),
child: Center(
child: Text(
"Sign Up",
style: TextStyle(fontWeight: FontWeight.bold, color: !isLogin ? const Color(0xFFE86B35) : Colors.black54),
),
),
),
),
),
],
),
),
const SizedBox(height: 14),
​// Toggle Email vs Phone Login
Row(
mainAxisAlignment: MainAxisAlignment.end,
children: [
TextButton.icon(
onPressed: () {
setState(() {
usePhoneAuth = !usePhoneAuth;
inputController.text = usePhoneAuth ? "9310758470" : "sunankumar77@gmail.com";
});
},
icon: Icon(usePhoneAuth ? Icons.email_outlined : Icons.phone_android, size: 16, color: const Color(0xFFE86B35)),
label: Text(
usePhoneAuth ? "Use Email ID" : "Use Phone Number",
style: const TextStyle(color: Color(0xFFE86B35), fontSize: 12, fontWeight: FontWeight.bold),
),
),
],
),
​// Sign Up Full Name Field
if (!isLogin) ...[
TextField(
controller: nameController,
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
​// Email or Phone input
TextField(
controller: inputController,
keyboardType: usePhoneAuth ? TextInputType.phone : TextInputType.emailAddress,
decoration: InputDecoration(
hintText: usePhoneAuth ? "Phone Number (e.g. 9310758470)" : "Email ID",
prefixIcon: Icon(usePhoneAuth ? Icons.phone_outlined : Icons.alternate_email),
filled: true,
fillColor: Colors.white,
border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
),
),
const SizedBox(height: 14),
​// Password input with visibility toggle
TextField(
controller: passwordController,
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
​// Forgot Password link
if (isLogin) ...[
Align(
alignment: Alignment.centerRight,
child: TextButton(
onPressed: _openForgotPassword,
child: const Text("Forgot Password?", style: TextStyle(color: Colors.grey, fontSize: 12)),
),
),
] else ...[
const SizedBox(height: 18),
],
​// Submit Button
SizedBox(
width: double.infinity,
height: 50,
child: ElevatedButton(
onPressed: _submitAuth,
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
​// ================= MAIN NAVIGATION =================
class MainNavigationScreen extends StatefulWidget {
const MainNavigationScreen({super.key});
​@override
State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}
​class _MainNavigationScreenState extends State<MainNavigationScreen> {
int _currentIndex = 0;
​@override
Widget build(BuildContext context) {
final List<Widget> pages = [
HomeScreen(onRefresh: () => setState(() {})),
const SavedScreen(),
CartScreen(onRefresh: () => setState(() {})),
ProfileSettingsScreen(onRefresh: () => setState(() {})),
];
​return Scaffold(
body: pages[_currentIndex],
bottomNavigationBar: Container(
decoration: BoxDecoration(
color: Colors.white,
borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, spreadRadius: 2)],
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
BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Account'),
],
),
),
);
}
}
​// ================= HOME SCREEN WITH SEARCH LENS =================
class HomeScreen extends StatefulWidget {
final VoidCallback onRefresh;
const HomeScreen({super.key, required this.onRefresh});
​@override
State<HomeScreen> createState() => _HomeScreenState();
}
​class _HomeScreenState extends State<HomeScreen> {
int selectedCategoryIndex = 0;
final List<String> categories = ["All", "Tops", "Footwear", "Accessories"];
​void _openSearchLens() {
showModalBottomSheet(
context: context,
shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
builder: (context) => Padding(
padding: const EdgeInsets.all(22),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
const Row(
children: [
Icon(Icons.center_focus_strong, color: Color(0xFFE86B35), size: 28),
SizedBox(width: 10),
Text("Search Lens - Visual Match", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
],
),
const SizedBox(height: 12),
const Text(
"Take a photo of any cloth, shoe or outfit from your camera or gallery to find matching items instantly.",
style: TextStyle(color: Colors.grey, fontSize: 13),
),
const SizedBox(height: 20),
Row(
children: [
Expanded(
child: ElevatedButton.icon(
onPressed: () {
Navigator.pop(context);
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("Camera Lens opened! Matching visual outfits...")),
);
},
icon: const Icon(Icons.camera_alt, color: Colors.white),
label: const Text("Camera Lens", style: TextStyle(color: Colors.white)),
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFFE86B35),
padding: const EdgeInsets.symmetric(vertical: 12),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
),
),
),
const SizedBox(width: 12),
Expanded(
child: OutlinedButton.icon(
onPressed: () {
Navigator.pop(context);
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("Gallery Photo picked! 4 matches found.")),
);
},
icon: const Icon(Icons.photo_library, color: Color(0xFFE86B35)),
label: const Text("Gallery", style: TextStyle(color: Color(0xFFE86B35))),
style: OutlinedButton.styleFrom(
padding: const EdgeInsets.symmetric(vertical: 12),
side: const BorderSide(color: Color(0xFFE86B35)),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
),
),
),
],
)
],
),
),
);
}
​@override
Widget build(BuildContext context) {
final filtered = selectedCategoryIndex == 0
? globalProducts
: globalProducts.where((p) => p.category == categories[selectedCategoryIndex]).toList();
​return SafeArea(
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
decoration: BoxDecoration(color: const Color(0xFFE86B35), borderRadius: BorderRadius.circular(14)),
child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
),
const SizedBox(width: 12),
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text("FASHION", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1)),
Text("Deliver to: $userProfileName", style: const TextStyle(color: Colors.grey, fontSize: 11)),
],
),
],
),
IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_outlined)),
],
),
const SizedBox(height: 16),
​// Search Bar with Visual Search Lens
Container(
padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)]),
child: Row(
children: [
const Icon(Icons.search, color: Colors.grey),
const SizedBox(width: 8),
const Expanded(
child: TextField(
decoration: InputDecoration(
border: InputBorder.none,
hintText: "Search shoes, hoodies, styles...",
hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
),
),
),
IconButton(
icon: const Icon(Icons.mic, color: Colors.grey, size: 20),
onPressed: () {},
),
IconButton(
icon: const Icon(Icons.center_focus_strong, color: Color(0xFFE86B35), size: 22),
tooltip: "Search Lens",
onPressed: _openSearchLens,
),
],
),
),
const SizedBox(height: 18),
​// Category Chips
SizedBox(
height: 36,
child: ListView.separated(
scrollDirection: Axis.horizontal,
itemCount: categories.length,
separatorBuilder: (_, __) => const SizedBox(width: 10),
itemBuilder: (context, index) {
final isSelected = selectedCategoryIndex == index;
return GestureDetector(
onTap: () => setState(() => selectedCategoryIndex = index),
child: Container(
padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
decoration: BoxDecoration(
color: isSelected ? const Color(0xFFE86B35) : Colors.white,
borderRadius: BorderRadius.circular(18),
),
child: Center(
child: Text(categories[index], style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 12)),
),
),
);
},
),
),
const SizedBox(height: 20),
​// Products Grid
const Text("Trending Clothes & Shoes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
onTap: () async {
await Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: prod)));
setState(() {});
},
child: Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(prod.image, height: 130, width: double.infinity, fit: BoxFit.cover)),
const SizedBox(height: 8),
Text(prod.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
const SizedBox(height: 4),
Text("$${prod.price.toStringAsFixed(2)}", style: const TextStyle(color: Color(0xFFE86B35), fontWeight: FontWeight.bold, fontSize: 14)),
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
​// ================= SAVED SCREEN =================
class SavedScreen extends StatefulWidget {
const SavedScreen({super.key});
​@override
State<SavedScreen> createState() => _SavedScreenState();
}
​class SavedScreenState extends State<SavedScreen> {
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Wishlist & Saved", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
body: globalFavorites.isEmpty
? const Center(child: Text("No saved items yet!", style: TextStyle(color: Colors.grey)))
: ListView.separated(
padding: const EdgeInsets.all(16),
itemCount: globalFavorites.length,
separatorBuilder: (, __) => const SizedBox(height: 12),
itemBuilder: (context, index) {
final item = globalFavorites[index];
return ListTile(
tileColor: Colors.white,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(item.image, width: 50, height: 50, fit: BoxFit.cover)),
title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
subtitle: Text("$${item.price.toStringAsFixed(2)}", style: const TextStyle(color: Color(0xFFE86B35), fontWeight: FontWeight.bold)),
trailing: IconButton(
icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
onPressed: () => setState(() => globalFavorites.removeAt(index)),
),
);
},
),
);
}
}
​// ================= DETAILS SCREEN =================
class ProductDetailScreen extends StatefulWidget {
final Product product;
const ProductDetailScreen({super.key, required this.product});
​@override
State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}
​class _ProductDetailScreenState extends State<ProductDetailScreen> {
String selectedSize = "M";
final List<String> sizes = ["S", "M", "L", "XL", "2XL"];
​void _buyNow() {
final newOrder = OrderItem(
orderId: "ORD#{DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
title: "{widget.product.name} (Size $selectedSize)",
price: widget.product.price,
date: "Today",
status: "Order Placed",
currentStep: 1,
);
globalOrders.insert(0, newOrder);
​Navigator.push(
context,
MaterialPageRoute(builder: (context) => OrderTrackingScreen(order: newOrder)),
);
}
​@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
backgroundColor: Colors.transparent,
elevation: 0,
leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18), onPressed: () => Navigator.pop(context)),
centerTitle: true,
title: const Text("Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
),
body: Column(
children: [
Expanded(
child: SingleChildScrollView(
padding: const EdgeInsets.symmetric(horizontal: 20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.network(widget.product.image, height: 280, width: double.infinity, fit: BoxFit.cover)),
const SizedBox(height: 20),
Text(widget.product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
const SizedBox(height: 4),
Text("$${widget.product.price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, color: Color(0xFFE86B35), fontWeight: FontWeight.bold)),
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
child: Center(child: Text(size, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold))),
),
);
}).toList(),
),
const SizedBox(height: 20),
const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
const SizedBox(height: 6),
Text(widget.product.description, style: TextStyle(color: Colors.grey.shade700, height: 1.5, fontSize: 13)),
],
),
),
),
Container(
padding: const EdgeInsets.all(20),
decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
child: Row(
children: [
Expanded(
child: OutlinedButton(
onPressed: () {
globalCart.add(CartItem(product: widget.product, size: selectedSize));
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
onPressed: _buyNow,
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
}
​// ================= LIVE ORDER TRACKING SCREEN =================
class OrderTrackingScreen extends StatelessWidget {
final OrderItem order;
const OrderTrackingScreen({super.key, required this.order});
​@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text("Track ${order.orderId}"),
centerTitle: true,
leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
),
body: SingleChildScrollView(
padding: const EdgeInsets.all(20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
child: Row(
children: [
const CircleAvatar(
backgroundColor: Color(0xFFFFF3ED),
radius: 28,
child: Icon(Icons.local_shipping_outlined, color: Color(0xFFE86B35), size: 30),
),
const SizedBox(width: 16),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(order.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
const SizedBox(height: 4),
Text("Status: ${order.status}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
Text("Arriving by tomorrow evening", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
],
),
),
],
),
),
const SizedBox(height: 24),
const Text("Delivery Steps", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
const SizedBox(height: 16),
_buildTrackingStep("Order Confirmed", "Item received by store", true),
_buildTrackingStep("Shipped from Warehouse", "Courier picked up your package", order.currentStep >= 2),
_buildTrackingStep("Out for Delivery", "Delivery executive is arriving near your address", order.currentStep >= 3),
_buildTrackingStep("Delivered", "Delivered at your doorstep", order.currentStep >= 4, isLast: true),
],
),
),
);
}
​Widget _buildTrackingStep(String title, String desc, bool isCompleted, {bool isLast = false}) {
return Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Column(
children: [
CircleAvatar(
radius: 12,
backgroundColor: isCompleted ? const Color(0xFFE86B35) : Colors.grey.shade300,
child: Icon(Icons.check, size: 14, color: isCompleted ? Colors.white : Colors.grey),
),
if (!isLast)
Container(width: 2, height: 44, color: isCompleted ? const Color(0xFFE86B35) : Colors.grey.shade300),
],
),
const SizedBox(width: 14),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isCompleted ? Colors.black87 : Colors.grey)),
Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
const SizedBox(height: 14),
],
),
),
],
);
}
}
​// ================= CART SCREEN =================
class CartScreen extends StatefulWidget {
final VoidCallback onRefresh;
const CartScreen({super.key, required this.onRefresh});
​@override
State<CartScreen> createState() => _CartScreenState();
}
​class _CartScreenState extends State<CartScreen> {
double get subtotal => globalCart.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
​@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, centerTitle: true, title: const Text("My Cart", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
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
decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
child: Row(
children: [
ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(item.product.image, width: 70, height: 70, fit: BoxFit.cover)),
const SizedBox(width: 14),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
Text("Size: {item.size}", style: const TextStyle(color: Colors.grey, fontSize: 11)),
const SizedBox(height: 6),
Text("\${item.product.price.toStringAsFixed(2)}", style: const TextStyle(color: Color(0xFFE86B35), fontWeight: FontWeight.bold)),
],
),
),
Row(
children: [
IconButton(
icon: const Icon(Icons.remove_circle_outline, size: 20, color: Colors.grey),
onPressed: () => setState(() {
if (item.quantity > 1) {
item.quantity--;
} else {
globalCart.removeAt(index);
}
}),
),
Text("{item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
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
decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
child: Column(
children: [
Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
const Text("Payment Method:", style: TextStyle(color: Colors.grey)),
Text(selectedPaymentMethod, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFE86B35))),
]),
const SizedBox(height: 6),
Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
const Text("Total :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
Text("\${subtotal.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, color: Color(0xFFE86B35), fontWeight: FontWeight.bold)),
]),
const SizedBox(height: 16),
SizedBox(
width: double.infinity,
height: 48,
child: ElevatedButton(
onPressed: () {
final newOrder = OrderItem(
orderId: "ORD#{DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
title: "{globalCart.length} Fashion Items",
price: subtotal,
date: "Today",
status: "Processing",
currentStep: 2,
);
globalOrders.insert(0, newOrder);
setState(() => globalCart.clear());
widget.onRefresh();
​Navigator.push(context, MaterialPageRoute(builder: (c) => OrderTrackingScreen(order: newOrder)));
},
style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE86B35), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
child: const Text("Pay & Place Order", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
​// ================= FLIPKART-STYLE PROFILE & SETTINGS =================
class ProfileSettingsScreen extends StatefulWidget {
final VoidCallback onRefresh;
const ProfileSettingsScreen({super.key, required this.onRefresh});
​@override
State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}
​class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
// USER CUSTOM PHOTO / AVATAR PICKER
void _editProfileSheet() {
final nameCtrl = TextEditingController(text: userProfileName);
final phoneCtrl = TextEditingController(text: userProfilePhone);
final emailCtrl = TextEditingController(text: userProfileEmail);
final photoUrlCtrl = TextEditingController(text: userProfilePic);
​showModalBottomSheet(
context: context,
isScrollControlled: true,
backgroundColor: Colors.white,
shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
builder: (context) => StatefulBuilder(
builder: (context, setSheetState) => Padding(
padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
child: SingleChildScrollView(
child: Column(
mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Row(
children: [
Icon(Icons.edit_note, color: Color(0xFFE86B35)),
SizedBox(width: 8),
Text("Edit Profile & Photo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
],
),
const SizedBox(height: 14),
​// Choose Avatar
const Text("Pick Avatar or Enter Custom Photo Link:", style: TextStyle(fontSize: 12, color: Colors.grey)),
const SizedBox(height: 8),
SizedBox(
height: 65,
child: ListView.separated(
scrollDirection: Axis.horizontal,
itemCount: defaultAvatars.length,
separatorBuilder: (_, __) => const SizedBox(width: 10),
itemBuilder: (context, idx) {
final pic = defaultAvatars[idx];
final isSelected = userProfilePic == pic;
return GestureDetector(
onTap: () {
setSheetState(() {
userProfilePic = pic;
photoUrlCtrl.text = pic;
});
setState(() {});
},
child: Container(
decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? const Color(0xFFE86B35) : Colors.transparent, width: 3)),
child: CircleAvatar(radius: 28, backgroundImage: NetworkImage(pic)),
),
);
},
),
),
const SizedBox(height: 12),
​// Custom Photo Link
TextField(
controller: photoUrlCtrl,
decoration: const InputDecoration(
labelText: "Custom Photo URL (Google / Cloud Link)",
prefixIcon: Icon(Icons.link),
border: OutlineInputBorder(),
),
onChanged: (val) {
if (val.isNotEmpty) {
setSheetState(() => userProfilePic = val);
}
},
),
const SizedBox(height: 12),
TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder())),
const SizedBox(height: 12),
TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "Phone Number", border: OutlineInputBorder())),
const SizedBox(height: 12),
TextField(controller: emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: "Email ID", border: OutlineInputBorder())),
const SizedBox(height: 18),
SizedBox(
width: double.infinity,
height: 48,
child: ElevatedButton(
onPressed: () {
setState(() {
userProfileName = nameCtrl.text;
userProfilePhone = phoneCtrl.text;
userProfileEmail = emailCtrl.text;
if (photoUrlCtrl.text.isNotEmpty) userProfilePic = photoUrlCtrl.text;
});
widget.onRefresh();
Navigator.pop(context);
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile updated successfully!")));
},
style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE86B35)),
child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
),
),
],
),
),
),
),
);
}
​// PAYMENT METHODS: CASH, UPI, CARD
void _openPaymentMethods() {
showModalBottomSheet(
context: context,
shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
builder: (context) => StatefulBuilder(
builder: (context, setPaymentState) => Padding(
padding: const EdgeInsets.all(20),
child: Column(
mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text("Select Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
const SizedBox(height: 14),
​// 1. CASH / COD
RadioListTile<String>(
value: "CASH (Cash on Delivery)",
groupValue: selectedPaymentMethod,
title: const Text("CASH (Cash on Delivery)", style: TextStyle(fontWeight: FontWeight.bold)),
subtitle: const Text("Pay in cash when order is delivered"),
secondary: const Icon(Icons.money, color: Colors.green),
activeColor: const Color(0xFFE86B35),
onChanged: (val) {
setPaymentState(() => selectedPaymentMethod = val!);
setState(() {});
Navigator.pop(context);
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment set to: $val")));
},
),
​// 2. UPI
RadioListTile<String>(
value: "UPI (Google Pay / PhonePe / Paytm)",
groupValue: selectedPaymentMethod,
title: const Text("UPI (Google Pay / PhonePe / Paytm)", style: TextStyle(fontWeight: FontWeight.bold)),
subtitle: const Text("Pay directly from bank using UPI PIN"),
secondary: const Icon(Icons.account_balance_wallet, color: Colors.blue),
activeColor: const Color(0xFFE86B35),
onChanged: (val) {
setPaymentState(() => selectedPaymentMethod = val!);
setState(() {});
Navigator.pop(context);
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment set to: $val")));
},
),
​// 3. CARD
RadioListTile<String>(
value: "CARD (Debit / Credit / RuPay / Visa)",
groupValue: selectedPaymentMethod,
title: const Text("CARD (Credit / Debit Card)", style: TextStyle(fontWeight: FontWeight.bold)),
subtitle: const Text("Visa, MasterCard, RuPay Card"),
secondary: const Icon(Icons.credit_card, color: Colors.deepPurple),
activeColor: const Color(0xFFE86B35),
onChanged: (val) {
setPaymentState(() => selectedPaymentMethod = val!);
setState(() {});
Navigator.pop(context);
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment set to: $val")));
},
),
],
),
),
),
);
}
​// CUSTOMER SUPPORT (EMAIL ✉️, PHONE, CHAT)
void _openCustomerSupport() {
showModalBottomSheet(
context: context,
shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
builder: (context) => Padding(
padding: const EdgeInsets.all(20),
child: Column(
mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Row(
children: [
Icon(Icons.headset_mic_outlined, color: Color(0xFFE86B35)),
SizedBox(width: 8),
Text("Customer Support & Helpdesk", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
],
),
const SizedBox(height: 14),
​// Email Support ✉️
ListTile(
leading: const CircleAvatar(backgroundColor: Color(0xFFFFF3ED), child: Icon(Icons.email_outlined, color: Color(0xFFE86B35))),
title: const Text("Email Support ✉️", style: TextStyle(fontWeight: FontWeight.bold)),
subtitle: const Text("support@fashionstore.com"),
trailing: const Icon(Icons.send, size: 18, color: Color(0xFFE86B35)),
onTap: () {
Navigator.pop(context);
showDialog(
context: context,
builder: (c) => AlertDialog(
title: const Text("Send Support Email ✉️"),
content: const Text("Support ticket generated!\n\nEmail will be addressed to: support@fashionstore.com\nResponse time: Within 2 hours."),
actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text("OK"))],
),
);
},
),
​// Phone Helpline
ListTile(
leading: const CircleAvatar(backgroundColor: Color(0xFFEDF4FE), child: Icon(Icons.phone_in_talk, color: Colors.blueAccent)),
title: const Text("Helpline Calling", style: TextStyle(fontWeight: FontWeight.bold)),
subtitle: const Text("+91 9310758470 (Mon-Sat 9AM-8PM)"),
trailing: const Icon(Icons.call, size: 18, color: Colors.blueAccent),
onTap: () {
Navigator.pop(context);
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("Calling support helpline +91 9310758470...")),
);
},
),
​// FAQs
ListTile(
leading: const CircleAvatar(backgroundColor: Color(0xFFE8F5E9), child: Icon(Icons.help_center_outlined, color: Colors.green)),
title: const Text("Order & Return FAQs", style: TextStyle(fontWeight: FontWeight.bold)),
subtitle: const Text("7-day return policy and refund guidelines"),
onTap: () {
Navigator.pop(context);
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("Returns: 7 days free replacement on all fashion items.")),
);
},
),
],
),
),
);
}
​// ADDRESS MANAGEMENT
void _openAddresses() {
final nameCtrl = TextEditingController();
final addrCtrl = TextEditingController();
final phCtrl = TextEditingController();
​Navigator.push(
context,
MaterialPageRoute(
builder: (context) => StatefulBuilder(
builder: (context, setAddrState) => Scaffold(
appBar: AppBar(title: const Text("Saved addresses"), centerTitle: true),
body: Padding(
padding: const EdgeInsets.all(16),
child: Column(
children: [
Container(
decoration: BoxDecoration(color: const Color(0xFFEDF4FE), borderRadius: BorderRadius.circular(12)),
child: ListTile(
leading: const Icon(Icons.my_location, color: Colors.blueAccent),
title: const Text("Use my current location", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 14)),
subtitle: const Text("Auto-detect GPS address", style: TextStyle(fontSize: 11)),
trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blueAccent),
onTap: () {
setAddrState(() {
globalAddresses.insert(
0,
AddressItem(
name: userProfileName,
address: "Current GPS: Main Road, Attakulangara, Thiruvananthapuram",
phone: userProfilePhone,
isSelected: true,
),
);
for (int i = 1; i < globalAddresses.length; i++) {
globalAddresses[i].isSelected = false;
}
});
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("GPS Location auto-filled!")));
},
),
),
const SizedBox(height: 12),
Container(
decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
child: ListTile(
leading: const Icon(Icons.add, color: Colors.blueAccent),
title: const Text("+ Add New Address", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 14)),
trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
onTap: () {
showDialog(
context: context,
builder: (c) => AlertDialog(
title: const Text("Add New Address"),
content: Column(
mainAxisSize: MainAxisSize.min,
children: [
TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Receiver Name")),
TextField(controller: phCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "Phone Number")),
TextField(controller: addrCtrl, maxLines: 2, decoration: const InputDecoration(labelText: "Full Address with Pincode")),
],
),
actions: [
TextButton(onPressed: () => Navigator.pop(c), child: const Text("Cancel")),
ElevatedButton(
onPressed: () {
if (nameCtrl.text.isNotEmpty && addrCtrl.text.isNotEmpty) {
setAddrState(() {
globalAddresses.add(
AddressItem(name: nameCtrl.text, address: addrCtrl.text, phone: phCtrl.text.isNotEmpty ? phCtrl.text : userProfilePhone),
);
});
Navigator.pop(c);
}
},
style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE86B35)),
child: const Text("Save", style: TextStyle(color: Colors.white)),
)
],
),
);
},
),
),
const SizedBox(height: 16),
const Align(alignment: Alignment.centerLeft, child: Text("Saved Addresses", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
const SizedBox(height: 10),
Expanded(
child: ListView.separated(
itemCount: globalAddresses.length,
separatorBuilder: (_, __) => const SizedBox(height: 10),
itemBuilder: (context, idx) {
final addr = globalAddresses[idx];
return Container(
decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: addr.isSelected ? const Color(0xFFE86B35) : Colors.transparent, width: 1.5)),
child: ListTile(
leading: Icon(Icons.home_work_outlined, color: addr.isSelected ? const Color(0xFFE86B35) : Colors.grey),
title: Text(addr.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
subtitle: Text("${addr.address}\n📞 ${addr.phone}", style: const TextStyle(fontSize: 12)),
trailing: IconButton(
icon: Icon(addr.isSelected ? Icons.check_circle : Icons.radio_button_unchecked, color: addr.isSelected ? const Color(0xFFE86B35) : Colors.grey),
onPressed: () {
setAddrState(() {
for (var a in globalAddresses) {
a.isSelected = false;
}
addr.isSelected = true;
});
},
),
),
);
},
),
),
],
),
),
),
),
),
);
}
​// MY ORDERS
void openMyOrders() {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => Scaffold(
appBar: AppBar(title: const Text("My Orders"), centerTitle: true),
body: globalOrders.isEmpty
? const Center(child: Text("No orders placed yet!"))
: ListView.separated(
padding: const EdgeInsets.all(16),
itemCount: globalOrders.length,
separatorBuilder: (, __) => const SizedBox(height: 12),
itemBuilder: (context, i) {
final ord = globalOrders[i];
return GestureDetector(
onTap: () {
Navigator.push(context, MaterialPageRoute(builder: (c) => OrderTrackingScreen(order: ord)));
},
child: Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(ord.orderId, style: const TextStyle(fontWeight: FontWeight.bold)),
Text(ord.title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
Text(ord.date, style: const TextStyle(fontSize: 11, color: Colors.black45)),
],
),
Column(
crossAxisAlignment: CrossAxisAlignment.end,
children: [
Text("$${ord.price.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE86B35))),
const SizedBox(height: 4),
Container(
padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(6)),
child: Row(
children: [
Text(ord.status, style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
const Icon(Icons.arrow_forward_ios, size: 10, color: Colors.green),
],
),
),
],
),
],
),
),
);
},
),
),
),
);
}
​@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Account Settings"), centerTitle: true, backgroundColor: Colors.transparent, elevation: 0),
body: SingleChildScrollView(
padding: const EdgeInsets.all(18),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// User Header Card
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
child: Row(
children: [
GestureDetector(
onTap: _editProfileSheet,
child: Stack(
children: [
CircleAvatar(
radius: 36,
backgroundColor: const Color(0xFFE86B35),
backgroundImage: NetworkImage(userProfilePic),
),
Positioned(
bottom: 0,
right: 0,
child: Container(
padding: const EdgeInsets.all(4),
decoration: const BoxDecoration(color: Color(0xFFE86B35), shape: BoxShape.circle),
child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
),
),
],
),
),
const SizedBox(width: 14),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(userProfileName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
Text(userProfileEmail, style: const TextStyle(color: Colors.grey, fontSize: 12)),
Text("+91 $userProfilePhone", style: const TextStyle(color: Colors.grey, fontSize: 12)),
],
),
),
IconButton(
icon: const Icon(Icons.edit, color: Color(0xFFE86B35)),
onPressed: _editProfileSheet,
)
],
),
),
const SizedBox(height: 20),
​// Profile Settings Section
const Text("Profile Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
const SizedBox(height: 8),
_buildTile(Icons.person_outline, "Edit profile", _editProfileSheet),
_buildTile(Icons.location_on_outlined, "Saved addresses", _openAddresses),
_buildTile(Icons.local_shipping_outlined, "My Orders (Live Tracking)", _openMyOrders),
_buildTile(Icons.translate, "Change language ($currentLanguage)", () {
setState(() {
currentLanguage = currentLanguage == "English" ? "Hindi" : "English";
});
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Language changed to $currentLanguage")));
}),
_buildTile(Icons.notifications_none, "Notification settings", () {
setState(() => notificationEnabled = !notificationEnabled);
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Notifications ${notificationEnabled ? 'Enabled' : 'Disabled'}")));
}),
​const SizedBox(height: 20),
// Payments & Wallets Section
const Text("Payments & Wallets", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
const SizedBox(height: 8),
_buildTile(Icons.payment_outlined, "Payment Methods (CASH / UPI / CARD)", _openPaymentMethods, subtitle: selectedPaymentMethod),
​const SizedBox(height: 20),
// Customer Support Section
const Text("Customer Support & Help", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
const SizedBox(height: 8),
_buildTile(Icons.mark_email_read_outlined, "Customer Support (Email ✉️ & Helpline)", _openCustomerSupport),
​const SizedBox(height: 16),
// Logout
ListTile(
tileColor: Colors.white,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
leading: const Icon(Icons.logout, color: Colors.redAccent),
title: const Text("Log Out", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
onTap: () {
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
},
),
const SizedBox(height: 20),
],
),
),
);
}
​Widget _buildTile(IconData icon, String title, VoidCallback onTap, {String? subtitle}) {
return Container(
margin: const EdgeInsets.only(bottom: 8),
decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
child: ListTile(
leading: Icon(icon, color: Colors.black87),
title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFFE86B35))) : null,
trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
onTap: onTap,
),
);
}
}
