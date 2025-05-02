class UserDto {
  final int? userId;
  final String? fullName;
  final String? phone;
  final String? email;
  final String? username;
  final String? password;
  final int? score;

  UserDto({
    this.userId,
    this.fullName,
    this.phone,
    this.email,
    this.username,
    this.password,
    this.score,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      userId: json['userId'],
      fullName: json['fullName'],
      phone: json['phone'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'username': username,
      'password': password,
      'score': score,
    };
  }
}
