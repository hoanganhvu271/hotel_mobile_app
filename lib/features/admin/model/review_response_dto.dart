class ReviewResponseDto {
  final int reviewId;
  final String content;
  final int rating;
  final String? guestName;
  final String roomName;
  final DateTime createdAt;
  final String? ownerReply;

  ReviewResponseDto({
    required this.reviewId,
    required this.content,
    required this.rating,
    this.guestName = "Guest",
    required this.roomName,
    required this.createdAt,
    this.ownerReply,
  });

  factory ReviewResponseDto.fromJson(Map<String, dynamic> json) {
    return ReviewResponseDto(
      reviewId: json['reviewId'],
      content: json['content'],
      rating: json['rating'],
      guestName: json['guestName'] as String? ?? "Guest",
      roomName: json['roomName'],
      createdAt: DateTime.parse(json['createdAt']),
      ownerReply: json['ownerReply'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'content': content,
      'rating': rating,
      'guestName': guestName,
      'roomName': roomName,
      'createdAt': createdAt.toIso8601String(),
      'ownerReply': ownerReply,
    };
  }
}