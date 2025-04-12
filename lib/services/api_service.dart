import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api'; // Use 10.0.2.2 for Android emulator
  static const Duration timeout = Duration(seconds: 30);

  // Test database connection
  Future<Map<String, dynamic>> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/test-connection'),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to test connection: ${response.statusCode}');
      }
    } on http.ClientException {
      throw Exception('Connection test timed out. Please check your internet connection and try again.');
    } on SocketException {
      throw Exception('No internet connection. Please check your network and try again.');
    } catch (e) {
      throw Exception('Failed to test connection: $e');
    }
  }

  // Get all products
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } on http.ClientException {
      throw Exception('Request timed out. Please check your internet connection and try again.');
    } on SocketException {
      throw Exception('No internet connection. Please check your network and try again.');
    } catch (e) {
      throw Exception('Failed to load products: $e');
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
      throw """Connection error: Please check if the server is running and 
        accessible:\n${e.message}""";

    } on FormatException catch (e) {
      throw 'Invalid response format from server:\n${e.message}';
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw 'Connection timeout: Server is taking too long to respond';
      }
      throw 'An unexpected error occurred: $e';
    }
  }

  // Create new product
  Future<Product> createProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      ).timeout(timeout);

      if (response.statusCode == 201) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw _handleError(response.statusCode);
      }
    } on http.ClientException catch (e) {
      throw 'Connection error: Please check if the server is running '
          'and accessible';
    } on FormatException catch (e) {
      throw 'Invalid response format from server';
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw 'Connection timeout: Server is taking too long to respond';
      }
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<Product> updateProduct(Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/${product.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
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