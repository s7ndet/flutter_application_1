import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Жалпы соманы есептеу
  int calculateTotal(List<QueryDocumentSnapshot> docs) {
    int sum = 0;
    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      bool isSelected = data['isSelected'] ?? false;
      if (isSelected) {
        int price = data['price'] ?? 0;
        int quantity = data['quantity'] ?? 1;
        sum += price * quantity;
      }
    }
    return sum;
  }

  // Тауарды өшіру немесе таңдаулыларға жылжыту
  void _showDeleteDialog(String docId, Map<String, dynamic> itemData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Өшіруді растау'),
        content: const Text('Тауарды өшіресіз бе әлде таңдаулыларға сақтайсыз ба?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Болдырмау', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              final user = _auth.currentUser;
              if (user != null) {
                // Таңдаулыларға қосу (image_0be626.png құрылымы бойынша)
                await _firestore
                    .collection('users')
                    .doc(user.uid)
                    .collection('favorites')
                    .doc(itemData['name'])
                    .set({
                  'name': itemData['name'],
                  'price': itemData['price'],
                  'images': itemData['images'],
                  'addedAt': FieldValue.serverTimestamp(),
                });
                // Себеттен өшіру
                await _firestore
                    .collection('users')
                    .doc(user.uid)
                    .collection('cart')
                    .doc(docId)
                    .delete();
              }
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Таңдаулылар'),
          ),
          TextButton(
            onPressed: () async {
              final user = _auth.currentUser;
              if (user != null) {
                await _firestore
                    .collection('users')
                    .doc(user.uid)
                    .collection('cart')
                    .doc(docId)
                    .delete();
              }
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Өшіру', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Санын өзгерту
  Future<void> _updateQuantity(String docId, int newQty) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(docId)
          .update({'quantity': newQty});
    }
  }

  // Checkbox өзгерту
  Future<void> _toggleSelection(String docId, bool isSelected) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(docId)
          .update({'isSelected': isSelected});
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Жүйеге кіріңіз")));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Себет', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Тек осы қолданушының себетін оқимыз
        stream: _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .orderBy('addedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Себет әзірге бос', style: TextStyle(fontSize: 18)));
          }

          final cartDocs = snapshot.data!.docs;
          final totalAmount = calculateTotal(cartDocs);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: cartDocs.length,
                  itemBuilder: (context, index) {
                    final doc = cartDocs[index];
                    final item = doc.data() as Map<String, dynamic>;
                    final docId = doc.id;

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          CheckboxListTile(
                            activeColor: Colors.orange,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: item['isSelected'] ?? false,
                            onChanged: (bool? value) => _toggleSelection(docId, value ?? false),
                            title: Text(item['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${item['price'] ?? 0} ₸', style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600)),
                            secondary: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: Image.network(
                                  (item['image'] != null) // Егер addToCart-та 'image' деп сақтасаң
                                      ? item['image']
                                      : (item['images'] != null && (item['images'] as List).isNotEmpty)
                                          ? item['images'][0]
                                          : 'https://via.placeholder.com/150',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.orange),
                                  onPressed: () {
                                    int currentQty = item['quantity'] ?? 1;
                                    if (currentQty > 1) {
                                      _updateQuantity(docId, currentQty - 1);
                                    } else {
                                      _showDeleteDialog(docId, item);
                                    }
                                  },
                                ),
                                Text('${item['quantity'] ?? 1}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: Colors.orange),
                                  onPressed: () {
                                    int currentQty = item['quantity'] ?? 1;
                                    _updateQuantity(docId, currentQty + 1);
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 5)],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Жалпы сумма:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                        Text('$totalAmount ₸', style: const TextStyle(fontSize: 22, color: Colors.red, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (totalAmount > 0) {
                            // Таңдалған тауарларды ғана CheckoutScreen-ге жібереміз
                            List<Map<String, dynamic>> selectedItems = cartDocs
                                .where((d) => (d.data() as Map<String, dynamic>)['isSelected'] == true)
                                .map((d) => d.data() as Map<String, dynamic>)
                                .toList();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                  total: totalAmount,
                                  // Егер CheckoutScreen-де тауарлар тізімі керек болса, осы жерден жіберсең болады
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Тауар таңдалмаған!"))
                            );
                          }
                        },
                        child: const Text('Жалғастыру', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}