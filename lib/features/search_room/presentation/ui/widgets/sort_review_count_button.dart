import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/search_room/presentation/state/sort_rating_state.dart';
import 'package:hotel_app/features/search_room/presentation/state/sort_review_count_state.dart';

class SortReviewCountButton extends ConsumerWidget {
  const SortReviewCountButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortState = ref.watch(sortReviewCountState);

    Color backgroundColor =
        sortState == 0 ? Colors.white : const Color(0xFF8B5E3C);
    Color borderColor = const Color(0xFF8B5E3C);
    Color textColor = sortState == 0 ? const Color(0xFF8B5E3C) : Colors.white;

    Icon? icon;
    if (sortState == 1) {
      icon = const Icon(Icons.arrow_drop_down, color: Colors.white);
    } else if (sortState == 2) {
      icon = const Icon(Icons.arrow_drop_up, color: Colors.white);
    }

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: const StadiumBorder(),
        side: BorderSide(color: borderColor),
      ),
      onPressed: () {
        // Reset rating sort
        ref.read(sortRatingState.notifier).state = 0;

        // Toggle review sort
        final current = ref.read(sortReviewCountState);
        ref.read(sortReviewCountState.notifier).state = (current + 1) % 3;
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Số đánh giá", style: TextStyle(color: textColor)),
          if (icon != null) ...[
            const SizedBox(width: 4),
            icon,
          ]
        ],
      ),
    );
  }
}
