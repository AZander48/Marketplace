import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/product_grid.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  List<Product> _userProducts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserProducts();
  }

  Future<void> _loadUserProducts() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;
      
      if (user != null) {
        final products = await _apiService.getUserProducts(user.id);
        if (mounted) {
          setState(() {
            _userProducts = products;
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

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;

        if (user == null) {
          return const Center(child: Text('Please log in to view your profile'));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/settings',
                    );
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _loadUserProducts,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: user.profileImageUrl != null
                              ? NetworkImage(user.profileImageUrl!)
                              : null,
                          child: user.profileImageUrl == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.name ?? 'No name',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        if (user.formattedLocation.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            user.formattedLocation,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              '/edit-profile',
                              arguments: user,
                            );
                            if (result == true) {
                              _loadUserProducts();
                            }
                          },
                          child: const Text('Edit Profile'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  _buildStats(),
                  const Divider(),
                  _buildUserListings(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Listings', _userProducts.length.toString()),
          _buildStatItem('Views', '0'), // TODO: Implement view count
          _buildStatItem('Rating', '4.5'), // TODO: Implement rating
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildUserListings() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text(
          'Error loading listings: $_error',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (_userProducts.isEmpty) {
      return const Center(
        child: Text('No listings yet'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Your Listings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ProductGrid(
          products: _userProducts,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }
} 