class Product {
  final int id;
  final int userId;
  final String title;
  final String description;
  final double price;
  final int categoryId;
  final String condition;
  final int locationId;
  final String? imageUrl;
  final String sellerName;
  final String categoryName;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.condition,
    required this.locationId,
    this.imageUrl,
    required this.sellerName,
    required this.categoryName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      price: _parsePrice(json['price']),
      categoryId: json['category_id'],
      condition: json['condition'],
      locationId: json['location_id'],
      imageUrl: json['image_url'],
      sellerName: json['seller_name'],
      categoryName: json['category_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static double _parsePrice(dynamic price) {
    if (price is num) {
      return price.toDouble();
    } else if (price is String) {
      return double.tryParse(price) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price.toString(),
      'category_id': categoryId,
      'condition': condition,
      'location_id': locationId,
      'image_url': imageUrl,
      'user_id': userId,
    };
  }
} 