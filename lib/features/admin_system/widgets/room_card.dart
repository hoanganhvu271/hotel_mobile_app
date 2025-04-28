import 'package:flutter/material.dart';
import 'package:hotel_app/common/utils/api_constants.dart';
import 'package:hotel_app/features/admin_system/admin_room_revenue.dart';
import 'package:hotel_app/features/admin_system/model/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final imageUrl = (room.roomImg != null && room.roomImg!.isNotEmpty)
        ? '${ApiConstants.baseUrl}/api/files/${room.roomImg}'
        : 'https://placehold.co/179x112';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminRoomRevenueScreen(
              roomId: room.roomId,
              roomName: room.roomName,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const SizedBox(
                  height: 180,
                  child: Center(child: Icon(Icons.broken_image, size: 60)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.roomName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Mã phòng: ${room.roomId}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
