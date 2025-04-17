class City {
  final int id;
  final String name;
  final int stateId;

  City({
    required this.id,
    required this.name,
    required this.stateId,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      stateId: json['state_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state_id': stateId,
    };
  }
} 