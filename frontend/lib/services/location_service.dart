import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location.dart';

class LocationService {
  final String baseUrl;
  final http.Client client;

  LocationService({required this.baseUrl, required this.client});

  Future<List<Country>> getCountries() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/locations/countries'),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Country.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load countries: $e');
    }
  }

  Future<List<LocationState>> getStates(int countryId) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/locations/states/$countryId'),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => LocationState.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load states: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load states: $e');
    }
  }

  Future<List<City>> getCities(int stateId) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/locations/cities/$stateId'),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => City.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load cities: $e');
    }
  }

  Future<List<City>> searchCities(String query) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/locations/cities/search?query=$query'),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => City.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search cities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search cities: $e');
    }
  }
} 