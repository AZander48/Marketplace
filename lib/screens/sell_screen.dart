import 'package:flutter/material.dart';
import 'package:marketplace_app/screens/add_product_screen.dart';
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
    }
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
        await apiService.createProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product created successfully')),
        );
      } else {
        // Updating an existing product
        await apiService.updateProduct(product);
        // Fetch the updated product data
        final updatedProduct = await apiService.getProduct(product.id);
        if (updatedProduct != null) {
          product = updatedProduct;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully')),
        );
      }
      
      if (mounted) {
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

  Widget _buildAddProductForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[100],
              labelStyle: TextStyle(color: Colors.grey[700]),
            ),
            style: const TextStyle(color: Colors.black87),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[100],
              labelStyle: TextStyle(color: Colors.grey[700]),
            ),
            style: const TextStyle(color: Colors.black87),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _priceController,
            decoration: InputDecoration(
              labelText: 'Price',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[100],
              labelStyle: TextStyle(color: Colors.grey[700]),
            ),
            style: const TextStyle(color: Colors.black87),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a price';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid price';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: _selectedCategoryId,
            decoration: InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[100],
              labelStyle: TextStyle(color: Colors.grey[700]),
            ),
            items: _categories.map((category) {
              return DropdownMenuItem<int>(
                value: category.id,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategoryId = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a category';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _conditionController.text.isEmpty ? null : _conditionController.text,
                decoration: const InputDecoration(
                  labelText: 'Condition',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'New', child: Text('New')),
                  DropdownMenuItem(value: 'Like New', child: Text('Like New')),
                  DropdownMenuItem(value: 'Good', child: Text('Good')),
                  DropdownMenuItem(value: 'Fair', child: Text('Fair')),
                  DropdownMenuItem(value: 'Poor', child: Text('Poor')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    _conditionController.text = value;
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a condition';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              LocationSelector(
                selectedCountryId: _selectedCountryId,
                selectedStateId: _selectedStateId,
                selectedCityId: _selectedCityId,
                onCountrySelected: _onCountrySelected,
                onStateSelected: _onStateSelected,
                onCitySelected: _onCitySelected,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: _imageUrl!,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _pickAndUploadImage,
            icon: const Icon(Icons.upload),
            label: Text(_imageUrl == null ? 'Upload Image' : 'Change Image'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const CircularProgressIndicator()
                : Text(widget.product == null ? 'Create Product' : 'Update Product'),
          ),
        ],
      ),
    );
  }

  void _onCountrySelected(Country? country) async {
    if (country == null) return;
    setState(() {
      _selectedCountryId = country.id;
      _selectedCountryName = country.name;
      _selectedStateId = null;
      _selectedStateName = null;
      _selectedCityId = null;
      _selectedCityName = null;
    });
    await context.read<LocationProvider>().loadStates(country.id);
  }

  void _onStateSelected(LocationState? state) async {
    if (state == null) return;
    setState(() {
      _selectedStateId = state.id;
      _selectedStateName = state.name;
      _selectedCityId = null;
      _selectedCityName = null;
    });
    await context.read<LocationProvider>().loadCities(state.id);
  }

  void _onCitySelected(City? city) {
    if (city == null) return;
    setState(() {
      _selectedCityId = city.id;
      _selectedCityName = city.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProducts) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: widget.product != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildAddProductForm(),
            )
          : _userProducts.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildAddProductForm(),
                )
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
                            );
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