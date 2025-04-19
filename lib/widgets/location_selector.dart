import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/location.dart';
import '../providers/location_provider.dart';

class LocationSelector extends StatefulWidget {
  final int? selectedCountryId;
  final int? selectedStateId;
  final int? selectedCityId;
  final Function(Country?)? onCountrySelected;
  final Function(LocationState?)? onStateSelected;
  final Function(City?)? onCitySelected;
  final bool isViewOnly;

  const LocationSelector({
    super.key,
    this.selectedCountryId,
    this.selectedStateId,
    this.selectedCityId,
    this.onCountrySelected,
    this.onStateSelected,
    this.onCitySelected,
    this.isViewOnly = false,
  });

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  bool _isInitialized = false;
  Country? _selectedCountry;
  LocationState? _selectedState;
  City? _selectedCity;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    if (_isInitialized) return;
    
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    await locationProvider.loadCountries();
    
    if (widget.selectedCountryId != null) {
      await locationProvider.loadStates(widget.selectedCountryId!);
    }
    if (widget.selectedStateId != null) {
      await locationProvider.loadCities(widget.selectedStateId!);
    }
    
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        if (!_isInitialized || locationProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (locationProvider.error != null) {
          return Center(
            child: Text(
              'Error: ${locationProvider.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return Column(
          children: [
            DropdownButtonFormField<Country>(
              value: _selectedCountry,
              decoration: const InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(),
              ),
              items: locationProvider.countries.map((country) {
                return DropdownMenuItem<Country>(
                  value: country,
                  child: Text(country.name),
                );
              }).toList(),
              onChanged: widget.isViewOnly
                  ? null
                  : (Country? country) async {
                      if (country != null) {
                        setState(() {
                          _selectedCountry = country;
                          _selectedState = null;
                          _selectedCity = null;
                        });
                        await locationProvider.loadStates(country.id);
                        locationProvider.clearCities();
                        if (widget.onCountrySelected != null) {
                          widget.onCountrySelected!(country);
                        }
                      }
                    },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<LocationState>(
              value: _selectedState,
              decoration: const InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
              ),
              items: locationProvider.states.map((state) {
                return DropdownMenuItem<LocationState>(
                  value: state,
                  child: Text(state.name),
                );
              }).toList(),
              onChanged: widget.isViewOnly || _selectedCountry == null
                  ? null
                  : (LocationState? state) async {
                      if (state != null) {
                        setState(() {
                          _selectedState = state;
                          _selectedCity = null;
                        });
                        await locationProvider.loadCities(state.id);
                        if (widget.onStateSelected != null) {
                          widget.onStateSelected!(state);
                        }
                      }
                    },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<City>(
              value: _selectedCity,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              items: locationProvider.cities.map((city) {
                return DropdownMenuItem<City>(
                  value: city,
                  child: Text(city.name),
                );
              }).toList(),
              onChanged: widget.isViewOnly || _selectedState == null
                  ? null
                  : (City? city) {
                      if (city != null) {
                        setState(() {
                          _selectedCity = city;
                        });
                        if (widget.onCitySelected != null) {
                          widget.onCitySelected!(city);
                        }
                      }
                    },
            ),
          ],
        );
      },
    );
  }
} 