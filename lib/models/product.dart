class Product {
  final int id;
  final int userId;
  final String title;
  final String description;
  final double price;
  final int categoryId;
  final String? condition;
  final int? cityId;
  final String? imageUrl;
  final String? sellerName;
  final String? categoryName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? cityName;
  final String? stateName;
  final String? stateCode;
  final String? countryName;
  final String? countryCode;

  Product({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.price,
    required this.categoryId,
    this.condition,
    this.cityId,
    this.imageUrl,
    this.sellerName,
    this.categoryName,
    required this.createdAt,
    required this.updatedAt,
    this.cityName,
    this.stateName,
    this.stateCode,
    this.countryName,
    this.countryCode,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      price: double.parse(json['price']),
      categoryId: json['category_id'],
      condition: json['condition'],
      cityId: json['city_id'],
      imageUrl: json['image_url'],
      sellerName: json['seller_name'],
      categoryName: json['category_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      cityName: json['city_name'],
      stateName: json['state_name'],
      stateCode: json['state_code'],
      countryName: json['country_name'],
      countryCode: json['country_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price.toString(),
      'category_id': categoryId,
      'condition': condition,
      'city_id': cityId,
      'image_url': imageUrl,
      'user_id': userId,
      'city_name': cityName,
      'state_name': stateName,
      'state_code': stateCode,
      'country_name': countryName,
      'country_code': countryCode,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get formattedLocation {
    final parts = [
      cityName,
      if (stateCode != null) stateCode else stateName,
      countryName,
    ].where((part) => part != null).toList();
    return parts.join(', ');
  }
} 