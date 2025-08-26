import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/transaction.dart';

class TransactionService {
  static Future<bool> checkout(String? token) async {
    final url = Uri.parse("${AppConfig.baseUrl}/api/checkout");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(url, headers: headers);
    return response.statusCode == 200;
  }

  static Future<List<TransactionModel>> fetchUserTransactions(
    String token,
  ) async {
    final url = Uri.parse("${AppConfig.baseUrl}/api/transactions");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    }
    return [];
  }

  static Future<List<TransactionModel>> fetchAllTransactions(
    String token,
  ) async {
    final url = Uri.parse("${AppConfig.baseUrl}/api/transactions/all");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    }
    return [];
  }
}
