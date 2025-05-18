import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HotelCard extends StatelessWidget {
  final String name;
  final String city;  // Thay đổi từ address thành city
  final String district;  // Thêm district
  final String imageUrl;

  const HotelCard({
    super.key,
    required this.name,
    required this.city,  // Nhận city
    required this.district,  // Nhận district
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 225,
      height: 238,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 14,
            top: 13,
            child: Container(
              width: 198,
              height: 133,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            top: 156,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            left: 13,
            top: 190,
            child: Text(
              '$city, $district',  // Hiển thị city và district
              style: const TextStyle(
                color: Color(0xFF65462D),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
