import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import 'sell_screen.dart';
import 'edit_product_screen.dart';
import 'add_product_screen.dart';

class ViewProductScreen extends StatefulWidget {
  final Product? product;

  const ViewProductScreen({
    super.key,
    this.product,
  });

  @override
  State<ViewProductScreen> createState() => _ViewProductScreenState();
}

class _ViewProductScreenState extends State<ViewProductScreen> {
  late Product _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product ?? Product(
      id: 0,
      userId: 0,
      title: '',
      description: '',
      price: 0,
      categoryId: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return the updated product when popping
        Navigator.pop(context, _product);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('View Product'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final updatedProduct = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProductScreen(productId: _product.id),
                  ),
                );
                
                if (updatedProduct != null && mounted) {
                  setState(() {
                    _product = updatedProduct;
                  });
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_product.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: _product.imageUrl!,
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
              const SizedBox(height: 24),
              Text(
                _product.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${_product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (_product.categoryName != null) ...[
                _buildInfoRow('Category', _product.categoryName!),
                const SizedBox(height: 8),
              ],
              if (_product.condition != null) ...[
                _buildInfoRow('Condition', _product.condition!),
                const SizedBox(height: 8),
              ],
              _buildInfoRow('Location', _product.formattedLocation),
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _product.description ?? 'No description provided',
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
} 