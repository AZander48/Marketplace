import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/garage_item.dart';
import '../services/garage_service.dart';
import '../providers/auth_provider.dart';

class PartsScreen extends StatefulWidget {
  const PartsScreen({super.key});

  @override
  State<PartsScreen> createState() => _PartsScreenState();
}

class _PartsScreenState extends State<PartsScreen> {
  final GarageService _garageService = GarageService();
  final TextEditingController _searchController = TextEditingController();
  GarageItem? _primaryVehicle;
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  // Sample part categories - you can replace these with actual categories from your backend
  final List<Map<String, dynamic>> _partCategories = [
    {'id': 1, 'name': 'Engine', 'icon': Icons.engineering},
    {'id': 2, 'name': 'Transmission', 'icon': Icons.settings},
    {'id': 3, 'name': 'Suspension', 'icon': Icons.air},
    {'id': 4, 'name': 'Brakes', 'icon': Icons.stop_circle},
    {'id': 5, 'name': 'Electrical', 'icon': Icons.electric_bolt},
    {'id': 6, 'name': 'Interior', 'icon': Icons.chair},
    {'id': 7, 'name': 'Exterior', 'icon': Icons.directions_car},
    {'id': 8, 'name': 'Wheels & Tires', 'icon': Icons.tire_repair},
  ];

  @override
  void initState() {
    super.initState();
    _loadPrimaryVehicle();
  }

  @override
  void dispose() {
    _searchController.dispose();
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

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onCategorySelected(Map<String, dynamic> category) {
    // TODO: Navigate to category details or show filtered results
    print('Selected category: ${category['name']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parts & Accessories'),
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
                        onPressed: _loadPrimaryVehicle,
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
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search parts...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearchChanged('');
                                  },
                                )
                              : null,
                        ),
                        onChanged: _onSearchChanged,
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
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
                      ),
                    ),
                  ],
                ),
    );
  }
} 