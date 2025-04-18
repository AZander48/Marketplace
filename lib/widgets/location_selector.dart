import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/location.dart' as location_models;
import '../providers/location_provider.dart';

class LocationSelector extends StatefulWidget {
  final String baseUrl;
  final int? selectedCountryId;
  final int? selectedStateId;
  final int? selectedCityId;
  final Function(int?) onCountrySelected;
  final Function(int?) onStateSelected;
  final Function(int?) onCitySelected;
  final bool isViewOnly;

  const LocationSelector({
    super.key,
    required this.baseUrl,
    this.selectedCountryId,
    this.selectedStateId,
    this.selectedCityId,
    required this.onCountrySelected,
    required this.onStateSelected,
    required this.onCitySelected,
    this.isViewOnly = false,
  });

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  List<location_models.Country> _countries = [];
  List<location_models.State> _states = [];
  List<location_models.City> _cities = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCountries();
      if (widget.selectedCountryId != null) {
        _loadStates(widget.selectedCountryId!);
      }
      if (widget.selectedStateId != null) {
        _loadCities(widget.selectedStateId!);
      }
    });
  }

  Future<void> _loadCountries() async {
    setState(() => _isLoading = true);
    try {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      await locationProvider.loadCountries();
      setState(() {
        _countries = locationProvider.countries;
        _error = locationProvider.error;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadStates(int countryId) async {
    setState(() => _isLoading = true);
    try {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      await locationProvider.loadStates(countryId);
      setState(() {
        _states = locationProvider.states;
        _error = locationProvider.error;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCities(int stateId) async {
    setState(() => _isLoading = true);
    try {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      await locationProvider.loadCities(stateId);
      setState(() {
        _cities = locationProvider.cities;
        _error = locationProvider.error;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Text('Error: $_error');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<int>(
          value: widget.selectedCountryId,
          decoration: const InputDecoration(
            labelText: 'Country',
            border: OutlineInputBorder(),
          ),
          items: _countries.map((country) {
            return DropdownMenuItem<int>(
              value: country.id,
              child: Text(country.name),
            );
          }).toList(),
          onChanged: widget.isViewOnly ? null : (value) {
            widget.onCountrySelected(value);
            if (value != null) {
              _loadStates(value);
            }
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a country';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          value: widget.selectedStateId,
          decoration: const InputDecoration(
            labelText: 'State/Province',
            border: OutlineInputBorder(),
          ),
          items: _states.map((state) {
            return DropdownMenuItem<int>(
              value: state.id,
              child: Text(state.name),
            );
          }).toList(),
          onChanged: widget.isViewOnly ? null : (value) {
            widget.onStateSelected(value);
            if (value != null) {
              _loadCities(value);
            }
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a state/province';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          value: widget.selectedCityId,
          decoration: const InputDecoration(
            labelText: 'City',
            border: OutlineInputBorder(),
          ),
          items: _cities.map((city) {
            return DropdownMenuItem<int>(
              value: city.id,
              child: Text(city.name),
            );
          }).toList(),
          onChanged: widget.isViewOnly ? null : widget.onCitySelected,
          validator: (value) {
            if (value == null) {
              return 'Please select a city';
            }
            return null;
          },
        ),
      ],
    );
  }
} 