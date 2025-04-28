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
  static const Duration timeout = Duration(minutes: 2);
  static const String _tokenKey = 'auth_token';

  Future<Map<String, String>> getHeaders() async {
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
      final headers = await getHeaders();
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

  // Generic methods for different return types
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers,
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw _handleError(response.statusCode);
      }
    } catch (e) {
      _handleException(e);
      rethrow;
    }
  }

  // Generic method for List responses
  Future<List<T>> getList<T>(String endpoint, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers,
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is List) {
          return data.map((json) => fromJson(json as Map<String, dynamic>)).toList();
        } else if (data is Map<String, dynamic>) {
          final listData = data['data'] ?? [];
          return (listData as List).map((json) => fromJson(json as Map<String, dynamic>)).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw _handleError(response.statusCode);
      }
    } catch (e) {
      _handleException(e);
      rethrow;
    }
  }

  // Generic method for single item responses
  Future<T?> getOne<T>(String endpoint, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final response = await get(endpoint);
      return fromJson(response);
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  // Refactored methods using generic methods
  Future<List<Product>> getProducts() async {
    return getList('/products', Product.fromJson);
  }

  Future<Product?> getProduct(int id) async {
    return getOne('/products/$id', Product.fromJson);
  }

  Future<List<Country>> getCountries() async {
    return getList('/locations/countries', Country.fromJson);
  }

  Future<List<State>> getStatesByCountryId(int countryId) async {
    return getList('/locations/states/$countryId', State.fromJson);
  }

  Future<City?> getCityById(int cityId) async {
    return getOne('/locations/cities/$cityId', City.fromJson);
  }

  Future<State?> getStateById(int stateId) async {
    return getOne('/locations/states/$stateId', State.fromJson);
  }

  Future<Country?> getCountryById(int countryId) async {
    return getOne('/locations/countries/$countryId', Country.fromJson);
  }

  Future<List<User>> getInterestedBuyers(int productId) async {
    return getList('/products/$productId/interested', User.fromJson);
  }

  void _handleException(dynamic e) {
    if (e is http.ClientException) {
      throw 'Connection error: Please check if the server is running and accessible';
    } else if (e is FormatException) {
      throw 'Invalid response format from server';
    } else if (e.toString().contains('timeout')) {
      throw 'Connection timeout: Server is taking too long to respond';
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

  // Create new product
  Future<Product> createProduct(Product product) async {
    try {
      final response = await post('/products', product.toJson());
      return Product.fromJson(response);
    } catch (e) {
      _handleException(e);
      rethrow;
    }
  }

  Future<Product> updateProduct(Product product) async {
    try {
      final response = await put('/products/${product.id}', product.toJson());
      return Product.fromJson(response);
    } catch (e) {
      _handleException(e);
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final headers = await getHeaders();
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
      final headers = await getHeaders();
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
      final headers = await getHeaders();
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

  Future<User> updateUser(User user) async {
    try {
      final headers = await getHeaders();
      final response = await http.put(
        Uri.parse('$_baseUrl/users/${user.id}'),
        headers: headers,
        body: json.encode(user.toJson()),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw _handleError(response.statusCode);
      }
    } catch (e) {
      _handleException(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final headers = await getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      ).timeout(timeout);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw _handleError(response.statusCode);
      }
    } catch (e) {
      _handleException(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final headers = await getHeaders();
      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw _handleError(response.statusCode);
      }
    } catch (e) {
      _handleException(e);
      rethrow;
    }
  }
} 