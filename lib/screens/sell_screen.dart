import 'package:flutter/material.dart';
import 'package:marketplace_app/screens/add_product_screen.dart';
import 'package:marketplace_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/image_service.dart';
import '../services/auth_service.dart';
import '../services/category_service.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/location.dart';
import '../widgets/location_selector.dart';
import '../providers/auth_provider.dart';
import '../screens/view_product_screen.dart';
import '../providers/location_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SellScreen extends StatefulWidget {
  final Product? product; // If null, we're adding a new product

  const SellScreen({
    super.key,
    this.product,
  });

  @override
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _conditionController = TextEditingController();
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _authService = AuthService();
  final _categoryService = CategoryService();
  String? _imageUrl;
  bool _isLoading = false;
  int? _selectedCountryId;
  int? _selectedStateId;
  int? _selectedCityId;
  int? _selectedCategoryId;
  List<Product> _userProducts = [];
  bool _isLoadingProducts = true;
  List<Category> _categories = [];
  bool _isLoadingCategories = true;
  String? _selectedCountryName;
  String? _selectedStateName;
  String? _selectedCityName;

  @override
  void initState() {
    super.initState();
    _initializeProductData();
    _loadUserProducts();
    _loadCategories();

    // Initialize location data after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      
      try {
        // Always load countries first
        await locationProvider.loadCountries();
        
        // If editing a product, load the full location hierarchy
        if (widget.product?.cityId != null) {
          final apiService = Provider.of<ApiService>(context, listen: false);
          final city = await apiService.getCityById(widget.product!.cityId!);
          
          if (city != null) {
            final state = await apiService.getStateById(city.stateId);
            
            if (state != null) {
              // Load states for the country
              await locationProvider.loadStates(state.countryId);
              
              // Load cities for the state
              await locationProvider.loadCities(city.stateId);
              
              if (mounted) {
                setState(() {
                  _selectedCountryId = state.countryId;
                  _selectedStateId = city.stateId;
                  _selectedCityId = city.id;
                  _selectedCountryName = widget.product?.countryName;
                  _selectedStateName = state.name;
                  _selectedCityName = city.name;
                });
              }
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
      _descriptionController.text = widget.product!.description ?? '';
      _priceController.text = widget.product!.price.toString();
      _conditionController.text = widget.product!.condition ?? '';
      _countryController.text = widget.product!.countryName ?? '';
      _stateController.text = widget.product!.stateName ?? '';
      _cityController.text = widget.product!.cityName ?? '';
      _selectedCityId = widget.product!.cityId;
      _selectedCategoryId = widget.product!.categoryId;
      _imageUrl = widget.product!.imageUrl;
      _selectedCountryName = widget.product!.countryName;
      _selectedStateName = widget.product!.stateName;
      _selectedCityName = widget.product!.cityName;
    }
  }

  @override
  void didUpdateWidget(SellScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product?.id != widget.product?.id) {
      _initializeProductData();
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _categoryService.getCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading categories: $e')),
        );
      }
    }
  }

  Future<void> _loadUserProducts() async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) return;

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

  Future<void> _pickAndUploadImage() async {
    final imageService = ImageService(baseUrl: 'http://10.0.2.2:3000');
    setState(() => _isLoading = true);
    
    try {
      final imageUrl = await imageService.pickAndUploadImage();
      if (imageUrl != null) {
        setState(() => _imageUrl = imageUrl);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      // Create or update product
      var product = Product(
        id: widget.product?.id ?? 0,
        userId: widget.product?.userId ?? 0,
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        categoryId: _selectedCategoryId ?? 0,
        condition: _conditionController.text.isEmpty ? null : _conditionController.text,
        cityId: _selectedCityId,
        imageUrl: _imageUrl,
        sellerName: widget.product?.sellerName,
        categoryName: widget.product?.categoryName,
        createdAt: widget.product?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        cityName: _selectedCityName,
        stateName: _selectedStateName,
        stateCode: widget.product?.stateCode,
        countryName: _selectedCountryName,
        countryCode: widget.product?.countryCode,
      );

      final apiService = Provider.of<ApiService>(context, listen: false);
      
      if (widget.product == null) {
        // Creating a new product
        product = await apiService.createProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product created successfully')),
        );
      } else {
        // Updating an existing product
        product = await apiService.updateProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully')),
        );
      }
      
      if (mounted) {
        // Pop the current screen and return the updated product
        Navigator.pop(context, product);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error ${widget.product == null ? 'creating' : 'updating'} product: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewProductScreen(product: product),
            ),
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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.product == null ? 'Sell Product' : 'Edit Product'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, widget.product);
          },
        ),
      ),
      body: widget.product != null
          ? EditProductScreen(productId: widget.product!.id)
          : _userProducts.isEmpty
              ? const AddProductScreen()
              : ListView.builder(
                  itemCount: _userProducts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddProductScreen(),
                              ),
                            ).then((newProduct) {
                              if (newProduct != null && mounted) {
                                setState(() {
                                  _userProducts.add(newProduct);
                                });
                              }
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add New Product'),
                        ),
                      );
                    }
                    return _buildProductCard(_userProducts[index - 1]);
                  },
                ),
    );
  }
} 