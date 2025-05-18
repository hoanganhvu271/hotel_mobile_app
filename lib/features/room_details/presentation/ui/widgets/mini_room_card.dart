import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hotel_app/common/state/compare_room_state.dart';
import 'package:hotel_app/common/state/room_id_state.dart';
import 'package:hotel_app/common/utils/service_text_util.dart';
import 'package:hotel_app/common/utils/text_util.dart';
import 'package:hotel_app/features/room_details/model/review.dart';
import 'package:hotel_app/features/room_details/model/room_details.dart';
import 'package:hotel_app/features/room_details/presentation/provider/room_details_provider.dart';

class MiniRoomCard extends ConsumerWidget {
  final double width;

  const MiniRoomCard({
    Key? key,
    required this.width,
  }) : super(key: key);

  double calculateRatingAvg(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    double totalRating = 0.0;
    for (var review in reviews) {
      totalRating += review.rating ?? 0.0;
    }
    return totalRating / reviews.length;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = this.width;
    final int compareRoomId = ref.watch(compareRoomIdProvider);
    final int currentRoomId = ref.watch(roomIdProvider);

    final room = ref.watch(compareRoomProvider);

    if (compareRoomId == 0 || compareRoomId == currentRoomId) {
      return const SizedBox.shrink(); // Không hiển thị
    }

    return Stack(
      children: [
        Container(
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: Column(
            children: [
              // Image
              if (room.roomImgs != null && room.roomImgs!.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    room.roomImgs!.first,
                    width: width,
                    height: width / 2,
                    fit: BoxFit.cover,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.hotelName ?? 'Tên khách sạn',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.brown),
                    ),
                    const SizedBox(height: 4),
                    Text(room.roomName ?? 'Tên phòng',
                        style: const TextStyle(color: Colors.brown)),
                    const SizedBox(height: 6),
                    if (room.pricePerNight != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          convertPriceToString(room.pricePerNight!) +
                              ' VNĐ/đêm',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.brown,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            calculateRatingAvg(room.reviews ?? [])
                                .toStringAsFixed(1),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${room.reviews?.length ?? 0} Đánh giá',
                          style: const TextStyle(color: Colors.brown),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Dịch vụ
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 12.0,
                      children: room.services!.map((service) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'icons/services/${serviceTextUtil(service)}.svg',
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                  Colors.brown, BlendMode.srcIn),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              ref.read(compareRoomIdProvider.notifier).state = 0;
              ref.read(compareRoomProvider.notifier).clearRoomDetails();
            },
          ),
        ),
      ],
    );
  }
}
