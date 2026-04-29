import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ОСЫ КЕРЕК
import 'login_screen.dart';
import 'seller_screen.dart'; 
import '../main.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isSeller = false;

  // НЕГІЗГІ ТІРКЕУ ФУНКЦИЯСЫ
  Future<void> _register() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Барлық жолақты толтырыңыз!');
      return;
    }

    if (password != confirmPassword) {
      _showError('Құпия сөздер сәйкес келмейді!');
      return;
    }

    if (password.length < 6) {
      _showError('Құпия сөз кем дегенде 6 символ болуы керек!');
      return;
    }

    try {
      // Күту диалогын қосу
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.orange)),
      );

      // 1. Firebase Authentication-ге тіркеу
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Firestore базасына пайдаланушы мәліметтерін және РОЛІН сақтау
      // Бұл ағайдың "бәрі базада болсын" деген талабы үшін өте маңызды
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'role': _isSeller ? 'seller' : 'customer', // Рольді осы жерде бөлеміз
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.pop(context); // Күту диалогын жабу

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Тіркелу сәтті аяқталды!'), backgroundColor: Colors.green),
      );

      // 3. Таңдалған рольге байланысты бетке бағыттау
      if (_isSeller) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SellerScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      }

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      
      String msg = "Тіркелу кезінде қате шықты";
      if (e.code == 'email-already-in-use') msg = "Бұл email тіркеліп қойған.";
      if (e.code == 'invalid-email') msg = "Email форматы қате.";
      
      _showError(msg);
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      _showError("Жүйелік қате: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Тіркелу",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              const SizedBox(height: 10),
              const Text("Жаңа аккаунт ашыңыз", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),

              _buildTextField(_nameController, "Толық атыңыз", Icons.person_outline),
              const SizedBox(height: 20),
              _buildTextField(_emailController, "Email", Icons.email_outlined, type: TextInputType.emailAddress),
              const SizedBox(height: 20),
              _buildTextField(_passwordController, "Құпия сөз", Icons.lock_outline, isPass: true),
              const SizedBox(height: 20),
              _buildTextField(_confirmPasswordController, "Құпия сөзді қайталаңыз", Icons.lock_reset, isPass: true),
              
              const SizedBox(height: 15),
              // РОЛЬ ТАҢДАУ (SWITCH)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isSeller ? "Мен Сатушымын 🏢" : "Мен Қолданушымын 🛒",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Switch(
                      value: _isSeller,
                      activeColor: Colors.orange,
                      onChanged: (value) => setState(() => _isSeller = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: _register,
                  child: const Text("Тіркелу", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Аккаунтыңыз бар ма?"),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Кіру", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPass = false, TextInputType type = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}