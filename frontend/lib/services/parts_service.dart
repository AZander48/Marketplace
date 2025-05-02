import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/garage_item.dart';
import '../config/environment.dart';

class PartsService {
  static String baseUrl = EnvironmentConfig.apiUrl; // Use 10.0.2.2 for Android emulator

  Future<List<Map<String, dynamic>>> getPartsByCategoryAndVehicle({
    required int categoryId,
    required GarageItem vehicle,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/parts').replace(
        queryParameters: {
          'categoryId': categoryId.toString(),
          'vehicleId': vehicle.id.toString(),
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        final error = json.decode(response.body)['error'] ?? 'Unknown error';
        throw Exception('Failed to load parts: $error');
      }
    } on http.ClientException catch (e) {
      throw Exception('Failed to connect to server. Please check your internet connection and server status.');
    } catch (e) {
      throw Exception('Failed to load parts: $e');
    }
  }
} 