import '../models/product.dart';
import '../services/api_service.dart';

class RecommendationService {
  final ApiService _apiService = ApiService();

  Future<List<Product>> getRecommendedProducts() async {
    try {
      final response = await _apiService.get('/api/recommendations');
      return (response['products'] as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load recommendations: $e');
    }
  }
} 