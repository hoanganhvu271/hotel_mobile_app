import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/state/compare_room_state.dart';
import 'package:hotel_app/features/room_details/model/review.dart';
import 'package:hotel_app/features/room_details/presentation/provider/room_details_provider.dart';

class MiniRoomCard extends ConsumerStatefulWidget {
  final int roomId;
  final double width;

  const MiniRoomCard({
    Key? key,
    required this.roomId,
    required this.width,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MiniRoomCardState();
  }
}

class _MiniRoomCardState extends ConsumerState<MiniRoomCard> {
  bool hasFetched = false;

  double calculateRatingAvg(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    double totalRating = 0.0;
    for (var review in reviews) {
      totalRating += review.rating ?? 0.0;
    }
    return totalRating / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    final double width = widget.width;

    final roomDetaisState = ref.watch(roomDetailsViewModel);

    if (!hasFetched) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(roomDetailsViewModel.notifier).getRoomDetails(widget.roomId);
      });
      hasFetched = true;
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
            child: roomDetaisState.when(
              orElse: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error) => Center(child: Text(error.toString())),
              success: (data) => Column(
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.network(
                      data.roomImgs!.first, // Thay bằng ảnh thật
                      width: width,
                      height: width / 2,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Text info
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.hotelName ?? 'Tên khách sạn',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.brown),
                        ),
                        const SizedBox(height: 4),
                        Text(data.roomName ?? 'Tên phòng',
                            style: TextStyle(color: Colors.brown)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.brown,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            data.pricePerNight.toString() ?? 'Giá' + ' VNĐ/đêm',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        // Giá + đánh giá
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.brown,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                calculateRatingAvg(data.reviews ?? [])
                                        .toStringAsFixed(1) ??
                                    '0',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                                data.reviews?.length.toString() ??
                                    "" + ' Đánh giá',
                                style: TextStyle(color: Colors.brown)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Dịch vụ
                        const Row(
                          children: [
                            Text('Dịch vụ:',
                                style: TextStyle(color: Colors.brown)),
                            SizedBox(width: 8),
                            Icon(Icons.wifi, color: Colors.brown),
                            SizedBox(width: 4),
                            Icon(Icons.restaurant, color: Colors.brown),
                            SizedBox(width: 4),
                            Icon(Icons.tv, color: Colors.brown),
                            SizedBox(width: 4),
                            Icon(Icons.local_laundry_service,
                                color: Colors.brown),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Positioned(
          left: 0,
          top: 0,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              ref.read(compareRoomIdProvider.notifier).state = 0;
            },
          ),
        ),
      ],
    );
  }
}
