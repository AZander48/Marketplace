import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/city.dart';
import '../models/state.dart';
import '../models/country.dart';
import '../models/user.dart';

class ApiService {
  final String _baseUrl = 'http://10.0.2.2:3000/api';
  static const Duration timeout = Duration(seconds: 30);
  static const String _tokenKey = 'auth_token';

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  // Test database connection
  Future<Map<String, dynamic>> testConnection() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/test-connection'),
        headers: headers,
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
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/products'),
        headers: headers,
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
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/products/$id'),
        headers: headers,
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
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/products'),
        headers: headers,
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
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$_baseUrl/products/${product.id}'),
        headers: headers,
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

  Future<void> deleteProduct(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$_baseUrl/products/$id'),
        headers: headers,
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }
  

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/products/search?query=$query'),
        headers: headers,
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } on http.ClientException {
      throw Exception('Request timed out. Please check your internet connection and try again.');
    } on SocketException {
      throw Exception('No internet connection. Please check your network and try again.');
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  // Get user's products
  Future<List<Product>> getUserProducts(int userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/products/user/$userId'),
        headers: headers,
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user products: ${response.statusCode}');
      }
    } on http.ClientException {
      throw Exception('Request timed out. Please check your internet connection and try again.');
    } on SocketException {
      throw Exception('No internet connection. Please check your network and try again.');
    } catch (e) {
      throw Exception('Failed to load user products: $e');
    }
  }

  Future<City?> getCityById(int cityId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/locations/cities/$cityId'),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return City.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error getting city: $e');
      return null;
    }
  }

  Future<State?> getStateById(int stateId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/locations/states/$stateId'),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return State.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error getting state: $e');
      return null;
    }
  }

  Future<Country?> getCountryById(int countryId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/locations/countries/$countryId'),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Country.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error getting country: $e');
      return null;
    }
  }

  Future<List<Country>> getCountries() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/locations/countries'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Country.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load countries: $e');
    }
  }

  Future<List<State>> getStatesByCountryId(int countryId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/locations/states/$countryId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => State.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load states: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load states: $e');
    }
  }

  Future<List<User>> getInterestedBuyers(int productId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products/$productId/interested'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load interested buyers');
      }
    } catch (e) {
      throw Exception('Error loading interested buyers: $e');
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