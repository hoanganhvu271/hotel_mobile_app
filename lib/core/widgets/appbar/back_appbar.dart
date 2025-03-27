import 'package:flutter/material.dart';

class BackAppbar extends StatelessWidget {
  final VoidCallback? onBackPressed;

  const BackAppbar({Key? key, this.onBackPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lấy chiều rộng màn hình từ MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          width: screenWidth, // Sử dụng chiều rộng màn hình
          height: 81,
          child: Stack(
            children: [
              // Gradient background
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: screenWidth,
                  height: 81,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // Nút quay lại thống nhất kết hợp icon và text
              Positioned(
                left: 18,
                top: 11,
                child: GestureDetector(
                  onTap: onBackPressed ?? () => print('Back pressed'),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 36,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Back',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
