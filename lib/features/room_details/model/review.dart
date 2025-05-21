class Review {
  final int? reviewId;
  final String? content;
  final double? rating;
  final String? userName;

  Review({
    this.reviewId,
    this.content,
    this.rating,
    this.userName,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'reviewId': reviewId,
        'content': content,
        'rating': rating,
        'userName': userName,
      };

  // Create from JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['reviewId'] as int?,
      content: json['content'] as String?,
      rating: json['rating'] as double?,
      userName: json['userName'] as String?,
    );
  }

  // Create a copy with some fields changed
  Review copyWith({
    int? reviewId,
    String? content,
    double? rating,
    String? userName,
  }) {
    return Review(
      reviewId: reviewId ?? this.reviewId,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      userName: userName ?? this.userName,
    );
  }

  @override
  String toString() => 'Review(reviewId: $reviewId, content: $content, '
      'rating: $rating, userName: $userName)';
}
