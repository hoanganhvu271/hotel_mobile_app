// import 'package:flutter/material.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Home Screen'));
//   }
// }

import 'package:flutter/material.dart';

import '../../common/widgets/home_booking_btn.dart';
import '../booking/booking_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Home Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            BookingBtn(
              label: 'ĐẶT PHÒNG',
              screen: const BookingScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
