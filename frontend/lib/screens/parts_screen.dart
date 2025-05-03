import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/garage_item.dart';
import '../services/garage_service.dart';
import '../services/parts_service.dart';
import '../providers/auth_provider.dart';
import '../models/category.dart';

class PartsScreen extends StatefulWidget {
  const PartsScreen({super.key});

  @override
  State<PartsScreen> createState() => _PartsScreenState();
}

class _PartsScreenState extends State<PartsScreen> {
  final GarageService _garageService = GarageService();
  final PartsService _partsService = PartsService();
  GarageItem? _primaryVehicle;
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _selectedCategory;
  List<Map<String, dynamic>> _parts = [];

  // Sample part categories - you can replace these with actual categories from your backend
  final List<Map<String, dynamic>> _partCategories = [
    {'id': 10, 'name': 'Vehicle Parts', 'icon': Icons.directions_car},
    {'id': 11, 'name': 'Engine Parts', 'icon': Icons.engineering},
    {'id': 12, 'name': 'Transmission', 'icon': Icons.settings},
    {'id': 13, 'name': 'Suspension', 'icon': Icons.air},
    {'id': 14, 'name': 'Brakes', 'icon': Icons.stop_circle},
    {'id': 15, 'name': 'Electrical', 'icon': Icons.electric_bolt},
    {'id': 16, 'name': 'Interior', 'icon': Icons.chair},
    {'id': 17, 'name': 'Exterior', 'icon': Icons.directions_car},
    {'id': 18, 'name': 'Wheels & Tires', 'icon': Icons.tire_repair},
    {'id': 19, 'name': 'Performance', 'icon': Icons.speed},
    {'id': 20, 'name': 'Maintenance', 'icon': Icons.build},
  ];

  @override
  void initState() {
    super.initState();
    _loadPrimaryVehicle();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadPrimaryVehicle() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;
      
      if (user != null) {
        final primary = await _garageService.getPrimaryVehicle(user.id);
        if (mounted) {
          setState(() {
            _primaryVehicle = primary;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadPartsForCategory(Map<String, dynamic> category) async {
    if (_primaryVehicle == null) {
      setState(() {
        _error = 'Please select a vehicle first';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _selectedCategory = category;
      _isLoading = true;
      _error = null;
    });

    try {
      final parts = await _partsService.getPartsByCategoryAndVehicle(
        categoryId: category['id'],
        vehicle: _primaryVehicle!,
      );
      
      setState(() {
        _parts = parts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onCategorySelected(Map<String, dynamic> category) {
    Navigator.pushNamed(
      context,
      '/category',
      arguments: {
        'category': Category(
          id: category['id'],
          name: category['name'],
          description: 'Browse ${category['name']} for your vehicle',
        ),
        'vehicleId': _primaryVehicle?.id,
      },
    );
  }

  void _onBackPressed() {
    setState(() {
      _selectedCategory = null;
      _parts = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedCategory?['name'] ?? 'Parts & Accessories'),
        leading: _selectedCategory != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _onBackPressed,
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 60),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _selectedCategory != null
                            ? () => _loadPartsForCategory(_selectedCategory!)
                            : _loadPrimaryVehicle,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    if (_primaryVehicle != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Row(
                          children: [
                            const Icon(Icons.directions_car),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Parts for:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    _primaryVehicle!.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/garage');
                              },
                              child: const Text('Change'),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: _selectedCategory == null
                          ? GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.5,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: _partCategories.length,
                              itemBuilder: (context, index) {
                                final category = _partCategories[index];
                                return Card(
                                  child: InkWell(
                                    onTap: () => _onCategorySelected(category),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            category['icon'] as IconData,
                                            size: 32,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            category['name'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : _parts.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No parts found in this category',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _parts.length,
                                  itemBuilder: (context, index) {
                                    final part = _parts[index];
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            color: Colors.grey[200],
                                            child: part['image_url'] != null
                                                ? Image.network(
                                                    part['image_url'],
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return const Icon(Icons.image_not_supported);
                                                    },
                                                  )
                                                : const Icon(Icons.image_not_supported),
                                          ),
                                        ),
                                        title: Text(
                                          part['name'] ?? 'Unnamed Part',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(part['description'] ?? 'No description available'),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    part['condition'] ?? 'Unknown',
                                                    style: TextStyle(
                                                      color: Theme.of(context).primaryColor,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  '\$${double.tryParse(part['price'].toString())?.toStringAsFixed(2) ?? '0.00'}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          // TODO: Navigate to part details screen
                                        },
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
    );
  }
} 