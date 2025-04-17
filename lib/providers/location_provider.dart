import 'package:flutter/foundation.dart';
import '../models/location.dart';
import '../services/location_service.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService;
  List<Country> _countries = [];
  List<State> _states = [];
  List<City> _cities = [];
  bool _isLoading = false;
  String? _error;

  LocationProvider({required LocationService locationService})
      : _locationService = locationService;

  List<Country> get countries => _countries;
  List<State> get states => _states;
  List<City> get cities => _cities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCountries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _countries = await _locationService.getCountries();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStates(int countryId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _states = await _locationService.getStates(countryId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCities(int stateId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cities = await _locationService.getCities(stateId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<City>> searchCities(String query) async {
    try {
      return await _locationService.searchCities(query);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  void clearStates() {
    _states = [];
    notifyListeners();
  }

  void clearCities() {
    _cities = [];
    notifyListeners();
  }
} 