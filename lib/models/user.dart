class User {
  final int id;
  final String email;
  final String username;
  final String? token;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      email: json['user']['email'],
      username: json['user']['username'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'token': token,
    };
  }
} 