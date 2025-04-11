import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api'; // Use 10.0.2.2 for Android emulator
  static const Duration timeout = Duration(seconds: 10);

  // Test database connection
  Future<Map<String, dynamic>> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/test-connection'),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw _handleError(response.statusCode);
      }
    } on http.ClientException catch (e) {
      throw 'Connection error: Please check if the server is running and accessible';
    } on FormatException catch (e) {
      throw 'Invalid response format from server';
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw 'Connection timeout: Server is taking too long to respond';
      }
      throw 'An unexpected error occurred: $e';
    }
  }

  // Get all products
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Product.fromJson(json)).toList();
      } else {
        throw _handleError(response.statusCode);
      }
    } on http.ClientException catch (e) {
      throw 'Connection error: Please check if the server is running and accessible';
    } on FormatException catch (e) {
      throw 'Invalid response format from server';
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw 'Connection timeout: Server is taking too long to respond';
      }
      throw 'An unexpected error occurred: $e';
    }
  }

  // Get single product
  Future<Product> getProduct(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw _handleError(response.statusCode);
      }
    } on http.ClientException catch (e) {
      throw 'Connection error: Please check if the server is running and accessible';
    } on FormatException catch (e) {
      throw 'Invalid response format from server';
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw 'Connection timeout: Server is taking too long to respond';
      }
      throw 'An unexpected error occurred: $e';
    }
  }

  // Create new product
  Future<Product> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(productData),
      ).timeout(timeout);

      if (response.statusCode == 201) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw _handleError(response.statusCode);
      }
    } on http.ClientException catch (e) {
      throw 'Connection error: Please check if the server is running and accessible';
    } on FormatException catch (e) {
      throw 'Invalid response format from server';
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw 'Connection timeout: Server is taking too long to respond';
      }
      throw 'An unexpected error occurred: $e';
    }
  }

  String _handleError(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request: Please check your input data';
      case 401:
        return 'Unauthorized: Please login again';
      case 403:
        return 'Forbidden: You don\'t have permission to access this resource';
      case 404:
        return 'Resource not found';
      case 500:
        return 'Server error: Please try again later';
      default:
        return 'HTTP error: $statusCode';
    }
  }
} 