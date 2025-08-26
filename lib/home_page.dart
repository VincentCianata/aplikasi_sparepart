import '../config.dart';
import 'package:flutter/material.dart';
import '../models/sparepart.dart';
import '../widgets/sparepart_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SparePart> spareParts = [];
  bool isLoading = true;

  Future<void> fetchSpareParts() async {
    try {
      final response = await http.get(
        Uri.parse("${AppConfig.baseUrl}/api/spareparts"),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          spareParts = data.map((json) => SparePart.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          spareParts = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        spareParts = [];
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSpareParts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spare Part Store"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              if (AppConfig.currentUserId != null) {
                Navigator.pushNamed(
                  context,
                  '/cart',
                  arguments: AppConfig.currentUserId,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please log in to view your cart.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: spareParts.length,
              itemBuilder: (context, index) {
                final sparePart = spareParts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/details',
                      arguments: sparePart,
                    );
                  },
                  child: SparePartCard(sparePart: sparePart),
                );
              },
            ),
    );
  }
}
