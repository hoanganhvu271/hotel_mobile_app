class ReviewResponseDto {
  final int reviewId;
  final String content;
  final int rating;

  ReviewResponseDto({
    required this.reviewId,
    required this.content,
    required this.rating,
  });

  factory ReviewResponseDto.fromJson(Map<String, dynamic> json) {
    return ReviewResponseDto(
      reviewId: json['reviewId'],
      content: json['content'],
      rating: json['rating'],
    );
  }
}
