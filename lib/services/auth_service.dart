import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  static const Duration timeout = Duration(seconds: 30);
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Get the current user from shared preferences
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    return User.fromJson(json.decode(userJson));
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null && user.token != null;
  }

  // Login user
  Future<User> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final user = User.fromJson(json.decode(response.body));
        await _saveUser(user);
        return user;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  // Register user
  Future<User> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      ).timeout(timeout);

      if (response.statusCode == 201) {
        final user = User.fromJson(json.decode(response.body));
        await _saveUser(user);
        return user;
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      throw Exception('Error registering: $e');
    }
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // Save user data to shared preferences
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    if (user.token != null) {
      await prefs.setString(_tokenKey, user.token!);
    }
  }
} 