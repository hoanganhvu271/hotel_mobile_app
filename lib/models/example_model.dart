class ExampleModel{
  final int userId;
  final int id;
  final String title;
  final String body;

  ExampleModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory ExampleModel.fromJson(Map<String, dynamic> json) {
    return ExampleModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}