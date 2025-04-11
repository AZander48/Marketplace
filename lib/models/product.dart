class Product {
  final int id;
  final int userId;
  final String title;
  final String description;
  final double price;
  final String category;
  final String condition;
  final String location;

  Product({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.condition,
    required this.location,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      price: _parsePrice(json['price']),
      category: json['category'],
      condition: json['condition'],
      location: json['location'],
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
} 