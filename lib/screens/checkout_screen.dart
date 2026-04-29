import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ҚОСЫЛДЫ
import 'package:firebase_auth/firebase_auth.dart'; // ҚОСЫЛДЫ

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

  // Мекенжай үшін контроллерлер (Базаға жіберу үшін керек)
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _entranceController = TextEditingController();

  final List<String> cities = [
    'Алматы', 'Астана', 'Шымкент', 'Ақтөбе', 'Қарағанды', 
    'Тараз', 'Павлодар', 'Өскемен', 'Семей', 'Қостанай', 'Орал'
  ];

  // ӨЗГЕРТІЛДІ: Тапсырысты Firebase-ке жіберу логикасы
  Future<void> _processOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // 1. Алдымен себеттегі тауарларды базадан аламыз
      var cartSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();

      List<Map<String, dynamic>> items = cartSnapshot.docs.map((doc) => doc.data()).toList();

      // 2. Orders коллекциясына жаңа тапсырыс қосамыз
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': user.uid,
        'items': items,
        'totalPrice': widget.total,
        'status': 'Өңделуде',
        'address': '$selectedCity, ${_streetController.text}, пәт: ${_apartmentController.text}, кіреберіс: ${_entranceController.text}',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. Себетті тазалаймыз
      for (var doc in cartSnapshot.docs) {
        await doc.reference.delete();
      }

      // 4. Сәтті аяқталғанын көрсету
      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Қате орын алды: $e'), backgroundColor: Colors.red),
      );
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
                controller: _streetController, // ҚОСЫЛДЫ
                decoration: _inputStyle("Көше, үй нөмірі", Icons.home),
                validator: (value) => value!.isEmpty ? 'Көшені жазыңыз' : null,
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _apartmentController, // ҚОСЫЛДЫ
                      decoration: _inputStyle("Пәтер", Icons.door_front_door),
                      validator: (value) => value!.isEmpty ? 'Пәтерді жазыңыз' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _entranceController, // ҚОСЫЛДЫ
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
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                decoration: _inputStyle("Карта иесінің аты-жөні", Icons.person),
                validator: (value) => value!.isEmpty ? 'Аты-жөніңізді жазыңыз' : null,
              ),
              const SizedBox(height: 10),
              
              TextFormField(
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
                      keyboardType: TextInputType.number,
                      inputFormatters: [LengthLimitingTextInputFormatter(5)],
                      decoration: _inputStyle("MM/YY", Icons.calendar_today),
                      validator: (value) => value!.isEmpty ? 'Мерзімін жазыңыз' : null,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
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
                            _processOrder(); // ӨЗГЕРТІЛДІ
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Барлық жерді дұрыс толтырыңыз!'), backgroundColor: Colors.red),
                            );
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
        content: const Text('Тапсырысыңыз қабылданды. Тарих бөлімінен көре аласыз.', textAlign: TextAlign.center),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context); // Диалогты жабу
                Navigator.popUntil(context, (route) => route.isFirst); // Басты бетке қайту
              },
              child: const Text('Жақсы', style: TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}