import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_app/features/booking_schedule/owner_list_screen.dart';
import 'package:hotel_app/features/login/login_screen.dart';
import 'package:hotel_app/features/account/info.dart';
import 'package:hotel_app/features/more_user/more_user_srceen.dart';
import '../review/booking_list_user_screen.dart';
import 'package:hotel_app/features/admin_system/admin_system_home.dart';
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Square button in the top-left corner
          Positioned(
            top: 40,
            left: 40,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserInfoScreen()),
                );
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.brown,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tài khoản',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logout button
                GestureDetector(
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
                const SizedBox(height: 20), // Space between buttons
                // Booking list button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BookingListUserScreen()),
                    );
                  },
                  child: Container(
                    width: 350,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E88E5), // Change color if needed
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.book_online, // You can change this icon if you prefer
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Danh sách đặt phòng',
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
              ],
            ),
          ),
        ],
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       // Nút Đăng xuất
      //       GestureDetector(
      //         onTap: () {
      //           Navigator.pushReplacement(
      //             context,
      //             MaterialPageRoute(builder: (context) => const LoginScreen()),
      //           );
      //         },
      //         child: Container(
      //           width: 350,
      //           height: 60,
      //           decoration: BoxDecoration(
      //             color: const Color(0xFFB3261E),
      //             borderRadius: BorderRadius.circular(12),
      //           ),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               SvgPicture.asset(
      //                 'assets/icons/logout.svg',
      //                 width: 24,
      //                 height: 24,
      //                 color: Colors.white,
      //               ),
      //               const SizedBox(width: 10),
      //               const Text(
      //                 'Đăng xuất',
      //                 style: TextStyle(
      //                   color: Colors.white,
      //                   fontSize: 18,
      //                   fontFamily: 'Inter',
      //                   fontWeight: FontWeight.w700,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 20),
      //       // Nút Danh sách đặt phòng
      //       GestureDetector(
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => const BookingListUserScreen()),
      //           );
      //         },
      //         child: Container(
      //           width: 350,
      //           height: 60,
      //           decoration: BoxDecoration(
      //             color: const Color(0xFF1E88E5),
      //             borderRadius: BorderRadius.circular(12),
      //           ),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: const [
      //               Icon(
      //                 Icons.book_online,
      //                 color: Colors.white,
      //                 size: 24,
      //               ),
      //               SizedBox(width: 10),
      //               Text(
      //                 'Danh sách đặt phòng',
      //                 style: TextStyle(
      //                   color: Colors.white,
      //                   fontSize: 18,
      //                   fontFamily: 'Inter',
      //                   fontWeight: FontWeight.w700,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 20),
      //       // Nút Trang Admin
      //       GestureDetector(
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => const AdminSystemHome()),
      //           );
      //         },
      //         child: Container(
      //           width: 350,
      //           height: 60,
      //           decoration: BoxDecoration(
      //             color: const Color(0xFF43A047),
      //             borderRadius: BorderRadius.circular(12),
      //           ),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: const [
      //               Icon(
      //                 Icons.admin_panel_settings,
      //                 color: Colors.white,
      //                 size: 24,
      //               ),
      //               SizedBox(width: 10),
      //               Text(
      //                 'Trang Admin',
      //                 style: TextStyle(
      //                   color: Colors.white,
      //                   fontSize: 18,
      //                   fontFamily: 'Inter',
      //                   fontWeight: FontWeight.w700,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //
      //
      //
      //       GestureDetector(
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => const OwnerListScreen()),
      //           );
      //         },
      //         child: Container(
      //           width: 350,
      //           height: 60,
      //           decoration: BoxDecoration(
      //             color: const Color(0xFF43A047),
      //             borderRadius: BorderRadius.circular(12),
      //           ),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: const [
      //               Icon(
      //                 Icons.admin_panel_settings,
      //                 color: Colors.white,
      //                 size: 24,
      //               ),
      //               SizedBox(width: 10),
      //               Text(
      //                 'Đặt phòng',
      //                 style: TextStyle(
      //                   color: Colors.white,
      //                   fontSize: 18,
      //                   fontFamily: 'Inter',
      //                   fontWeight: FontWeight.w700,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //
      //
      //
      //       GestureDetector(
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => const MoreUserSrceen()),
      //           );
      //         },
      //         child: Container(
      //           width: 350,
      //           height: 60,
      //           decoration: BoxDecoration(
      //             color: const Color(0xFF43A047),
      //             borderRadius: BorderRadius.circular(12),
      //           ),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: const [
      //               Icon(
      //                 Icons.admin_panel_settings,
      //                 color: Colors.white,
      //                 size: 24,
      //               ),
      //               SizedBox(width: 10),
      //               Text(
      //                 'More User Screen',
      //                 style: TextStyle(
      //                   color: Colors.white,
      //                   fontSize: 18,
      //                   fontFamily: 'Inter',
      //                   fontWeight: FontWeight.w700,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      )// ) // bottomNavigationBar: const KeepAliveComponent(child: BottomBarNavigation()),
    );
  }
}
