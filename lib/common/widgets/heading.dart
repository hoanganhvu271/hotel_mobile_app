import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String title;

  const Heading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity, // Sử dụng double.infinity để container chiếm toàn bộ chiều ngang
          height: 88,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(),
          child: Stack(
            children: [
              Positioned(
                left: -1,
                top: 0,
                child: Container(
                  width: 412, // Đảm bảo chiều rộng đủ lớn để chứa phần tiêu đề
                  height: 88,
                  decoration: const ShapeDecoration(
                    color: Color(0xFF65462D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              // Căn giữa chữ theo chiều ngang
              Positioned(
                left: 0,
                right: 0, // Căn trái và phải đều 0 để căn giữa
                top: 32,
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
