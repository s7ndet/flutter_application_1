import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Таңдаулылардан өшіру функциясы
  Future<void> _removeFromFavorites(String docName) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(docName)
          .delete();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Таңдаулылардан өшірілді'), duration: Duration(seconds: 1)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Таңдаулылар', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: user == null
          ? const Center(child: Text("Жүйеге кіріңіз"))
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(user.uid)
                  .collection('favorites')
                  .orderBy('addedAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Таңдаулылар тізімі бос', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  );
                }

                final favoriteDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: favoriteDocs.length,
                  itemBuilder: (context, index) {
                    final doc = favoriteDocs[index];
                    final item = doc.data() as Map<String, dynamic>;

                    // Бағаны алу (ProductDetail-де сақтаған баға немесе бірінші вариант бағасы)
                    final String price = item['price']?.toString() ?? "0";

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: ListTile(
                        onTap: () {
                          // Таңдаулылардан ашқанда толық мәліметке өту
                          // Ескерту: Тауардың барлық дерегі базада болмаса, ID арқылы базадан іздеу керек болуы мүмкін
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(product: item),
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.all(10),
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Hero(
                            tag: item['name'] ?? 'fav_${index}',
                            child: Image.network(
                              (item['images'] != null && (item['images'] as List).isNotEmpty)
                                  ? item['images'][0]
                                  : "",
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.smartphone),
                            ),
                          ),
                        ),
                        title: Text(
                          item['name'] ?? "Атауы жоқ",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                        ),
                        subtitle: Text(
                          '$price ₸',
                          style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15)
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () => _removeFromFavorites(item['name']),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}