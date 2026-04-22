import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/data.dart';

class CheckoutScreen extends StatefulWidget {
  final int total;
  const CheckoutScreen({super.key, required this.total});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>(); // Форманы тексеру үшін керек
  bool _isCVVHidden = true;
  String? selectedCity;

  final List<String> cities = [
    'Алматы', 'Астана', 'Шымкент', 'Ақтөбе', 'Қарағанды', 
    'Тараз', 'Павлодар', 'Өскемен', 'Семей', 'Қостанай', 'Орал'
  ];
  
  get cartItems => null;

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
          key: _formKey, // Барлық TextField-тер осы форманың ішінде
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Жеткізу мекенжайы', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              
              // Қала таңдау
              DropdownButtonFormField<String>(
                decoration: _inputStyle("Қаланы таңдаңыз", Icons.location_city),
                value: selectedCity,
                items: cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
                onChanged: (value) => setState(() => selectedCity = value),
                validator: (value) => value == null ? 'Қаланы таңдаңыз' : null,
              ),
              const SizedBox(height: 10),

              // Көше мен үй
              TextFormField(
                decoration: _inputStyle("Көше, үй нөмірі", Icons.home),
                validator: (value) => value!.isEmpty ? 'Көшені жазыңыз' : null,
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: _inputStyle("Пәтер", Icons.door_front_door),
                      validator: (value) => value!.isEmpty ? 'Пәтерді жазыңыз' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: _inputStyle("Кіреберіс", Icons.stairs),
                      validator: (value) => value!.isEmpty ? 'Кіреберісті жазыңыз' : null,
                    ),
                  ),
                ],
              ),

              const Divider(height: 40, thickness: 1),

              const Text('Карта мәліметтері', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              
              // Карта иесі
              TextFormField(
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                decoration: _inputStyle("Карта иесінің аты-жөні", Icons.person),
                validator: (value) => value!.isEmpty ? 'Аты-жөніңізді жазыңыз' : null,
              ),
              const SizedBox(height: 10),
              
              // Карта нөмірі
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
                        errorStyle: const TextStyle(color: Colors.red),
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
                          // Тексеруді бастау
                          if (_formKey.currentState!.validate()) {
                            // Егер бәрі дұрыс болса
                            _showSuccessDialog();
                          } else {
                            // Қате болса, хабарлама шығару
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
      errorStyle: const TextStyle(color: Colors.red), // Қате жазуының түсі
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Тапсырыс сәтті аяқталды!'),
        content: const Text('Тапсырысыңыз қабылданды.'),
        actions: [
          TextButton(
            onPressed: () {
              cartItems.clear();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('Жақсы'),
          ),
        ],
      ),
    );
  }
}