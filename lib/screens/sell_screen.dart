import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/image_service.dart';
import '../models/product.dart';

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
  String? _imageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _titleController.text = widget.product!.title;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _categoryController.text = widget.product!.category;
      _conditionController.text = widget.product!.condition;
      _locationController.text = widget.product!.location;
      _imageUrl = widget.product!.imageUrl;
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
      final product = Product(
        id: widget.product?.id ?? 0,
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        imageUrl: _imageUrl,
        userId: widget.product?.userId ?? 1, // TODO: Get from authentication
        category: _categoryController.text,
        condition: _conditionController.text,
        location: _locationController.text,
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

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                enabled: !widget.isViewOnly,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                enabled: !widget.isViewOnly,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
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
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                enabled: !widget.isViewOnly,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _conditionController,
                decoration: const InputDecoration(labelText: 'Condition'),
                enabled: !widget.isViewOnly,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the condition';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                enabled: !widget.isViewOnly,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_imageUrl != null)
                Image.network(
                  _imageUrl!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              if (!widget.isViewOnly) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _pickAndUploadImage,
                  child: Text(_imageUrl == null ? 'Upload Image' : 'Change Image'),
                ),
              ],
              if (!widget.isViewOnly) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(widget.product == null ? 'Create Product' : 'Update Product'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 