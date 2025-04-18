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
              value: widget.selectedCountryId != null && locationProvider.countries.isNotEmpty
                  ? locationProvider.countries.firstWhere(
                      (c) => c.id == widget.selectedCountryId,
                      orElse: () => locationProvider.countries.first,
                    )
                  : null,
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
                      if (country != null && widget.onCountrySelected != null) {
                        widget.onCountrySelected!(country);
                        await locationProvider.loadStates(country.id);
                      }
                    },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<LocationState>(
              value: widget.selectedStateId != null && locationProvider.states.isNotEmpty
                  ? locationProvider.states.firstWhere(
                      (s) => s.id == widget.selectedStateId,
                      orElse: () => locationProvider.states.first,
                    )
                  : null,
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
              onChanged: widget.isViewOnly
                  ? null
                  : (LocationState? state) async {
                      if (state != null && widget.onStateSelected != null) {
                        widget.onStateSelected!(state);
                        await locationProvider.loadCities(state.id);
                      }
                    },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<City>(
              value: widget.selectedCityId != null && locationProvider.cities.isNotEmpty
                  ? locationProvider.cities.firstWhere(
                      (c) => c.id == widget.selectedCityId,
                      orElse: () => locationProvider.cities.first,
                    )
                  : null,
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
              onChanged: widget.isViewOnly
                  ? null
                  : (City? city) {
                      if (city != null && widget.onCitySelected != null) {
                        widget.onCitySelected!(city);
                      }
                    },
            ),
          ],
        );
      },
    );
  }
} 