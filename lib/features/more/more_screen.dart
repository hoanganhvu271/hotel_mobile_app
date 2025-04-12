// import 'package:flutter/material.dart';
//
// class MoreScreen extends StatelessWidget {
//   const MoreScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Text('More Screen');
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_app/common/widgets/keep_alive_component.dart';
import 'package:hotel_app/features/login/login_screen.dart';
import 'package:hotel_app/features/main/presentation/ui/bottom_bar_navigation.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: Container(
            width: 350,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFB3261E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/logout.svg',
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Đăng xuất',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: const KeepAliveComponent(child: BottomBarNavigation()),
    );
  }
}
