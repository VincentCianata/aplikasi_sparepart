import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'checkout_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spare Part Store',
      theme: ThemeData(primarySwatch: Colors.blue),

      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/cart': (context) => const CartPage(),
        '/checkout': (context) => const CheckoutPage(),
      },
    );
  }
}
