import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;
import '../models/category.dart';
import '../models/product.dart';

class CategoryService {
  static const String baseUrl = 'http://10.0.2.2:3000/api'; // Use 10.0.2.2 for Android emulator
  static const Duration timeout = Duration(seconds: 30);

  // Get all categories
  Future<List<Category>> getCategories() async {
    try {
      foundation.debugPrint('Fetching categories from: $baseUrl/categories');
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
      ).timeout(timeout);

      foundation.debugPrint('Categories response status: ${response.statusCode}');
      foundation.debugPrint('Categories response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      foundation.debugPrint('Error loading categories: $e');
      throw Exception('Error loading categories: $e');
    }
  }

  // Get products by category
  Future<Map<String, dynamic>> getCategoryProducts(
    int categoryId, {
    int limit = 20,
    int offset = 0,
    String? searchQuery,
    int? vehicleId,
  }) async {
    try {
      final queryParams = {
        'limit': limit.toString(),
        'offset': offset.toString(),
        if (searchQuery != null && searchQuery.isNotEmpty)
          'search': searchQuery,
        if (vehicleId != null)
          'vehicleId': vehicleId.toString(),
      };

      final url = Uri.parse('$baseUrl/categories/$categoryId/products')
          .replace(queryParameters: queryParams);
      
      foundation.debugPrint('Fetching category products from: $url');
      
      final response = await http.get(url).timeout(timeout);

      foundation.debugPrint('Category products response status: ${response.statusCode}');
      foundation.debugPrint('Category products response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['products'] ?? [];
        final List<Product> products = productsJson.map((json) => Product.fromJson(json)).toList();
        return {
          'products': products,
          'total': data['total'] ?? 0,
        };
      } else {
        throw Exception('Failed to load category products: ${response.statusCode}');
      }
    } catch (e) {
      foundation.debugPrint('Error loading category products: $e');
      throw Exception('Error loading category products: $e');
    }
  }
} 