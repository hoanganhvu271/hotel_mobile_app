import 'package:flutter/material.dart';
import 'package:hotel_app/common/widgets/heading.dart';
import 'package:hotel_app/features/admin_system/admin_system_hotels.dart';
import 'package:hotel_app/features/admin_system/admin_system_users.dart';
import 'package:hotel_app/features/booking_schedule/owner_list_screen.dart';

class AdminInfoManagement extends StatelessWidget {
  const AdminInfoManagement({Key? key}) : super(key: key);

  Widget _buildInfoCardButton(
      BuildContext context, String title, Widget destinationPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              const Heading(title: 'QUẢN LÍ THÔNG TIN'),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  _buildInfoCardButton(
                      context, "Quản lí người dùng", const AdminSystemUsers()),
                  const SizedBox(height: 16),
                  _buildInfoCardButton(context, "Doanh thu khách sạn",
                      const AdminSystemHotels()),
                  const SizedBox(height: 16),
                  _buildInfoCardButton(context, "Lịch các phòng khách sạn",
                      const OwnerListScreen()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
