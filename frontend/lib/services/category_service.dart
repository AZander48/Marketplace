import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;
import '../models/category.dart';
import '../models/product.dart';
import '../config/environment.dart';
import '../services/api_service.dart';

class CategoryService {
  final ApiService _apiService;
  
  CategoryService({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService();

  // Get all categories
  Future<List<Category>> getCategories() async {
    try {
      foundation.debugPrint('Fetching categories...');
      final categories = await _apiService.getList('/categories', Category.fromJson);
      foundation.debugPrint('Categories fetched successfully');
      return categories;
    } catch (e) {
      foundation.debugPrint('Error loading categories: $e');
      rethrow;
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

      final response = await _apiService.makeRequest(
        'categories/$categoryId/products',
        method: 'GET',
        queryParams: queryParams,
      );

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
      rethrow;
    }
  }
} 