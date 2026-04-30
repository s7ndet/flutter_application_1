import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/data.dart';
import 'login_screen.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({super.key});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  int _selectedIndex = 0;

  // БЕТТЕР ТІЗІМІ
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const AddProductPage(), // 1. Тауар қосу (сенің дизайның)
      const StatisticsPage(), // 2. Статистика беті
      const OrdersPage(),     // 3. Тапсырыстарды бақылау
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.orange.shade800,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: 'Тауар қосу'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Статистика'),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping_outlined), label: 'Тапсырыстар'),
        ],
      ),
    );
  }
}

// --- 1. ТАУАР ҚОСУ БЕТІ (СЕНІҢ КОДЫҢ) ---
class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _brandController = TextEditingController();
  final _descController = TextEditingController();

  void _addProduct() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      _showSnack('Аты мен бағасын толтырыңыз!', Colors.red.shade400);
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text,
        'brand': _brandController.text,
        'rating': 5.0,
        'images': [_imageController.text.isEmpty ? 'https://via.placeholder.com/150' : _imageController.text],
        'description': _descController.text.isEmpty ? 'Сатушы қосқан жаңа тауар' : _descController.text,
        'price': int.parse(_priceController.text),
        'timestamp': FieldValue.serverTimestamp(),
      });

      _showSnack('Тауар сәтті қосылды!', Colors.green.shade700);
      _clearAll();
    } catch (e) {
      _showSnack('Қате кетті: $e', Colors.red);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating));
  }

  void _clearAll() {
    _nameController.clear(); _priceController.clear(); _imageController.clear(); _brandController.clear(); _descController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сатушы панелі', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange.shade800,
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const LoginScreen())))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)]),
              child: Column(
                children: [
                  const Text('Жаңа тауар ақпараты', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _buildField(_brandController, 'Бренд', Icons.branding_watermark_outlined),
                  _buildField(_nameController, 'Модель аты', Icons.phone_android_outlined),
                  _buildField(_priceController, 'Бағасы (₸)', Icons.payments_outlined, isNum: true),
                  _buildField(_imageController, 'Сурет URL', Icons.link_rounded),
                  _buildField(_descController, 'Сипаттама', Icons.description_outlined, maxLines: 3),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addProduct,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade800, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      child: const Text('Дүкенге шығару', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, {bool isNum = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.orange.shade800),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}

// --- 2. СТАТИСТИКА БЕТІ (БӨЛЕК) ---
class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Статистика'), backgroundColor: Colors.orange.shade800, foregroundColor: Colors.white),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          double revenue = 0;
          for (var doc in snapshot.data!.docs) {
            revenue += (doc['price'] ?? 0).toDouble();
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _statCard("Жалпы табыс", "${revenue.toInt()} ₸", Colors.green, Icons.monetization_on),
                const SizedBox(height: 15),
                _statCard("Сатылған тауар", "${snapshot.data!.docs.length}", Colors.blue, Icons.shopping_bag),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statCard(String t, String v, Color c, IconData i) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: Row(
        children: [
          Icon(i, color: c, size: 40),
          const SizedBox(width: 20),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t, style: const TextStyle(color: Colors.grey)),
            Text(v, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ]),
        ],
      ),
    );
  }
}

// --- 3. ТАПСЫРЫСТАРДЫ БАҚЫЛАУ БЕТІ (БӨЛЕК) ---
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Тапсырыстар'), backgroundColor: Colors.orange.shade800, foregroundColor: Colors.white),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.data!.docs.isEmpty) return const Center(child: Text('Тапсырыстар жоқ'));

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var order = snapshot.data!.docs[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.person, color: Colors.white)),
                  title: Text(order['productName'] ?? 'Тауар'),
                  subtitle: Text('Мекенжай: ${order['address']}'),
                  trailing: Text('${order['price']} ₸', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}