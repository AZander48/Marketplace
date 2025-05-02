import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/garage_item.dart';
import '../services/garage_service.dart';
import '../providers/auth_provider.dart';

class GarageScreen extends StatefulWidget {
  const GarageScreen({super.key});

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  final GarageService _garageService = GarageService();
  List<GarageItem> _garageItems = [];
  GarageItem? _primaryVehicle;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGarageItems();
  }

  Future<void> _loadGarageItems() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;
      
      if (user != null) {
        final items = await _garageService.getUserGarageItems(user.id);
        final primary = await _garageService.getPrimaryVehicle(user.id);
        
        if (mounted) {
          setState(() {
            _garageItems = items;
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

  Future<void> _addGarageItem() async {
    final result = await Navigator.pushNamed(context, '/add-garage-item');
    if (result == true) {
      _loadGarageItems();
    }
  }

  Future<void> _deleteGarageItem(GarageItem item) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;
      
      if (user != null) {
        await _garageService.deleteGarageItem(user.id, item.id);
        _loadGarageItems();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting item: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _setPrimaryVehicle(GarageItem item) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;
      
      if (user != null) {
        await _garageService.setPrimaryVehicle(user.id, item.id);
        _loadGarageItems();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error setting primary vehicle: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Garage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addGarageItem,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadGarageItems,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
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
              onPressed: _loadGarageItems,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_garageItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.garage_outlined, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No items in your garage yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addGarageItem,
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_primaryVehicle != null) ...[
          const Text(
            'Primary Vehicle',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildVehicleCard(_primaryVehicle!, true),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/parts');
            },
            icon: const Icon(Icons.build),
            label: const Text('Browse Parts & Accessories'),
          ),
          const SizedBox(height: 24),
        ],
        const Text(
          'All Vehicles',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ..._garageItems.map((item) => _buildVehicleCard(item, false)),
      ],
    );
  }

  Widget _buildVehicleCard(GarageItem item, bool isPrimary) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: item.imageUrl != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(item.imageUrl!),
              )
            : const CircleAvatar(
                child: Icon(Icons.directions_car),
              ),
        title: Text(item.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.vehicleDetails.isNotEmpty)
              Text(
                item.vehicleDetails,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            Text(
              item.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isPrimary)
              IconButton(
                icon: const Icon(Icons.star_border),
                onPressed: () => _setPrimaryVehicle(item),
                tooltip: 'Set as primary vehicle',
              ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteGarageItem(item),
            ),
          ],
        ),
        onTap: () {
          // TODO: Navigate to item details
        },
      ),
    );
  }
} 