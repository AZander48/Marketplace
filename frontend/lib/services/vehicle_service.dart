import 'package:marketplace_app/services/api_service.dart';

class VehicleService {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> getVehicleTypes() async {
    final response = await _apiService.get('/vehicles/types');
    return (response['types'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getVehicleMakes(int typeId) async {
    final response = await _apiService.get('/vehicles/makes/$typeId');
    return (response['makes'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getVehicleModels(int makeId) async {
    final response = await _apiService.get('/vehicles/models/$makeId');
    return (response['models'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getVehicleSubmodels(int modelId) async {
    final response = await _apiService.get('/vehicles/submodels/$modelId');
    return (response['submodels'] as List).cast<Map<String, dynamic>>();
  }

  List<int> getVehicleYears() {
    final currentYear = DateTime.now().year;
    return List.generate(30, (index) => currentYear - index);
  }

  Future<Map<String, dynamic>> addVehicleType(String name) async {
    final response = await _apiService.post('/vehicles/types', {'name': name});
    return response;
  }

  Future<Map<String, dynamic>> addVehicleMake(int typeId, String name) async {
    final response = await _apiService.post('/vehicles/makes', {
      'typeId': typeId,
      'name': name,
    });
    return response;
  }

  Future<Map<String, dynamic>> addVehicleModel(int makeId, String name) async {
    final response = await _apiService.post('/vehicles/models', {
      'makeId': makeId,
      'name': name,
    });
    return response;
  }

  Future<Map<String, dynamic>> addVehicleSubmodel(int modelId, String name) async {
    final response = await _apiService.post('/vehicles/submodels', {
      'modelId': modelId,
      'name': name,
    });
    return response;
  }
} 