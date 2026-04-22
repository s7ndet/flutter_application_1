import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Менің адресім'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Сақтау логикасы осында болады
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Адрес сәтті сақталды!')),
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  'Адресті сақтау',
                  style: TextStyle(fontSize: 18, color: Colors.white),
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
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
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