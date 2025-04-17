class Country {
  final int id;
  final String name;
  final String code;
  final DateTime createdAt;

  Country({
    required this.id,
    required this.name,
    required this.code,
    required this.createdAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class State {
  final int id;
  final int countryId;
  final String name;
  final String? code;
  final DateTime createdAt;

  State({
    required this.id,
    required this.countryId,
    required this.name,
    this.code,
    required this.createdAt,
  });

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      id: json['id'],
      countryId: json['country_id'],
      name: json['name'],
      code: json['code'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country_id': countryId,
      'name': name,
      'code': code,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class City {
  final int id;
  final int stateId;
  final String name;
  final DateTime createdAt;
  final String? stateName;
  final String? stateCode;
  final String? countryName;

  City({
    required this.id,
    required this.stateId,
    required this.name,
    required this.createdAt,
    this.stateName,
    this.stateCode,
    this.countryName,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      stateId: json['state_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      stateName: json['state_name'],
      stateCode: json['state_code'],
      countryName: json['country_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state_id': stateId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'state_name': stateName,
      'state_code': stateCode,
      'country_name': countryName,
    };
  }

  String get formattedLocation {
    final parts = [
      name,
      if (stateCode != null) stateCode else stateName,
      countryName,
    ].where((part) => part != null).toList();
    return parts.join(', ');
  }
} 