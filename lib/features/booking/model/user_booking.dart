class UserInfo {
  final int userId;
  final String fullName;
  final String phone;
  final String email;
  final String username;
  final int score;

  UserInfo({
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.username,
    required this.score
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['userId'],
      fullName: json['fullName'],
      phone: json['phone'],
      email: json['email'],
      username: json['username'],
      score: json['score'],
    );
  }
}
