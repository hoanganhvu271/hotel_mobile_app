import 'package:flutter/material.dart';
import 'package:hotel_app/features/admin_system/model/hotel_owner_list.dart';
import 'package:hotel_app/features/admin_system/services/hotel_owner_service.dart';
import 'package:hotel_app/common/widgets/heading.dart';
import 'package:hotel_app/features/admin_system/widgets/hotel_card.dart';

class HotelListScreen extends StatefulWidget {
  final int userId;

  const HotelListScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _HotelListScreenState createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  Future<List<Hotel>>? hotels;
  List<Hotel> filteredHotels = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    hotels = HotelService().fetchHotelsByUserId(widget.userId);
  }

  void filterHotels(List<Hotel> allHotels, String query) {
    setState(() {
      searchQuery = query;
      filteredHotels = allHotels.where((hotel) {
        return hotel.hotelId.toString().contains(query) ||
            hotel.hotelName.toLowerCase().contains(query.toLowerCase()) ||
            hotel.address.city.toLowerCase().contains(query.toLowerCase()) ||
            hotel.address.district.toLowerCase().contains(query.toLowerCase()) ||
            hotel.address.ward.toLowerCase().contains(query.toLowerCase()) ||
            hotel.address.specificAddress.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              const Heading(title: 'QUẢN LÝ KHÁCH SẠN'),
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
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo tên, ID, thành phố, quận, phường...',
                prefixIcon: const Icon(Icons.search, color: Colors.brown),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.brown),
                ),
              ),
              onChanged: (value) {
                hotels?.then((allHotels) {
                  filterHotels(allHotels, value);
                });
              },
            ),
          ),
          Expanded(
            child: hotels == null
                ? const Center(child: CircularProgressIndicator())
                : FutureBuilder<List<Hotel>>(
              future: hotels,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có khách sạn nào'));
                } else {
                  final allHotels = snapshot.data!;
                  final displayHotels = searchQuery.isEmpty ? allHotels : filteredHotels;

                  return ListView.builder(
                    itemCount: displayHotels.length,
                    itemBuilder: (context, index) {
                      return HotelCard(hotel: displayHotels[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
