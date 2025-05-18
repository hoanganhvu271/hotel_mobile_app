class Role {
  final int roleId;
  final String name;

  Role({required this.roleId, required this.name});

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    roleId: json['roleId'] ?? 0,
    name: json['name'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'roleId': roleId,
    'name': name,
  };
}

class User {
  final int userId;
  String? fullName;
  String? phone;
  String? email;
  String? username;
  int? score;
  List<Role> roleDtoList;

  User({
    required this.userId,
    this.fullName,
    this.phone,
    this.email,
    this.username,
    this.score,
    required this.roleDtoList,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json['userId'] ?? 0,
    fullName: json['fullName'],
    phone: json['phone'],
    email: json['email'],
    username: json['username'],
    score: json['score'],
    roleDtoList: (json['roleDtoList'] as List)
        .map((e) => Role.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'fullName': fullName,
    'username': username,
    'email': email,
    'phone': phone,
    'score': score,
    'roleDtoList': roleDtoList.map((e) => e.toJson()).toList(),
  };
}
