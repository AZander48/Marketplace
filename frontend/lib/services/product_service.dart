import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;
import '../models/product.dart';
import '../config/environment.dart';

class ProductService {
  static const Duration timeout = Duration(seconds: 10);

  Future<List<Product>> getUserProducts(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${EnvironmentConfig.apiUrl}/users/$userId/products'),
      ).timeout(timeout, onTimeout: () {
        throw TimeoutException('Request timed out. Please check your internet connection and try again.');
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user products: ${response.statusCode}');
      }
    } catch (e) {
      foundation.debugPrint('Error loading user products: $e');
      if (e is TimeoutException) {
        throw Exception('Request timed out. Please check your internet connection and try again.');
      }
      throw Exception('Error loading user products: $e');
    }
  }
} 