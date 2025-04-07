import 'package:flutter/material.dart';

import '../../common/widgets/booking_info.dart';
import '../../common/widgets/booking_search.dart';
import '../../common/widgets/heading.dart';


class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              const Heading(title: 'ĐẶT PHÒNG'),
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
          Searchframetotal(),
          const SizedBox(height: 20),
          // Center(
          //   child: Bookinginfo(),
          // ),


          // const Center(
          //   child: Text('Chào mừng đến trang đặt phòng!'),
          // ),
        ],
      ),
    );
  }
}


