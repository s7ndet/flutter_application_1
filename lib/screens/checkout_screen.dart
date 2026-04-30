import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutScreen extends StatefulWidget {
  final int total;
  const CheckoutScreen({super.key, required this.total});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isCVVHidden = true;
  String? selectedCity;

  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _entranceController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  final List<String> cities = [
    'Алматы', 'Астана', 'Шымкент', 'Ақтөбе', 'Қарағанды', 
    'Тараз', 'Павлодар', 'Өскемен', 'Семей', 'Қостанай', 'Орал'
  ];

  Future<void> _processOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // 1. Себеттегі таңдалған тауарларды алу
      var cartSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .where('isSelected', isEqualTo: true)
          .get();

      if (cartSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Себетте таңдалған тауар жоқ!')),
        );
        return;
      }

      // 2. Ортақ тапсырыс ID-ін жасау (бірнеше тауарды бір топқа біріктіру үшін)
      String orderGroupId = DateTime.now().millisecondsSinceEpoch.toString();

      // 3. Тапсырыстарды 'orders' коллекциясына жазу
      for (var doc in cartSnapshot.docs) {
        var itemData = doc.data();
        
        await FirebaseFirestore.instance.collection('orders').add({
          'orderId': orderGroupId,
          'userId': user.uid,
          'userEmail': user.email,
          'productName': itemData['name'],
          'selectedVariant': itemData['selectedVariant'] ?? 'Стандарт',
          'image': itemData['image'] ?? (itemData['images'] != null ? itemData['images'][0] : ""),
          'price': itemData['price'],
          'quantity': itemData['quantity'] ?? 1,
          'totalBill': widget.total, // Жалпы төленген сома
          'status': 'Өңделуде',
          'customerName': _nameController.text,
          'address': '$selectedCity, ${_streetController.text}, пәт: ${_apartmentController.text}, кіреберіс: ${_entranceController.text}',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // 4. Себеттен сатып алынған тауарларды өшіру
      for (var doc in cartSnapshot.docs) {
        await doc.reference.delete();
      }

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Қате орын алды: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Рәсімдеу', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Жеткізу мекенжайы', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              
              DropdownButtonFormField<String>(
                decoration: _inputStyle("Қаланы таңдаңыз", Icons.location_city),
                value: selectedCity,
                items: cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
                onChanged: (value) => setState(() => selectedCity = value),
                validator: (value) => value == null ? 'Қаланы таңдаңыз' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _streetController,
                decoration: _inputStyle("Көше, үй нөмірі", Icons.home),
                validator: (value) => value!.isEmpty ? 'Көшені жазыңыз' : null,
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _apartmentController,
                      decoration: _inputStyle("Пәтер", Icons.door_front_door),
                      validator: (value) => value!.isEmpty ? 'Пәтерді жазыңыз' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _entranceController,
                      decoration: _inputStyle("Кіреберіс", Icons.stairs),
                      validator: (value) => value!.isEmpty ? 'Кіреберісті жазыңыз' : null,
                    ),
                  ),
                ],
              ),

              const Divider(height: 40, thickness: 1),
              const Text('Карта мәліметтері', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              
              TextFormField(
                controller: _nameController,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                decoration: _inputStyle("Карта иесінің аты-жөні", Icons.person),
                validator: (value) => value!.isEmpty ? 'Аты-жөніңізді жазыңыз' : null,
              ),
              const SizedBox(height: 10),
              
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
                decoration: _inputStyle("0000 0000 0000 0000", Icons.credit_card),
                validator: (value) => value!.length < 16 ? '16 сан болуы керек' : null,
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [LengthLimitingTextInputFormatter(5)],
                      decoration: _inputStyle("MM/YY", Icons.calendar_today),
                      validator: (value) => value!.isEmpty ? 'Мерзімін жазыңыз' : null,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      obscureText: _isCVVHidden,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                      decoration: InputDecoration(
                        hintText: 'CVV',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        suffixIcon: IconButton(
                          icon: Icon(_isCVVHidden ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _isCVVHidden = !_isCVVHidden),
                        ),
                      ),
                      validator: (value) => value!.length < 3 ? '3 сан болуы керек' : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Жалпы сома:', style: TextStyle(fontSize: 18)),
                        Text('${widget.total} ₸', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _processOrder();
                          }
                        },
                        child: const Text('Төлемді аяқтау', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[100],
      prefixIcon: Icon(icon, color: Colors.orange),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      errorStyle: const TextStyle(color: Colors.red),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Сәтті!', textAlign: TextAlign.center),
        content: const Text('Тапсырысыңыз қабылданды. Рахмет!', textAlign: TextAlign.center),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Жақсы', style: TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}