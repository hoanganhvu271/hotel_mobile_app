import 'package:flutter/material.dart';
import 'package:hotel_app/features/room_details/model/review.dart';
import 'package:hotel_app/features/room_details/presentation/ui/widgets/review_card.dart';

class ReviewList extends StatelessWidget {
  final List<Review> reviews;

  const ReviewList({
    super.key,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return ReviewCard(review: reviews[index]);
      },
    );
  }
}
