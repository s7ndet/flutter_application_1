import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Деректерді енгізу контроллерлері
  final TextEditingController _nameController = TextEditingController(text: "Сүндет Назар");
  final TextEditingController _emailController = TextEditingController(text: "sundet.nazar@gmail.com");
  final TextEditingController _phoneController = TextEditingController(text: "+7 707 000 00 00");
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Баптаулар'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Жеке деректерді өңдеу',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            // Атын өзгерту
            _buildSettingField(
              label: 'Толық аты-жөніңіз',
              controller: _nameController,
              icon: Icons.person_outline,
            ),

            // Email өзгерту
            _buildSettingField(
              label: 'Электрондық пошта',
              controller: _emailController,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),

            // Номер өзгерту
            _buildSettingField(
              label: 'Телефон нөмірі',
              controller: _phoneController,
              icon: Icons.phone_android_outlined,
              keyboardType: TextInputType.phone,
            ),

            // Құпия сөзді өзгерту
            _buildSettingField(
              label: 'Жаңа құпия сөз',
              controller: _passController,
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            const SizedBox(height: 30),

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
                  // Бұл жерде деректерді базаға сақтау логикасы болады
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Өзгерістер сәтті сақталды!')),
                  );
                },
                child: const Text(
                  'Өзгерістерді сақтау',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Әр өріс үшін ортақ виджет
  Widget _buildSettingField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.orange),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passController.dispose();
    super.dispose();
  }
}