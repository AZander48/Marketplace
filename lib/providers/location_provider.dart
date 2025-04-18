import 'package:flutter/foundation.dart';
import '../models/location.dart';
import '../services/location_service.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService;
  List<Country> _countries = [];
  List<LocationState> _states = [];
  List<City> _cities = [];
  bool _isLoading = false;
  String? _error;

  LocationProvider(this._locationService);

  List<Country> get countries => _countries;
  List<LocationState> get states => _states;
  List<City> get cities => _cities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCountries() async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _countries = await _locationService.getCountries();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStates(int countryId) async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _states = await _locationService.getStates(countryId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCities(int stateId) async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cities = await _locationService.getCities(stateId);
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