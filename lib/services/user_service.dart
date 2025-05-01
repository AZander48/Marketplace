import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;

class UserService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  static const Duration timeout = Duration(seconds: 30);

  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode}');
      }
    } catch (e) {
      foundation.debugPrint('Error loading user profile: $e');
      throw Exception('Error loading user profile: $e');
    }
  }

  Future<double> getUserRating(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/rating'),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['average_rating'] ?? 0.0).toDouble();
      } else {
        throw Exception('Failed to load user rating: ${response.statusCode}');
      }
    } catch (e) {
      foundation.debugPrint('Error loading user rating: $e');
      return 0.0;
    }
  }
} 