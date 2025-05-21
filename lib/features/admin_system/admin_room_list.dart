import 'package:flutter/material.dart';
import 'package:hotel_app/features/admin_system/model/room.dart';
import 'package:hotel_app/features/admin_system/services/admin_room_service.dart';
import 'package:hotel_app/common/widgets/heading.dart';
import 'package:hotel_app/features/admin_system/widgets/room_card.dart';
class RoomListScreen extends StatefulWidget {
  final int hotelId;

  const RoomListScreen({super.key, required this.hotelId});

  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  List<Room> _allRooms = [];
  List<Room> _filteredRooms = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRooms();
    _searchController.addListener(_filterRooms);
  }

  Future<void> _fetchRooms() async {
    try {
      final rooms = await RoomService().fetchRoomsByHotelId(widget.hotelId);
      setState(() {
        _allRooms = rooms;
        _filteredRooms = rooms;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _filterRooms() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRooms = _allRooms.where((room) {
        return room.roomName.toLowerCase().contains(query) ||
            room.roomId.toString().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterRooms);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Transform.translate(
          offset: const Offset(0, -5),
          child: Column(
            children: [
              Stack(
                children: [
                  const Heading(title: 'DANH SÁCH PHÒNG'),
                  Positioned(
                    left: 20,
                    top: 22,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Tìm kiếm theo tên hoặc mã phòng',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Room>>(
                  future: RoomService().fetchRoomsByHotelId(widget.hotelId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Lỗi: ${snapshot.error}'));
                    } else if (!_filteredRooms.isNotEmpty) {
                      return const Center(child: Text('Không có phòng nào'));
                    } else {
                      return ListView.builder(
                        itemCount: _filteredRooms.length,
                        itemBuilder: (context, index) {
                          return RoomCard(room: _filteredRooms[index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
