import 'package:flutter/material.dart';
import '../models/data.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Map<String, dynamic> selectedVariant;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Алғашқы вариантты қауіпсіз таңдау
    final variants = widget.product['variants'] as List?;
    if (variants != null && variants.isNotEmpty) {
      selectedVariant = Map<String, dynamic>.from(variants[0]);
    } else {
      selectedVariant = {'ram': 'Стандарт', 'price': 0};
    }
    
    // Тізімде бар ма, тексереміз
    isFavorite = favoriteItems.any((item) => item['name'] == widget.product['name']);
  }

  @override
  Widget build(BuildContext context) {
    // Деректерді қауіпсіз оқу
    final specs = widget.product['specs'] as Map<String, dynamic>?;
    final images = widget.product['images'] as List?;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: Colors.white,
            leading: const BackButton(color: Colors.black),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                child: Hero(
                  tag: widget.product['name'] ?? 'product_image',
                  child: Image.network(
                    (images != null && images.isNotEmpty) ? images[0] : "", 
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.product['name'] ?? "Атауы жоқ", 
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Text('${selectedVariant['price']} ₸', 
                          style: const TextStyle(fontSize: 24, color: Colors.orange, fontWeight: FontWeight.w800)),
                        const Spacer(),
                        
                        IconButton(
                          onPressed: () {
                            setState(() {
                              cartItems.add({
                                ...widget.product,
                                'name': '${widget.product['name']} (${selectedVariant['ram']})',
                                'price': selectedVariant['price'],
                                'quantity': 1,
                                'isSelected': true,
                              });
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Себетке қосылды!'), duration: Duration(seconds: 1)));
                          },
                          icon: const Icon(Icons.add_shopping_cart, color: Colors.orange),
                          style: IconButton.styleFrom(backgroundColor: Colors.orange.withOpacity(0.1)),
                        ),

                        const SizedBox(width: 8),

                        IconButton(
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                              if (isFavorite) {
                                if (!favoriteItems.any((item) => item['name'] == widget.product['name'])) {
                                  favoriteItems.add(widget.product);
                                }
                              } else {
                                favoriteItems.removeWhere((item) => item['name'] == widget.product['name']);
                              }
                            });
                          },
                          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                          color: isFavorite ? Colors.red : Colors.grey,
                          style: IconButton.styleFrom(backgroundColor: Colors.grey.withOpacity(0.1)),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 25),
                    const Text('Жад көлемін таңдаңыз:', 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 12),
                    Row(
                      children: (widget.product['variants'] as List? ?? []).map((variant) {
                        bool isSelected = selectedVariant['ram'] == variant['ram'];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ChoiceChip(
                            label: Text(variant['ram'] ?? ""),
                            selected: isSelected,
                            selectedColor: Colors.orange,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                            onSelected: (bool selected) {
                              setState(() => selectedVariant = variant);
                            },
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 25),
                    if (specs != null) ...[
                      const Text('Техникалық сипаттамалары:', 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          children: [
                            _buildSpecRow(Icons.screenshot, 'Экран:', specs['screen']),
                            const Divider(),
                            _buildSpecRow(Icons.memory, 'Процессор:', specs['cpu']),
                            const Divider(),
                            _buildSpecRow(Icons.battery_charging_full, 'Батарея:', specs['battery']),
                            const Divider(),
                            _buildSpecRow(Icons.camera_alt_outlined, 'Камера:', specs['camera']),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],

                    const Text('Сипаттамасы', 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 12),
                    Text(widget.product['description'] ?? "Сипаттамасы жақында қосылады...",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5)),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 0,
          ),
          onPressed: () {
            setState(() {
              cartItems.add({
                ...widget.product, 
                'name': '${widget.product['name']} (${selectedVariant['ram']})',
                'price': selectedVariant['price'],
                'isSelected': true, 
                'quantity': 1
              });
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${widget.product['name']} себетке қосылды!'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.orange,
              ),
            );
          },
          child: const Text('Себетке қосу', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildSpecRow(IconData icon, String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value?.toString() ?? "Дерек жоқ", 
              style: const TextStyle(fontWeight: FontWeight.bold)
            )
          ),
        ],
      ),
    );
  }
}