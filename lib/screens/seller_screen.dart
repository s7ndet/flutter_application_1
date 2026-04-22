import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import '../models/data.dart';
import 'login_screen.dart'; // Импорт дұрыс тұрғанына көз жеткіз

class SellerScreen extends StatefulWidget {
  const SellerScreen({super.key});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _brandController = TextEditingController();
  final _descController = TextEditingController();

  void _addProduct() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Аты мен бағасын толтырыңыз!', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text,
        'brand': _brandController.text,
        'rating': 5.0,
        'images': [
          _imageController.text.isEmpty 
              ? 'https://via.placeholder.com/150' 
              : _imageController.text
        ],
        'description': _descController.text.isEmpty 
            ? 'Сатушы қосқан жаңа тауар' 
            : _descController.text,
        'price': int.parse(_priceController.text),
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        phoneProducts.insert(0, {
          'name': _nameController.text,
          'brand': _brandController.text,
          'rating': 5.0,
          'images': [_imageController.text.isEmpty ? 'https://via.placeholder.com/150' : _imageController.text],
          'description': _descController.text.isEmpty ? 'Сатушы қосқан жаңа тауар' : _descController.text,
          'specs': {'screen': '6.1" OLED', 'cpu': 'Standard', 'battery': '4000 mAh', 'camera': 'Default'},
          'variants': [{'ram': 'Standard', 'price': int.parse(_priceController.text)}],
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Тауар Backend-ке сәтті қосылды!'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      _nameController.clear();
      _priceController.clear();
      _imageController.clear();
      _brandController.clear();
      _descController.clear();
      FocusScope.of(context).unfocus();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Қате кетті: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Сатушы панелі', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)), 
        backgroundColor: Colors.orange.shade800,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              // Navigator жақшалары мен параметрлері түзетілді
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()), 
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: Column(
                children: [
                  const Text('Жаңа тауар ақпараты', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade800,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 4,
                      ),
                      child: const Text('Дүкенге шығару', 
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.orange.shade700, Colors.orange.shade900]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Дүкендегі тауар саны:', 
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    child: Text('${phoneProducts.length}', 
                      style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
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
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.orange.shade800, size: 22),
          filled: true,
          fillColor: Colors.grey.shade50,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange.shade800, width: 1.5),
          ),
        ),
      ),
    );
  }
}