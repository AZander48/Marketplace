import 'package:flutter/material.dart';
import 'package:marketplace_app/screens/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';
import 'sell_screen.dart';
import '../widgets/search_bar.dart';
import '../providers/search_provider.dart';
import '../services/category_service.dart';
import '../models/category.dart';
import 'category_screen.dart';
import '../services/recommendation_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final _categoryService = CategoryService();
  final RecommendationService _recommendationService = RecommendationService();
  List<Category> _categories = [];
  final Map<int, List<Product>> _categoryProducts = {};
  bool _isLoading = true;
  String? _errorMessage;
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  List<Product> _recommendedProducts = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadRecommendations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final categories = await _categoryService.getCategories();
      
      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoading = false;
        });

        // Load products for each category
        for (final category in categories) {
          _loadCategoryProducts(category.id);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _loadCategoryProducts(int categoryId) async {
    try {
      final result = await _categoryService.getCategoryProducts(categoryId, limit: 4);
      
      if (mounted) {
        setState(() {
          _categoryProducts[categoryId] = result['products'];
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _categoryProducts[categoryId] = []; // Set empty list on error
        });
      }
    }
  }

  Future<void> _loadRecommendations() async {
    try {
      final recommendations = await _recommendationService.getRecommendedProducts();
      if (mounted) {
        setState(() {
          _recommendedProducts = recommendations;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _recommendedProducts = []; // Set empty list on error
        });
      }
    }
  }

  Future<void> _onSearch(String query) async {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    if (query.isNotEmpty) {
      searchProvider.addToHistory(query);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(initialQuery: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: CustomSearchBar(
          controller: _searchController,
          focusNode: _focusNode,
          hintText: 'Search products...',
          onSearch: _onSearch,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchScreen(initialQuery: _searchController.text),
              ),
            );
          },
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.search,
          autofocus: false,
        ),
        actions: [
          if (!authProvider.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/login',
                );
              },
              tooltip: 'Login',
            ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.wifi_tethering),
            onPressed: _testConnection,
            tooltip: 'Test Database Connection',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (authProvider.isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SellScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please login to add a product'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCategories,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Add Recommendations Section if user is logged in
        if (_recommendedProducts.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Recommended for You',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _recommendedProducts.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 16),
                  child: ProductCard(product: _recommendedProducts[index]),
                );
              },
            ),
          ),
        ],
        // Existing categories list
        ...List.generate(_categories.length, (index) {
          final category = _categories[index];
          final products = _categoryProducts[category.id] ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryScreen(category: category),
                          ),
                        );
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, productIndex) {
                    final product = products[productIndex];
                    return Container(
                      width: 150,
                      margin: const EdgeInsets.only(right: 16),
                      child: ProductCard(product: product),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Future<void> _testConnection() async {
    try {
      final result = await _apiService.testConnection();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/product',
            arguments: product.id,
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  color: Colors.grey[200],
                ),
                child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return const Center(
                              child: Icon(Icons.error, color: Colors.red),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.formattedLocation,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 