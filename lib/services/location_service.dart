import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location.dart';

class LocationService {
  String _baseUrl;

  LocationService({required String baseUrl}) : _baseUrl = baseUrl;

  Future<List<Country>> getCountries() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/locations/countries'),
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

  Future<List<State>> getStates(int countryId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/locations/states/$countryId'),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => State.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load states: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load states: $e');
    }
  }

  Future<List<City>> getCities(int stateId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/locations/cities/$stateId'),
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
      final response = await http.get(
        Uri.parse('$_baseUrl/locations/cities/search?query=$query'),
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