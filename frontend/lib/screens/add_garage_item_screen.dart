import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/garage_item.dart';
import '../services/garage_service.dart';
import '../services/vehicle_service.dart';
import '../providers/auth_provider.dart';

class AddGarageItemScreen extends StatefulWidget {
  const AddGarageItemScreen({super.key});

  @override
  State<AddGarageItemScreen> createState() => _AddGarageItemScreenState();
}

class _AddGarageItemScreenState extends State<AddGarageItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _garageService = GarageService();
  final _vehicleService = VehicleService();
  bool _isLoading = false;

  // Dropdown values
  Map<String, dynamic>? _selectedVehicleType;
  int? _selectedYear;
  Map<String, dynamic>? _selectedMake;
  Map<String, dynamic>? _selectedModel;
  Map<String, dynamic>? _selectedSubmodel;

  // Dropdown options
  List<Map<String, dynamic>> _vehicleTypes = [];
  List<int> _years = [];
  List<Map<String, dynamic>> _makes = [];
  List<Map<String, dynamic>> _models = [];
  List<Map<String, dynamic>> _submodels = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final types = await _vehicleService.getVehicleTypes();
      final years = _vehicleService.getVehicleYears();

      setState(() {
        _vehicleTypes = types;
        _years = years;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading vehicle data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadMakes(int typeId) async {
    try {
      final makes = await _vehicleService.getVehicleMakes(typeId);
      setState(() {
        _makes = makes;
        _selectedMake = null;
        _models = [];
        _selectedModel = null;
        _submodels = [];
        _selectedSubmodel = null;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading makes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadModels(int makeId) async {
    try {
      final models = await _vehicleService.getVehicleModels(makeId);
      setState(() {
        _models = models;
        _selectedModel = null;
        _submodels = [];
        _selectedSubmodel = null;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading models: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadSubmodels(int modelId) async {
    try {
      final submodels = await _vehicleService.getVehicleSubmodels(modelId);
      setState(() {
        _submodels = submodels;
        _selectedSubmodel = null;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading submodels: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _generateVehicleName() {
    if (_selectedYear == null || _selectedMake == null || _selectedModel == null) {
      return '';
    }
    return '$_selectedYear ${_selectedMake!['name']} ${_selectedModel!['name']}';
  }

  String _generateVehicleDescription() {
    final parts = <String>[];
    
    if (_selectedYear != null) {
      parts.add('$_selectedYear');
    }
    if (_selectedMake != null) {
      parts.add(_selectedMake!['name']);
    }
    if (_selectedModel != null) {
      parts.add(_selectedModel!['name']);
    }
    if (_selectedSubmodel != null) {
      parts.add(_selectedSubmodel!['name']);
    }
    
    return parts.join(' ');
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;
      
      if (user != null) {
        await _garageService.addGarageItem(
          user.id,
          {
            'name': _generateVehicleName(),
            'description': _generateVehicleDescription(),
            'vehicle_type_id': _selectedVehicleType?['id'],
            'vehicle_year': _selectedYear,
            'vehicle_make_id': _selectedMake?['id'],
            'vehicle_model_id': _selectedModel?['id'],
            'vehicle_submodel_id': _selectedSubmodel?['id'],
          },
        );
        
        if (mounted) {
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding item: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vehicle to Garage'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  DropdownButtonFormField<Map<String, dynamic>>(
                    value: _selectedVehicleType,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Type',
                    ),
                    items: _vehicleTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedVehicleType = value;
                      });
                      if (value != null) {
                        _loadMakes(value['id']);
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a vehicle type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: _selectedYear,
                    decoration: const InputDecoration(
                      labelText: 'Year',
                    ),
                    items: _years.map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedYear = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a year';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Map<String, dynamic>>(
                    value: _selectedMake,
                    decoration: const InputDecoration(
                      labelText: 'Make',
                    ),
                    items: _makes.map((make) {
                      return DropdownMenuItem(
                        value: make,
                        child: Text(make['name']),
                      );
                    }).toList(),
                    onChanged: _selectedVehicleType == null
                        ? null
                        : (value) {
                            setState(() {
                              _selectedMake = value;
                            });
                            if (value != null) {
                              _loadModels(value['id']);
                            }
                          },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a make';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Map<String, dynamic>>(
                    value: _selectedModel,
                    decoration: const InputDecoration(
                      labelText: 'Model',
                    ),
                    items: _models.map((model) {
                      return DropdownMenuItem(
                        value: model,
                        child: Text(model['name']),
                      );
                    }).toList(),
                    onChanged: _selectedMake == null
                        ? null
                        : (value) {
                            setState(() {
                              _selectedModel = value;
                            });
                            if (value != null) {
                              _loadSubmodels(value['id']);
                            }
                          },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a model';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Map<String, dynamic>>(
                    value: _selectedSubmodel,
                    decoration: const InputDecoration(
                      labelText: 'Submodel',
                    ),
                    items: _submodels.map((submodel) {
                      return DropdownMenuItem(
                        value: submodel,
                        child: Text(submodel['name']),
                      );
                    }).toList(),
                    onChanged: _selectedModel == null
                        ? null
                        : (value) {
                            setState(() {
                              _selectedSubmodel = value;
                            });
                          },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Add Vehicle'),
                  ),
                ],
              ),
            ),
    );
  }
} 