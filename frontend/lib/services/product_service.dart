import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;
import '../models/product.dart';

class ProductService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  static const Duration timeout = Duration(seconds: 30);

  Future<List<Product>> getUserProducts(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/products'),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user products: ${response.statusCode}');
      }
    } catch (e) {
      foundation.debugPrint('Error loading user products: $e');
      throw Exception('Error loading user products: $e');
    }
  }
} 