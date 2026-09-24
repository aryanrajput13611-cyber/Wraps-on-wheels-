import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const WrapsApp());

class WrapsApp extends StatelessWidget {
  const WrapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Wraps On Wheels",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(primary: Colors.orange),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, dynamic>> menu = const [
    {"name":"Chicken Shawarma Roll","price":140},
    {"name":"Beef Shawarma Roll","price":160},
    {"name":"1 Feet Chicken Shawarma","price":240},
    {"name":"1 Feet Beef Shawarma","price":250},
    {"name":"Chicken Loaded Fries","price":250},
    {"name":"Beef Loaded Fries","price":260},
  ];

  Future<void> order() async {
    final text = Uri.encodeComponent(
        "Wraps On Wheels Order\n\nPlease prepare my order.");
    final url = Uri.parse("https://wa.me/919310758470?text=$text");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wraps On Wheels"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.orange,
            ),
            child: const Center(
              child: Text(
                "WRAPS ON WHEELS\nAttakulangara",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text("All Wrapped Up",
              style: TextStyle(color: Colors.orange,fontSize: 20)),
          Expanded(
            child: ListView.builder(
              itemCount: menu.length,
              itemBuilder: (c,i){
                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    title: Text(menu[i]["name"]),
                    subtitle: Text("₹${menu[i]["price"]}"),
                    trailing: const Icon(Icons.add_shopping_cart,color: Colors.orange),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity,55),
              ),
              onPressed: order,
              child: const Text("Order on WhatsApp"),
            ),
          )
        ],
      ),
    );
  }
}
