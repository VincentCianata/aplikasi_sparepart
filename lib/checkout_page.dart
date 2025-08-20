import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/sparepart.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = Cart.items;
    final total = Cart.totalPrice;

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text("Keranjang kosong"))
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final CartItem cartItem = items[index];
                        final SparePart part = cartItem.sparepart;

                        return ListTile(
                          leading: Image.asset(
                            part.image,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(part.name),
                          subtitle: Text(
                            "Rp ${part.price.toStringAsFixed(0)} x ${cartItem.quantity}",
                          ),
                          trailing: Text(
                            "Rp ${(part.price * cartItem.quantity).toStringAsFixed(0)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rp ${total.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Pembayaran Berhasil"),
                    content: const Text("Terima kasih sudah berbelanja!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Cart.items.clear();
                          Navigator.pop(ctx);
                          Navigator.pop(context);
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.payment),
              label: const Text("Bayar Sekarang"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
