import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aplikasi_sparepart/config.dart';
import '../models/cart.dart';

class CartService {
  static const String baseUrl = "http://10.0.2.2:5000/api";
  static Future<List<CartItem>> fetchCart(int userId, String? token) async {
    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
    final response = await http.get(
      Uri.parse("$baseUrl/cart/$userId"),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CartItem.fromJson(json)).toList();
    }
    return [];
  }

  static Future<bool> addToCart(
    int userId,
    int sparepartId,
    int quantity, {
    String? token,
  }) async {
    final url = Uri.parse("$baseUrl/cart/$userId/$sparepartId");

    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    final body = jsonEncode({"quantity": quantity});

    final response = await http.post(url, headers: headers, body: body);

    // print("➡️ Request: $url");
    // print("➡️ Headers: $headers");
    // print("➡️ Body: $body");
    // print("⬅️ Response: ${response.statusCode}, ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateCartQuantity(
    int userId,
    int sparepartId,
    int delta, {
    String? token,
  }) async {
    final url = Uri.parse("$baseUrl/cart/$userId/$sparepartId");
    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
    final body = jsonEncode({"delta": delta});
    final response = await http.patch(url, headers: headers, body: body);
    return response.statusCode == 200;
  }

  static Future<bool> removeFromCart(
    int userId,
    int sparepartId, {
    String? token,
  }) async {
    final url = Uri.parse("$baseUrl/cart/$userId/$sparepartId");
    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
    final response = await http.delete(url, headers: headers);
    return response.statusCode == 200;
  }

  static Future<bool> clearCart(int userId, String? token) async {
    final url = Uri.parse("$baseUrl/cart/clear/$userId");
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.delete(url, headers: headers);

    return response.statusCode == 200;
  }
}
