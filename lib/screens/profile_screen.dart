import 'package:flutter/material.dart';
import 'login_screen.dart'; 
import 'orders_screen.dart'; // ҚОСЫЛДЫ
import 'address_screen.dart'; // ҚОСЫЛДЫ
import 'settings_screen.dart'; // ҚОСЫЛДЫ

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Жеке кабинет'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.orange,
                child: Text('СН', style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Сүндет Назар', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('sundet.nazar@gmail.com', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.history, color: Colors.orange),
                    title: const Text('Тапсырыстар тарихы'),
                    onTap: () {
                      // ТҮЗЕТІЛДІ: Тапсырыстар бетіне өту
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OrdersScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    // ТҮЗЕТІЛДІ: Белгіше Icons.home-ға ауыстырылды
                    leading: const Icon(Icons.home, color: Colors.orange), 
                    title: const Text('Адрес'),
                    onTap: () {
                      // ТҮЗЕТІЛДІ: Адрес бетіне өту
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddressScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.orange),
                    title: const Text('Баптаулар'),
                    onTap: () {
                      // ТҮЗЕТІЛДІ: Баптаулар бетіне өту
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Шығу', style: TextStyle(color: Colors.red, fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}