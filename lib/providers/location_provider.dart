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

  Country? _selectedCountry;
  LocationState? _selectedState;
  City? _selectedCity;

  LocationProvider(this._locationService);

  List<Country> get countries => _countries;
  List<LocationState> get states => _states;
  List<City> get cities => _cities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Country? get selectedCountry => _selectedCountry;
  LocationState? get selectedState => _selectedState;
  City? get selectedCity => _selectedCity;

  Future<void> selectCountry(Country country) async {
    _selectedCountry = country;
    _selectedState = null;
    _selectedCity = null;
    clearStates();
    clearCities();
    notifyListeners();
    await loadStates(country.id);
  }

  Future<void> selectState(LocationState state) async {
    _selectedState = state;
    _selectedCity = null;
    clearCities();
    notifyListeners();
    await loadCities(state.id);
  }

  void selectCity(City city) {
    _selectedCity = city;
    notifyListeners();
  }

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

  void clearSelection() {
    _selectedCountry = null;
    _selectedState = null;
    _selectedCity = null;
    clearStates();
    clearCities();
    notifyListeners();
  }
} 