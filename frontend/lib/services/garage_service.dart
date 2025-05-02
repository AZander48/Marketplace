import 'package:marketplace_app/models/garage_item.dart';
import 'package:marketplace_app/services/api_service.dart';

class GarageService {
  final ApiService _apiService = ApiService();

  Future<List<GarageItem>> getUserGarageItems(int userId) async {
    return _apiService.getList('/garage/$userId', GarageItem.fromJson);
  }

  Future<GarageItem> addGarageItem(int userId, Map<String, dynamic> itemData) async {
    final response = await _apiService.post('/garage/$userId', itemData);
    return GarageItem.fromJson(response);
  }

  Future<void> deleteGarageItem(int userId, int itemId) async {
    await _apiService.delete('/garage/$userId/$itemId');
  }

  Future<GarageItem> updateGarageItem(int userId, int itemId, Map<String, dynamic> itemData) async {
    final response = await _apiService.put('/garage/$userId/$itemId', itemData);
    return GarageItem.fromJson(response);
  }

  Future<GarageItem> setPrimaryVehicle(int userId, int itemId) async {
    final response = await _apiService.put('/garage/$userId/$itemId/primary', {});
    return GarageItem.fromJson(response);
  }

  Future<GarageItem?> getPrimaryVehicle(int userId) async {
    try {
      final response = await _apiService.get('/garage/$userId/primary');
      return response != null ? GarageItem.fromJson(response) : null;
    } catch (e) {
      return null;
    }
  }
} 