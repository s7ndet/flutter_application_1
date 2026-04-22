import 'package:flutter/material.dart';
import '../models/data.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int get totalAmount {
    int sum = 0;
    for (var item in cartItems) {
      bool isSelected = item['isSelected'] ?? false;
      if (isSelected) {
        int price = item['price'] ?? 0;
        int quantity = item['quantity'] ?? 1;
        sum += price * quantity;
      }
    }
    return sum;
  }

  void _showDeleteDialog(int index) {
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
            onPressed: () {
              favoriteItems.add(cartItems[index]);
              setState(() => cartItems.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Таңдаулылар'),
          ),
          TextButton(
            onPressed: () {
              setState(() => cartItems.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Өшіру', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Себет'), centerTitle: true),
      body: cartItems.isEmpty
          ? const Center(child: Text('Себет әзірге бос', style: TextStyle(fontSize: 18)))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        child: Column(
                          children: [
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: item['isSelected'] ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  item['isSelected'] = value ?? false;
                                });
                              },
                              title: Text(item['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('${item['price'] ?? 0} ₸', style: const TextStyle(color: Colors.red)),
                              // БҰЛ ЖЕРДЕГІ КОНФЛИКТ ШЕШІЛДІ:
                              secondary: SizedBox(
                                width: 50,
                                child: Image.network(
                                  (item['images'] != null && (item['images'] as List).isNotEmpty)
                                      ? item['images'][0]
                                      : 'https://via.placeholder.com/150',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
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
                                        setState(() => item['quantity'] = currentQty - 1);
                                      } else {
                                        _showDeleteDialog(index);
                                      }
                                    },
                                  ),
                                  Text('${item['quantity'] ?? 1}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline, color: Colors.orange),
                                    onPressed: () {
                                      int currentQty = item['quantity'] ?? 1;
                                      setState(() => item['quantity'] = currentQty + 1);
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
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Жалпы сумма:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('$totalAmount ₸', style: const TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                          onPressed: () {
                            if (totalAmount > 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutScreen(total: totalAmount),
                                ),
                              );
                            }
                          },
                          child: const Text('Жалғастыру', style: TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}