class NotificationModel {
  final int id;
  final String content;
  final DateTime? notificationTime;
  final int? userId;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.content,
    this.notificationTime,
    this.userId,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      content: json['content'] ?? '',
      notificationTime: json['notificationTime'] != null
          ? DateTime.tryParse(json['notificationTime'])
          : null,
      userId: json['userId'] is int ? json['userId'] : int.tryParse(json['userId'].toString()),
      createdAt: DateTime.tryParse(json['createdAt']) ?? DateTime.now(),
    );
  }
}
