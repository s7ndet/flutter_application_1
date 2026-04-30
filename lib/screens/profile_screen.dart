import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ҚОСЫЛДЫ
import 'package:cloud_firestore/cloud_firestore.dart'; // ҚОСЫЛДЫ
import 'login_screen.dart'; 
import 'orders_screen.dart'; 
import 'address_screen.dart'; 
import 'settings_screen.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ағымдағы қолданушының ID-сін алу
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Жеке кабинет', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        // Firestore-дан қолданушы деректерін нақты уақытта (real-time) алу
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          String userName = "Жүктелуде...";
          String userEmail = user?.email ?? "Email табылмады";
          String initial = "U";

          if (snapshot.hasData && snapshot.data!.exists) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            userName = data['name'] ?? "Қолданушы";
            initial = userName.isNotEmpty ? userName[0].toUpperCase() : "U";
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                // Профиль суреті орнына аватар
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.orange,
                    child: Text(
                      initial,
                      style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Қолданушы аты
                Text(
                  userName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                // Қолданушы поштасы
                Text(
                  userEmail,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),
                
                // Меню бөлімі
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      _buildListTile(
                        icon: Icons.history,
                        title: 'Тапсырыстар тарихы',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const OrdersScreen()),
                        ),
                      ),
                      const Divider(height: 1),
                      _buildListTile(
                        icon: Icons.home_outlined,
                        title: 'Мекенжай',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddressScreen()),
                        ),
                      ),
                      const Divider(height: 1),
                      _buildListTile(
                        icon: Icons.settings_outlined,
                        title: 'Баптаулар',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsScreen()),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Шығу батырмасы
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut(); // Firebase-тен шығу
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                    child: const Text(
                      'Шығу',
                      style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // Меню элементтеріне арналған көмекші виджет
  Widget _buildListTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}