import 'package:flutter/material.dart';
import 'package:marketplace_app/screens/add_product_screen.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/product.dart';
import '../providers/location_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SellScreen extends StatefulWidget {
  final Product? product; // If null, we're adding a new product

  const SellScreen({
    super.key,
    this.product,
  });

  @override
  SellScreenState createState() => SellScreenState();
}

class SellScreenState extends State<SellScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _conditionController = TextEditingController();
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _authService = AuthService();
  final bool _isLoading = false;
  List<Product> _userProducts = [];
  bool _isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    _initializeProductData();
    _loadUserProducts();

    // Initialize location data after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      
      try {
        // Always load countries first
        await locationProvider.loadCountries();
        
        // If editing a product, load the full location hierarchy
        if (widget.product?.cityId != null) {
          if (!mounted) return;
          final apiService = Provider.of<ApiService>(context, listen: false);
          final city = await apiService.getCityById(widget.product!.cityId!);
          
          if (city != null) {
            if (!mounted) return;
            final state = await apiService.getStateById(city.stateId);
            
            if (state != null) {
              // Load states for the country
              await locationProvider.loadStates(state.countryId);
              
              // Load cities for the state
              await locationProvider.loadCities(city.stateId);
            }
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading location data: $e')),
          );
        }
      }
    });
  }

  void _initializeProductData() {
    if (widget.product != null) {
      _titleController.text = widget.product!.title;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _conditionController.text = widget.product!.condition ?? '';
      _countryController.text = widget.product!.countryName ?? '';
      _stateController.text = widget.product!.stateName ?? '';
      _cityController.text = widget.product!.cityName ?? '';
    }
  }

  @override
  void didUpdateWidget(SellScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product?.id != widget.product?.id) {
      _initializeProductData();
    }
  }

  Future<void> _loadUserProducts() async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) return;

      if (!mounted) return;
      final apiService = Provider.of<ApiService>(context, listen: false);
      final products = await apiService.getUserProducts(currentUser.id);
      
      if (mounted) {
        setState(() {
          _userProducts = products;
          _isLoadingProducts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProducts = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading products: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _conditionController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/view',
            arguments: product.id,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.imageUrl != null)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.formattedLocation,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProducts) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (widget.product != null) {
      // Navigate to edit screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(
          context,
          '/edit',
          arguments: widget.product!.id,
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.product == null ? 'Sell Product' : 'Edit Product'),
      ),
      body: _userProducts.isEmpty
          ? const AddProductScreen()
          : ListView.builder(
              itemCount: _userProducts.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () {
                        Navigator.pushNamed(
                          context,
                          '/add',
                        ).then((newProduct) {
                          if (newProduct != null && mounted) {
                            // Reload all products to ensure we have the latest data
                            _loadUserProducts();
                          }
                        });
                      },
                      icon: _isLoading 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.add),
                      label: Text(_isLoading ? 'Loading...' : 'Add New Product'),
                    ),
                  );
                }
                return _buildProductCard(_userProducts[index - 1]);
              },
      ),
    );
  }
} 