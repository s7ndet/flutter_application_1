import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ҚОСЫЛДЫ
import 'package:firebase_auth/firebase_auth.dart'; // ҚОСЫЛДЫ

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Деректерді енгізу контроллерлері
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isLoading = false;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Экран ашылғанда базадан деректерді жүктеу
  }

  // Базадан қолданушы деректерін алу
  Future<void> _loadUserData() async {
    if (_currentUser != null) {
      // Email-ді бірден Auth-тан аламыз
      _emailController.text = _currentUser!.email ?? "";
      
      // Қалған деректерді Firestore-дан аламыз
      var doc = await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).get();
      if (doc.exists) {
        setState(() {
          _nameController.text = doc.data()?['name'] ?? "";
          _phoneController.text = doc.data()?['phone'] ?? "";
        });
      }
    }
  }

  // Барлық өзгерістерді сақтау
  Future<void> _saveSettings() async {
    if (_currentUser == null) return;

    setState(() => _isLoading = true);

    try {
      // 1. Firestore-да аты мен нөмірін жаңарту
      await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).set({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
      }, SetOptions(merge: true));

      // 2. Егер құпия сөз жазылған болса, оны жаңарту
      if (_passController.text.isNotEmpty) {
        if (_passController.text.length < 6) {
          throw "Құпия сөз кем дегенде 6 таңбадан тұруы керек";
        }
        await _currentUser!.updatePassword(_passController.text.trim());
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Өзгерістер сәтті сақталды!'), backgroundColor: Colors.green),
        );
        _passController.clear(); // Құпия сөз өрісін тазалау
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Қате: $e'), backgroundColor: Colors.red),
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
          'Баптаулар',
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

                  // Email (Тек көру үшін, Auth-та email өзгерту күрделірек)
                  _buildSettingField(
                    label: 'Электрондық пошта (өзгертілмейді)',
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    enabled: false,
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
                    label: 'Жаңа құпия сөз (өзгертпесеңіз бос қалдырыңыз)',
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
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _saveSettings,
                      child: const Text(
                        'Өзгерістерді сақтау',
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
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
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        enabled: enabled,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: enabled ? Colors.grey : Colors.grey[400]),
          prefixIcon: Icon(icon, color: enabled ? Colors.orange : Colors.grey),
          filled: !enabled,
          fillColor: Colors.grey[100],
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