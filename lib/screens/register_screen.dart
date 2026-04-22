import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'seller_screen.dart'; 
// ЕГЕР ТІРКЕЛГЕН СОҢ БАСТЫ БЕТКЕ ӨТУ КЕРЕК БОЛСА, МЫНА ИМПОРТТЫ ҚОС:
import '../main.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Бақылаушылар (Controllers)
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // ӨЗГЕРТІЛДІ: Сатушы ма, жоқ па екенін анықтайтын айнымалы
  bool _isSeller = false;

  void _register() {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    // Қарапайым тексерулер
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Барлық жолақты толтырыңыз!'), backgroundColor: Colors.red),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Құпия сөздер сәйкес келмейді!'), backgroundColor: Colors.red),
      );
      return;
    }

    // Тіркелу сәтті өткен жағдайды имитациялау
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Тіркелу сәтті аяқталды!'), backgroundColor: Colors.green),
    );

    // ӨЗГЕРТІЛДІ: Тіркелгеннен кейін таңдауға байланысты бетке бағыттау
    if (_isSeller) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SellerScreen()),
      );
    } else {
      // Қолданушы болса басты бетке (MainNavigation) немесе логинге жіберу
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    }
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

              // Аты-жөні
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Толық атыңыз",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 20),

              // Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Логин немесе Email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 20),

              // Құпия сөз
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Құпия сөз",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 20),

              // Құпия сөзді қайталау
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Құпия сөзді қайталаңыз",
                  prefixIcon: const Icon(Icons.lock_reset),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              
              // ЖАҢАДАН ҚОСЫЛҒАН: Сатушы ретінде тіркелу таңдауы
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Сатушы ретінде тіркелу", style: TextStyle(fontSize: 16)),
                  Switch(
                    value: _isSeller,
                    activeColor: Colors.orange,
                    onChanged: (value) {
                      setState(() {
                        _isSeller = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Тіркелу батырмасы
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: _register,
                  child: const Text(
                    "Тіркелу",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Кіру бетіне қайтару
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
}