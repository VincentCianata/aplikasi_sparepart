// Cart Page
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';

class CartPage extends StatefulWidget {
  final int? userId; // Make userId nullable
  const CartPage({super.key, required this.userId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<CartItem>> _cartFuture;
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _initializeCartFuture();
  }

  Future<void> _initializeCartFuture() async {
    // Check if the user ID is available before proceeding.
    if (widget.userId == null) {
      // If the user ID is null, set the future to an empty list
      // and show a message to the user.
      setState(() {
        _cartFuture = Future.value([]);
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("User not logged in.")));
      }
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    // Make sure the token is available as well
    if (token == null) {
      setState(() {
        _cartFuture = Future.value([]);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication token not found.")),
        );
      }
      return;
    }

    // Now, with both userId and token, fetch the cart.
    setState(() {
      _cartFuture = CartService.fetchCart(widget.userId!, token);
    });
  }

  void _refreshCart() {
    _initializeCartFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang")),
      body: FutureBuilder<List<CartItem>>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text("Keranjang masih kosong"));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
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
                    "${formatCurrency.format(item.price)} x ${item.quantity}\n"
                    "= ${formatCurrency.format(item.price * item.quantity)}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('access_token');
                      await CartService.removeFromCart(
                        widget.userId!,
                        item.sparepartId,
                        token: token,
                      );
                      _refreshCart();
                    },
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
