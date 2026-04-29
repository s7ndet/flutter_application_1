import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ҚОСЫЛДЫ
import 'package:firebase_auth/firebase_auth.dart'; // ҚОСЫЛДЫ

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'Тапсырыстар тарихы',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.orange,
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
            _buildOrdersList(isActive: true),
            _buildOrdersList(isActive: false),
          ],
        ),
      ),
    );
  }

  // БҰЛ ЖЕР ӨЗГЕРТІЛДІ: Мәліметтерді Firebase-тен алады
  Widget _buildOrdersList({required bool isActive}) {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return StreamBuilder<QuerySnapshot>(
      // Тапсырыстарды статус бойынша сүземіз (Жеткізілді = Архив)
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: uid)
          .where('status', isEqualTo: isActive ? 'Өңделуде' : 'Жеткізілді')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.orange));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Тапсырыстар табылмады"));
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index].data() as Map<String, dynamic>;
            final items = order['items'] as List<dynamic>;
            final firstItem = items.isNotEmpty ? items[0] : {};

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
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
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: firstItem['image'] != null 
                    ? Image.network(firstItem['image'], fit: BoxFit.contain)
                    : const Icon(Icons.phone_iphone, color: Colors.orange),
                ),
                title: Text(
                  "${firstItem['name'] ?? 'Тауар'} (№${orders[index].id.substring(0, 4)})",
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      "Саны: ${firstItem['quantity'] ?? 1} дана",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isActive ? "Статус: ${order['status']}" : "Жеткізілді: ${order['deliveryDate'] ?? 'Аяқталды'}",
                      style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${order['totalPrice'] ?? 0} ₸",
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
      },
    );
  }
}