import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Екі бөлім: Белсенді және Архив
      child: Scaffold(
        backgroundColor: Colors.white, // ТҮЗЕТІЛДІ: Ақ фон
        appBar: AppBar(
          backgroundColor: Colors.white, // ТҮЗЕТІЛДІ: Ақ фон
          elevation: 0.5,
          title: const Text(
            'Тапсырыстар тарихы',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // ТҮЗЕТІЛДІ: Қара мәтін
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black), // ТҮЗЕТІЛДІ: Қара иконка
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.orange, // Белсенді сызық түсі
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Белсенді"),
              Tab(text: "Архив"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 1. Белсенді тапсырыстар тізімі
            _buildOrdersList(isActive: true),
            
            // 2. Архивтелген тапсырыстар тізімі
            _buildOrdersList(isActive: false),
          ],
        ),
      ),
    );
  }

  // Тапсырыстар тізімін құрастырушы виджет
  Widget _buildOrdersList({required bool isActive}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3, // Мысал ретінде 3 элемент
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200), // ТҮЗЕТІЛДІ: Жиек
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            // ТҮЗЕТІЛДІ: Тауар суретінің орны қосылды
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.phone_iphone, color: Colors.orange),
            ),
            title: Text(
              isActive ? "iPhone 15 Pro (№${1 + index})" : "Samsung S24 (№${2 + index})",
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                const Text(
                  "Түрі: Смартфон",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  isActive ? "Күтілуде: 20-30 мин" : "Жеткізілді: 12 сәуір",
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  "580 000 ₸", // ТҮЗЕТІЛДІ: Нақты баға стилі
                  style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            trailing: Icon(
              isActive ? Icons.access_time_filled : Icons.check_circle,
              color: isActive ? Colors.orange : Colors.green,
            ),
          ),
        );
      },
    );
  }
}