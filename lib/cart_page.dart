import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/cart.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang")),
      body: Cart.items.isEmpty
          ? const Center(child: Text("Keranjang masih kosong"))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: Cart.items.length,
              itemBuilder: (context, index) {
                final cartItem = Cart.items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Image.network(
                      cartItem.sparepart.image,
                      width: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported),
                    ),
                    title: Text(
                      cartItem.sparepart.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${formatCurrency.format(cartItem.sparepart.price)} x ${cartItem.quantity}\n"
                      "= ${formatCurrency.format(cartItem.sparepart.price * cartItem.quantity)}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() {
                              Cart.removeItem(cartItem.sparepart);
                            });
                          },
                        ),
                        Text(
                          "${cartItem.quantity}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            setState(() {
                              Cart.addItem(cartItem.sparepart);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Cart.items.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/checkout');
                },
                child: Text(
                  "Checkout - ${formatCurrency.format(Cart.totalPrice)}",
                ),
              ),
            )
          : null,
    );
  }
}
