import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/image_service.dart';
import '../services/auth_service.dart';
import '../models/product.dart';
import '../services/category_service.dart';
import '../providers/location_provider.dart';
import '../models/category.dart';
import '../models/location.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _authService = AuthService();
  final _categoryService = CategoryService();
  String? _imageUrl;
  bool _isLoading = false;
  int? _selectedCategoryId;
  String? _selectedCondition;
  List<Category> _categories = [];
  bool _loadingCategories = true;

  final List<String> _conditions = [
    'New',
    'Like New',
    'Good',
    'Fair',
    'Poor'
  ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _initializeLocationData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      setState(() => _loadingCategories = true);
      final categories = await _categoryService.getCategories();
      if (!mounted) return;
      setState(() {
        _categories = categories;
        _loadingCategories = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading categories: $e')),
      );
      setState(() => _loadingCategories = false);
    }
  }

  Future<void> _pickAndUploadImage() async {
    final imageService = ImageService(baseUrl: 'http://10.0.2.2:3000');
    setState(() => _isLoading = true);
    
    try {
      final imageUrl = await imageService.pickAndUploadImage();
      if (!mounted) return;
      if (imageUrl != null) {
        setState(() => _imageUrl = imageUrl);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    if (locationProvider.selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      // Get current user
      final currentUser = await _authService.getCurrentUser();
      if (!mounted) return;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      final product = Product(
        id: 0, // New product
        userId: currentUser.id,
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        categoryId: _selectedCategoryId!,
        condition: _selectedCondition,
        cityId: locationProvider.selectedCity!.id,
        imageUrl: _imageUrl,
        sellerName: currentUser.name,
        categoryName: '', // Will be set by the server
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final apiService = Provider.of<ApiService>(context, listen: false);
      final newProduct = await apiService.createProduct(product);
      
      if (!mounted) return;
      Navigator.pop(context, newProduct);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating product: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _initializeLocationData() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    await locationProvider.loadCountries();
  }

  Widget _buildLocationSection() {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (locationProvider.isLoading)
              const CircularProgressIndicator()
            else ...[
              DropdownButtonFormField<Country>(
                value: locationProvider.selectedCountry,
                hint: const Text('Select Country'),
                items: locationProvider.countries.map((country) {
                  return DropdownMenuItem(
                    value: country,
                    child: Text(country.name),
                  );
                }).toList(),
                onChanged: (country) {
                  if (country != null) {
                    locationProvider.selectCountry(country);
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a country';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              if (locationProvider.states.isNotEmpty)
                DropdownButtonFormField<LocationState>(
                  value: locationProvider.selectedState,
                  hint: const Text('Select State'),
                  items: locationProvider.states.map((state) {
                    return DropdownMenuItem(
                      value: state,
                      child: Text(state.name),
                    );
                  }).toList(),
                  onChanged: (state) {
                    if (state != null) {
                      locationProvider.selectState(state);
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a state';
                    }
                    return null;
                  },
                ),
              if (locationProvider.cities.isNotEmpty) ...[
                const SizedBox(height: 8),
                DropdownButtonFormField<City>(
                  value: locationProvider.selectedCity,
                  hint: const Text('Select City'),
                  items: locationProvider.cities.map((city) {
                    return DropdownMenuItem(
                      value: city,
                      child: Text(city.name),
                    );
                  }).toList(),
                  onChanged: (city) {
                    if (city != null) {
                      locationProvider.selectCity(city);
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a city';
                    }
                    return null;
                  },
                ),
              ],
            ],
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Add New Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                autofocus: true,
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
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.newline,
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
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
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
              if (_loadingCategories)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                DropdownButtonFormField<int>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedCategoryId = value);
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCondition,
                decoration: const InputDecoration(
                  labelText: 'Condition',
                  border: OutlineInputBorder(),
                ),
                items: _conditions.map((condition) {
                  return DropdownMenuItem(
                    value: condition,
                    child: Text(condition),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCondition = value);
                },
              ),
              const SizedBox(height: 16),
              _buildLocationSection(),
              const SizedBox(height: 16),
              if (_imageUrl != null)
                Image.network(
                  _imageUrl!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _pickAndUploadImage,
                child: Text(_imageUrl == null ? 'Upload Image' : 'Change Image'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Create Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 