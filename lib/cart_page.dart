import 'package:flutter/material.dart';
import 'models/cart.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang")),
      body: Cart.items.isEmpty
          ? const Center(child: Text("Keranjang masih kosong"))
          : ListView.builder(
              itemCount: Cart.items.length,
              itemBuilder: (context, index) {
                final cartItem = Cart.items[index];
                return ListTile(
                  leading: Image.asset(
                    cartItem.sparepart.image,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(cartItem.sparepart.name),
                  subtitle: Text(
                    "Rp ${cartItem.sparepart.price} x ${cartItem.quantity} = Rp ${cartItem.sparepart.price * cartItem.quantity}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            Cart.removeItem(cartItem.sparepart);
                          });
                        },
                      ),
                      Text("${cartItem.quantity}"),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            Cart.addItem(cartItem.sparepart);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Cart.items.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/checkout');
                },
                child: Text("Checkout - Rp ${Cart.totalPrice}"),
              ),
            )
          : null,
    );
  }
}
