import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  final int? userId;
  const CartPage({super.key, required this.userId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> _cartItems = [];
  bool _isLoading = true;

  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    if (widget.userId == null) {
      setState(() {
        _cartItems = [];
        _isLoading = false;
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final items = await CartService.fetchCart(widget.userId!, token);
    setState(() {
      _cartItems = items;
      _isLoading = false;
    });
  }

  Future<void> _changeQuantity(int index, int delta) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final item = _cartItems[index];

    await CartService.updateCartQuantity(
      widget.userId!,
      item.sparepartId,
      delta,
      token: token,
    );

    await _loadCart();
  }

  Future<void> _deleteItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final item = _cartItems[index];

    await CartService.removeFromCart(
      widget.userId!,
      item.sparepartId,
      token: token,
    );

    await _loadCart();
  }

  int get totalPrice => _cartItems.fold(
    0,
    (sum, item) => sum + (item.price * item.quantity).toInt(),
  );

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Keranjang")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Keranjang")),
        body: const Center(child: Text("Keranjang masih kosong")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      item.image,
                      width: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported),
                    ),
                    title: Text(item.name),
                    subtitle: Text(
                      "${formatCurrency.format(item.price * item.quantity)}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => _changeQuantity(index, -1),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          constraints: const BoxConstraints(minWidth: 24),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              item.quantity.toString(),
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _changeQuantity(index, 1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteItem(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckoutPage()),
                  );
                },
                child: Text(
                  "Checkout (${formatCurrency.format(totalPrice)})",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
