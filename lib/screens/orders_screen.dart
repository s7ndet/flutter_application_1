import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Widget _buildOrdersList({required bool isActive}) {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return StreamBuilder<QuerySnapshot>(
      // Статус бойынша сүзу: 'Өңделуде' болса белсенді, басқа жағдайда архив
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  isActive ? "Белсенді тапсырыстар жоқ" : "Архив бос",
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final orderDoc = orders[index];
            final order = orderDoc.data() as Map<String, dynamic>;
            
            // Базадағы өріс атауларына сәйкестендіру
            final String name = order['productName'] ?? 'Тауар';
            final String image = order['image'] ?? '';
            final String variant = order['selectedVariant'] ?? '';
            final int quantity = order['quantity'] ?? 1;
            final int price = order['price'] ?? 0;
            final String status = order['status'] ?? 'Белгісіз';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: image.isNotEmpty
                        ? Image.network(image, fit: BoxFit.contain)
                        : const Icon(Icons.phone_iphone, color: Colors.orange),
                  ),
                  title: Text(
                    "$name (№${orderDoc.id.substring(0, 5).toUpperCase()})",
                    style: const TextStyle(
                      color: Colors.black, 
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        "Вариант: $variant | $quantity дана",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$price ₸",
                        style: const TextStyle(
                          color: Colors.orange, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    isActive ? Icons.access_time_filled : Icons.check_circle,
                    color: isActive ? Colors.orange : Colors.green,
                  ),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      color: Colors.grey[50],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          _buildDetailRow("Статус:", status, isStatus: true, isActive: isActive),
                          _buildDetailRow("Жеткізу мекенжайы:", order['address'] ?? 'Көрсетілмеген'),
                          _buildDetailRow("Тапсырыс уақыты:", _formatDate(order['createdAt'])),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false, bool isActive = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: isStatus ? (isActive ? Colors.blue : Colors.green) : Colors.black87,
              fontSize: 13,
              fontWeight: isStatus ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return "Көрсетілмеген";
    if (timestamp is Timestamp) {
      DateTime date = timestamp.toDate();
      return "${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    }
    return timestamp.toString();
  }
}