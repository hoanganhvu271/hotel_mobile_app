class Review {
  final int? reviewId;
  final String? content;
  final double? rating;
  final String? userName;
  final String? ownerReply; // Added attribute

  Review({
    this.reviewId,
    this.content,
    this.rating,
    this.userName,
    this.ownerReply, // Added parameter
  });

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'reviewId': reviewId,
        'content': content,
        'rating': rating,
        'userName': userName,
        'ownerReply': ownerReply, // Added field
      };

  // Create from JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['reviewId'] as int?,
      content: json['content'] as String?,
      rating: json['rating'] as double?,
      userName: json['userName'] as String?,
      ownerReply: json['ownerReply'] as String?, // Added field
    );
  }

  // Create a copy with some fields changed
  Review copyWith({
    int? reviewId,
    String? content,
    double? rating,
    String? userName,
    String? ownerReply, // Added parameter
  }) {
    return Review(
      reviewId: reviewId ?? this.reviewId,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      userName: userName ?? this.userName,
      ownerReply: ownerReply ?? this.ownerReply, // Added field
    );
  }

  @override
  String toString() => 'Review(reviewId: $reviewId, content: $content, '
      'rating: $rating, userName: $userName, ownerReply: $ownerReply)';
}
