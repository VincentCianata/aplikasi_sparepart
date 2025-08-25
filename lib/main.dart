import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'home_page.dart';
import 'details.dart';
import 'cart_page.dart';
import 'checkout_page.dart';
import '../models/sparepart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id');
  if (userId != null) {
    AppConfig.currentUserId = userId;
  }

  runApp(MyApp(initialRoute: userId != null ? '/home' : '/'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spare Part Store',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/details': (context) {
          final sparePart =
              ModalRoute.of(context)!.settings.arguments as SparePart;
          return DetailsPage(sparepart: sparePart);
        },
        '/cart': (context) {
          final userId = AppConfig.currentUserId;
          if (userId == null) {
            return const LoginPage();
          }
          return CartPage(userId: userId);
        },
        '/checkout': (context) => const CheckoutPage(),
      },
    );
  }
}
