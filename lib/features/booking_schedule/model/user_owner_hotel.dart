class User {
  final int id;
  final String fullName;
  final String username;
  final String phone;
  final String email;

  User({
    required this.id,
    required this.fullName,
    required this.username,
    required this.phone,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'],
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
