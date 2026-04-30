import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ҚОСЫЛДЫ
import 'package:firebase_auth/firebase_auth.dart'; // ҚОСЫЛДЫ

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  // Мәтінді енгізу контроллерлері
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserAddress(); // Экран ашылғанда ескі адресті жүктейміз
  }

  // Базадан бұрын сақталған адресті оқу
  Future<void> _loadUserAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data()!;
        setState(() {
          _cityController.text = data['city'] ?? '';
          _streetController.text = data['street'] ?? '';
          _houseController.text = data['house'] ?? '';
          _apartmentController.text = data['apartment'] ?? '';
        });
      }
    }
  }

  // Адресті Firebase-ке сақтау функциясы
  Future<void> _saveAddressToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'city': _cityController.text.trim(),
        'street': _streetController.text.trim(),
        'house': _houseController.text.trim(),
        'apartment': _apartmentController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Адрес сәтті сақталды!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Қате орын алды: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Менің адресім',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Жеткізу адресін енгізіңіз',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  
                  // Қала
                  _buildAddressField(
                    label: 'Қала',
                    controller: _cityController,
                    hint: 'Мысалы: Алматы',
                  ),
                  
                  // Көше
                  _buildAddressField(
                    label: 'Көше',
                    controller: _streetController,
                    hint: 'Мысалы: Абай даңғылы',
                  ),
                  
                  Row(
                    children: [
                      // Үй нөмірі
                      Expanded(
                        child: _buildAddressField(
                          label: 'Үй',
                          controller: _houseController,
                          hint: '10/1',
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Пәтер
                      Expanded(
                        child: _buildAddressField(
                          label: 'Пәтер / Кеңсе',
                          controller: _apartmentController,
                          hint: '45',
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Сақтау батырмасы
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _saveAddressToFirebase,
                      child: const Text(
                        'Адресті сақтау',
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Енгізу өрістерін құрастыратын көмекші виджет
  Widget _buildAddressField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    _streetController.dispose();
    _houseController.dispose();
    _apartmentController.dispose();
    super.dispose();
  }
}