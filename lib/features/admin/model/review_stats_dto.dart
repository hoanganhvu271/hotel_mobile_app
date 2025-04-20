class ReviewStatsDto {
  final int totalReviews;
  final double reviewCountChangePercent;
  final double averageRating;
  final double averageRatingChangePercent;

  ReviewStatsDto({
    required this.totalReviews,
    required this.reviewCountChangePercent,
    required this.averageRating,
    required this.averageRatingChangePercent,
  });

  factory ReviewStatsDto.fromJson(Map<String, dynamic> json) {
    return ReviewStatsDto(
      totalReviews: json['totalReviews'] is int
          ? json['totalReviews']
          : int.parse(json['totalReviews'].toString()),
      reviewCountChangePercent: json['reviewCountChangePercent'] is double
          ? json['reviewCountChangePercent']
          : double.parse(json['reviewCountChangePercent'].toString()),
      averageRating: json['averageRating'] is double
          ? json['averageRating']
          : double.parse(json['averageRating'].toString()),
      averageRatingChangePercent: json['averageRatingChangePercent'] is double
          ? json['averageRatingChangePercent']
          : double.parse(json['averageRatingChangePercent'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalReviews': totalReviews,
      'reviewCountChangePercent': reviewCountChangePercent,
      'averageRating': averageRating,
      'averageRatingChangePercent': averageRatingChangePercent,
    };
  }
}
