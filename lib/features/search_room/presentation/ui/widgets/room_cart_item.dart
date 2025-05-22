import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/state/compare_room_state.dart';
import 'package:hotel_app/common/state/room_id_state.dart';
import 'package:hotel_app/common/utils/api_constants.dart';
import 'package:hotel_app/features/search_room/model/room_search_list.dart';
import 'package:hotel_app/features/room_details/presentation/ui/room_detail_screen.dart';

class RoomCardItem extends ConsumerWidget {
  final RoomSearchList room;

  const RoomCardItem({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.white, // màu nền card
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          ref.read(roomIdProvider.notifier).state = room.roomId;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomDetailsScreen(roomId: room.roomId),
            ),
          );
          print("Room tapped: ${room.hotelName}");
          print(ref.watch(roomIdProvider));
        },
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.brown.withOpacity(0.2), // hiệu ứng sóng nước
        highlightColor:
            Colors.brown.withOpacity(0.1), // hiệu ứng đậm nhẹ khi giữ
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  '${ApiConstants.baseUrl}/api/files/${room.roomImg}',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.hotelName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      room.roomName,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.brown),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            room.address,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.brown.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            room.rating.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${room.reviewCount} Đánh giá',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _iconText(
                            Icons.person, room.standardOccupancy.toString()),
                        _iconText(
                            Icons.child_care, room.numChildrenFree.toString()),
                        _iconText(
                            Icons.king_bed,
                            room.bedNumber
                                .toString()), // sửa theo dữ liệu thật nếu có
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.brown),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
