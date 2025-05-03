class ApiConfig {
  // Replace with your deployed server URL
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://marketplace-backend.onrender.com/api',
  );
} 