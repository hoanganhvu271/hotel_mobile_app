class ReviewResponseDto {
  final int reviewId;
  final String content;
  final int rating;
  final String? ownerReply;

  ReviewResponseDto({
    required this.reviewId,
    required this.content,
    required this.rating,
    this.ownerReply,
  });

  factory ReviewResponseDto.fromJson(Map<String, dynamic> json) {
    return ReviewResponseDto(
      reviewId: json['reviewId'],
      content: json['content'],
      rating: json['rating'],
      ownerReply: json['ownerReply'],
    );
  }
}
