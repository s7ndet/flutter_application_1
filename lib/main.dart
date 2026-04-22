import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase пакеті қосылды
import 'firebase/firebase_options.dart'; // Конфигурация файлы қосылды
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/product_detail_screen.dart'; 
import 'models/data.dart';

// main функциясын асинхронды (async) қылдық
void main() async {
  // Flutter-дің ішкі жүйелерін дайындау
  WidgetsFlutterBinding.ensureInitialized();
  
  // Backend-ті (Firebase) іске қосу
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