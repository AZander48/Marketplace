class State {
  final int id;
  final String name;
  final String code;
  final int countryId;

  State({
    required this.id,
    required this.name,
    required this.code,
    required this.countryId,
  });

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      countryId: json['country_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'country_id': countryId,
    };
  }
} 