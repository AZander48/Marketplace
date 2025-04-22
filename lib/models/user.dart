class User {
  final int id;
  final String? name;
  final String? email;
  final int? cityId;
  final String? profileImageUrl;
  final String? bio;
  final String? phoneNumber;
  final bool isVerified;
  final DateTime lastActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? cityName;
  final String? stateName;
  final String? stateCode;
  final String? countryName;
  final String? countryCode;
  final List<UserLocationPreference> locationPreferences;
  final String? token;

  User({
    required this.id,
    this.name,
    this.email,
    this.cityId,
    this.profileImageUrl,
    this.bio,
    this.phoneNumber,
    this.isVerified = false,
    required this.lastActive,
    required this.createdAt,
    required this.updatedAt,
    this.cityName,
    this.stateName,
    this.stateCode,
    this.countryName,
    this.countryCode,
    this.locationPreferences = const [],
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Handle login response format
    if (json['user'] != null) {
      final userData = json['user'];
      final now = DateTime.now();
      return User(
        id: userData['id'],
        name: userData['name'],
        email: userData['email'],
        lastActive: now,
        createdAt: now,
        updatedAt: now,
        token: json['token'],
      );
    }

    // Handle full user profile format
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      cityId: json['city_id'],
      profileImageUrl: json['profile_image_url'],
      bio: json['bio'],
      phoneNumber: json['phone_number'],
      isVerified: json['is_verified'] ?? false,
      lastActive: DateTime.parse(json['last_active']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      cityName: json['city_name'],
      stateName: json['state_name'],
      stateCode: json['state_code'],
      countryName: json['country_name'],
      countryCode: json['country_code'],
      locationPreferences: (json['location_preferences'] as List?)
          ?.map((pref) => UserLocationPreference.fromJson(pref))
          .toList() ?? [],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'city_id': cityId,
      'profile_image_url': profileImageUrl,
      'bio': bio,
      'phone_number': phoneNumber,
      'is_verified': isVerified,
      'last_active': lastActive.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'city_name': cityName,
      'state_name': stateName,
      'state_code': stateCode,
      'country_name': countryName,
      'country_code': countryCode,
      'location_preferences': locationPreferences.map((pref) => pref.toJson()).toList(),
      'token': token,
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

class UserLocationPreference {
  final int id;
  final int userId;
  final int cityId;
  final bool isPrimary;
  final DateTime createdAt;
  final String? cityName;
  final String? stateName;
  final String? stateCode;
  final String? countryName;
  final String? countryCode;

  UserLocationPreference({
    required this.id,
    required this.userId,
    required this.cityId,
    required this.isPrimary,
    required this.createdAt,
    this.cityName,
    this.stateName,
    this.stateCode,
    this.countryName,
    this.countryCode,
  });

  factory UserLocationPreference.fromJson(Map<String, dynamic> json) {
    return UserLocationPreference(
      id: json['id'],
      userId: json['user_id'],
      cityId: json['city_id'],
      isPrimary: json['is_primary'],
      createdAt: DateTime.parse(json['created_at']),
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
      'user_id': userId,
      'city_id': cityId,
      'is_primary': isPrimary,
      'created_at': createdAt.toIso8601String(),
      'city_name': cityName,
      'state_name': stateName,
      'state_code': stateCode,
      'country_name': countryName,
      'country_code': countryCode,
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