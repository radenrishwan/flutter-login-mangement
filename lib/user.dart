class User {
  final String id;
  final String email;
  final String username;
  final String password;
  final String createdAt;
  final String updatedAt;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'password': password,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'token': token,
    };
  }
}

/*
"id": "a68c559f-3409-4c1f-91cf-56b3b67a100c",
        "email": "radenrishwan@gmail.com",
        "username": "juju",
        "password": "$2a$10$qcvto3Hpr/nBQpFz/C/lB.jcK6FuR00jNEB1IlgPtzvtha7SmFeoq",
        "created_at": "1662204375671",
        "updated_at": "1662204375671",
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjcmVhdGVkX2F0IjoiMTY2MjIwNDM3NTcwOCIsImV4cGlyZWRfYXQiOiIxNjYyODA5MTc1NzA4IiwiaWQiOiI1YjE0MjMzMS1
*/