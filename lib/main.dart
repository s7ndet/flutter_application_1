import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Деректерді жіберу үшін керек
import 'firebase/firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';

// --- БАЗАҒА ЖҮКТЕУ ФУНКЦИЯСЫ (Осы жерге 33 тауарды қосып шық) ---
Future<void> uploadProducts() async {
  final collection = FirebaseFirestore.instance.collection('products');

  // Мына тізімге барлық тауарларыңды дәл осы форматта толтырып шық
  List<Map<String, dynamic>> products = [
    {
      "name": "iPhone 11",
      "brand": "Apple",
      "imageUrl": "https://example.com/iphone.png",
      "variants": [{"price": 255000, "ram": "4 GB", "storage": "64 GB"}]
    },
    {
      "name": "Vivo V20",
      "brand": "Vivo",
      "imageUrl": "https://example.com/vivo.png",
      "variants": [{"price": 120000, "ram": "8 GB", "storage": "128 GB"}]
    },
    // Қалған тауарларды осы жерге жалғастыр...
  ];

  for (var p in products) {
    await collection.add(p);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyTeamApp());
}

class MyTeamApp extends StatelessWidget {
  const MyTeamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sellpak Store',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoritesScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar-ға уақытша батырма қосылды
      appBar: AppBar(
        title: const Text("SellPak Store"),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () async {
              await uploadProducts();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Тауарлар базаға жүктелді!")),
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Басты'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Таңдаулы'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Себет'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}