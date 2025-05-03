import 'package:flutter/foundation.dart';

enum Environment {
  development,
  production,
}

class EnvironmentConfig {
  static const Environment _currentEnvironment = Environment.development;  // Set to production

  static const Map<Environment, String> _baseUrls = {
    Environment.development: 'http://10.0.2.2:3000',  // For Android emulator
    Environment.production: 'https://marketplace-backend-jv7c.onrender.com',
  };

  static const Map<Environment, String> _apiUrls = {
    Environment.development: 'http://10.0.2.2:3000/api',
    Environment.production: 'https://marketplace-backend-jv7c.onrender.com/api',
  };

  static String get baseUrl => _baseUrls[_currentEnvironment]!;
  static String get apiUrl => _apiUrls[_currentEnvironment]!;
  static bool get isDevelopment => _currentEnvironment == Environment.development;
  static bool get isProduction => _currentEnvironment == Environment.production;

  // Helper method to get the current environment
  static Environment get currentEnvironment => _currentEnvironment;
} 