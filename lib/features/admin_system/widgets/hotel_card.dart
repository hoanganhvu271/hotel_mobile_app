import 'package:flutter/material.dart';
import 'package:hotel_app/features/admin_system/admin_room_list.dart';
import 'package:hotel_app/features/admin_system/model/hotel_owner_list.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;

  const HotelCard({Key? key, required this.hotel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFFAFAFA),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(Icons.business_rounded, color: Colors.brown, size: 30),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RoomListScreen(hotelId: hotel.hotelId),
            ),
          );
        },
        title: Text(
          hotel.hotelName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('ID: ${hotel.hotelId}'),
            Text('P: ${hotel.address.ward}, Q: ${hotel.address.district}, TP: ${hotel.address.city}'),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.brown),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    hotel.address.specificAddress,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
