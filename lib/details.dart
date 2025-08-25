import 'package:aplikasi_sparepart/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sparepart.dart';
import 'config.dart';

class DetailsPage extends StatefulWidget {
  final SparePart sparepart;

  const DetailsPage({super.key, required this.sparepart});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
  }

  void _showQuantitySelector(bool isBuyNow) {
    int quantity = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Pilih Jumlah",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) setState(() => quantity--);
                        },
                        icon: const Icon(Icons.remove_circle, size: 28),
                      ),
                      Text(
                        quantity.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() => quantity++);
                        },
                        icon: const Icon(Icons.add_circle, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final userId = AppConfig.currentUserId;
                        if (userId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Silakan login terlebih dahulu"),
                            ),
                          );
                          return;
                        }

                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('access_token');

                        final success = await CartService.addToCart(
                          userId,
                          widget.sparepart.id,
                          quantity,
                          token: token,
                        );

                        Navigator.pop(context);

                        if (success) {
                          if (isBuyNow) {
                            Navigator.pushNamed(context, '/checkout');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Ditambahkan ke keranjang"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Gagal menambahkan ke keranjang"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Text(
                        isBuyNow ? "Beli Sekarang" : "Tambahkan ke Keranjang",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sparepart.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.sparepart.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              widget.sparepart.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              formatCurrency.format(widget.sparepart.price),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              widget.sparepart.description,

              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showQuantitySelector(false),
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text("Tambah ke Keranjang"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () => _showQuantitySelector(true),
                icon: const Icon(Icons.payment),
                label: const Text("Beli Sekarang"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
