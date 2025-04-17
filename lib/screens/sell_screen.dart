import 'package:flutter/material.dart';
import 'package:marketplace_app/screens/add_product_screen.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/image_service.dart';
import '../services/auth_service.dart';
import '../models/product.dart';
import '../widgets/location_selector.dart';
import '../providers/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SellScreen extends StatefulWidget {
  final Product? product; // If null, we're adding a new product
  final bool isViewOnly; // If true, we're just viewing the product

  const SellScreen({
    super.key,
    this.product,
    this.isViewOnly = false,
  });

  @override
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _conditionController = TextEditingController();
  final _locationController = TextEditingController();
  final _authService = AuthService();
  String? _imageUrl;
  bool _isLoading = false;
  int? _selectedCountryId;
  int? _selectedStateId;
  int? _selectedCityId;
  List<Product> _userProducts = [];
  bool _isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _titleController.text = widget.product!.title;
      _descriptionController.text = widget.product!.description ?? '';
      _priceController.text = widget.product!.price.toString();
      _categoryController.text = widget.product!.categoryName ?? '';
      _conditionController.text = widget.product!.condition ?? '';
      _selectedCityId = widget.product!.cityId;
      _imageUrl = widget.product!.imageUrl;
      
      // Load the location hierarchy
      _loadLocationHierarchy();
    }
    _loadUserProducts();
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

  Future<void> _loadLocationHierarchy() async {
    if (widget.product?.cityId == null) return;
    
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      // Get city details
      final city = await apiService.getCityById(widget.product!.cityId!);
      if (city != null) {
        setState(() {
          _selectedCityId = city.id;
          _selectedStateId = city.stateId;
        });
        
        // Get state details
        final state = await apiService.getStateById(city.stateId);
        if (state != null) {
          setState(() {
            _selectedCountryId = state.countryId;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading location: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _conditionController.dispose();
    _locationController.dispose();
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

    setState(() => _isLoading = true);
    
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      if (_selectedCityId == null) {
        throw Exception('Please select a location');
      }

      final product = Product(
        id: widget.product?.id ?? 0,
        userId: currentUser.id,
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        categoryId: int.parse(_categoryController.text),
        condition: _conditionController.text,
        cityId: _selectedCityId!,  // Use selected city ID
        imageUrl: _imageUrl,
        sellerName: currentUser.username,
        categoryName: widget.product?.categoryName ?? '',
        createdAt: widget.product?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final apiService = Provider.of<ApiService>(context, listen: false);
      
      if (widget.product == null) {
        // Creating a new product
        await apiService.createProduct(product);
      } else {
        // Updating an existing product
        await apiService.updateProduct(product);
      }
      
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error ${widget.product == null ? 'creating' : 'updating'} product: $e')),
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
              builder: (context) => SellScreen(
                product: product,
                isViewOnly: true,
              ),
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
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            enabled: !widget.isViewOnly,
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
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            enabled: !widget.isViewOnly,
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
            decoration: const InputDecoration(
              labelText: 'Price',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            enabled: !widget.isViewOnly,
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
            onChanged: widget.isViewOnly ? null : (value) {
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
            baseUrl: 'http://10.0.2.2:3000/api',
            selectedCountryId: _selectedCountryId,
            selectedStateId: _selectedStateId,
            selectedCityId: _selectedCityId,
            onCountrySelected: (value) {
              setState(() {
                _selectedCountryId = value;
                _selectedStateId = null;
                _selectedCityId = null;
              });
            },
            onStateSelected: (value) {
              setState(() {
                _selectedStateId = value;
                _selectedCityId = null;
              });
            },
            onCitySelected: (value) {
              setState(() => _selectedCityId = value);
            },
            isViewOnly: widget.isViewOnly,
          ),
          const SizedBox(height: 16),
          if (_imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _imageUrl!,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          if (!widget.isViewOnly) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _pickAndUploadImage,
              icon: const Icon(Icons.upload),
              label: Text(_imageUrl == null ? 'Upload Image' : 'Change Image'),
            ),
          ],
          if (!widget.isViewOnly) ...[
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
        ],
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
      appBar: AppBar(
        title: Text(widget.isViewOnly 
          ? 'View Product' 
          : widget.product == null 
            ? 'Add Product' 
            : 'Edit Product'),
        actions: [
          if (widget.isViewOnly && widget.product != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SellScreen(
                      product: widget.product,
                      isViewOnly: false,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: widget.product != null || widget.isViewOnly
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