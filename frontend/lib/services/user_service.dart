import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;
import '../config/environment.dart';

class UserService {
  static const Duration timeout = Duration(seconds: 10);

  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${EnvironmentConfig.apiUrl}/users/$userId'),
      ).timeout(timeout, onTimeout: () {
        throw TimeoutException('Request timed out. Please check your internet connection and try again.');
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode}');
      }
    } catch (e) {
      foundation.debugPrint('Error loading user profile: $e');
      if (e is TimeoutException) {
        throw Exception('Request timed out. Please check your internet connection and try again.');
      }
      throw Exception('Error loading user profile: $e');
    }
  }

  Future<double> getUserRating(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${EnvironmentConfig.apiUrl}/users/$userId/rating'),
      ).timeout(timeout, onTimeout: () {
        throw TimeoutException('Request timed out. Please check your internet connection and try again.');
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['average_rating'] ?? 0.0).toDouble();
      } else {
        throw Exception('Failed to load user rating: ${response.statusCode}');
      }
    } catch (e) {
      foundation.debugPrint('Error loading user rating: $e');
      if (e is TimeoutException) {
        throw Exception('Request timed out. Please check your internet connection and try again.');
      }
      return 0.0;
    }
  }
} 