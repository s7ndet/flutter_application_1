import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ПАКЕТ ҚОСЫЛДЫ
import 'home_screen.dart'; 
import 'register_screen.dart';
import '../main.dart'; 
import 'seller_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // ФУНКЦИЯ ЖАҢАРТЫЛДЫ: Firebase-пен жұмыс істеу үшін async қосылды
  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Барлық өрісті толтырыңыз!'), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      // КҮТУ ДИАЛОГЫ (Жүктеу кезінде экран қатып қалмау үшін)
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.orange)),
      );

      // FIREBASE AUTH АРҚЫЛЫ КІРУ
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      Navigator.pop(context); // Күту диалогын жабу

      // СӘТТІ КІРГЕННЕН КЕЙІН ТАҢДАУ ДИАЛОГЫН ШЫҒАРУ
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Кіру түрін таңдаңыз", textAlign: TextAlign.center),
          content: const Text("Жүйеге кім ретінде кіргіңіз келеді?"),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainNavigation()),
                );
              },
              child: const Text("Қолданушы", style: TextStyle(color: Colors.grey, fontSize: 16)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SellerScreen()),
                );
              },
              child: const Text("Сатушы", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      );

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Күту диалогын жабу

      // ҚАТЕЛЕРДІ ӨҢДЕУ
      String errorMessage = "Қате орын алды";
      if (e.code == 'user-not-found') {
        errorMessage = "Мұндай қолданушы тіркелмеген.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Құпия сөз қате.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Email форматы дұрыс емес.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_person, size: 80, color: Colors.orange),
              const SizedBox(height: 20),
              const Text(
                "SellPak Store-ға кіру",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress, // Пошта үшін ыңғайлы пернетақта
                decoration: InputDecoration(
                  labelText: "Email", // Логин емес, Email болғаны дұрыс
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 20),
              
              TextField(
                controller: _passwordController,
                obscureText: true, 
                decoration: InputDecoration(
                  labelText: "Құпия сөз",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
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
                  onPressed: _login, // ЖАҢАРТЫЛҒАН ФУНКЦИЯ
                  child: const Text(
                    "Кіру",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text("Аккаунт жоқ па? Тіркелу", style: TextStyle(color: Colors.orange)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}