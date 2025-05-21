import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_app/features/account/info.dart';
import 'package:hotel_app/features/admin/presentation/ui/hotel_owner_screen.dart';
import 'package:hotel_app/features/admin_system/admin_system_home.dart';
import 'package:hotel_app/features/admin_system/admin_system_hotels.dart';
import 'package:hotel_app/features/hotel_owner/hotel_owner_system_home.dart';
import 'package:hotel_app/features/login/login_screen.dart';
import 'package:hotel_app/features/map/map_screen.dart';
import 'package:hotel_app/features/more_user/web_socket_page.dart';
import 'package:hotel_app/features/review/booking_list_user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreUserSrceen extends StatelessWidget {
  const MoreUserSrceen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: Colors.transparent,
      child: SafeArea(
          child: Column(
            children: [
              AppBarWidget(title: "Booking_N15"),
              Expanded(child: MoreContentWidget())
            ],
          )),
    );
  }
}

class AppBarWidget extends StatelessWidget {
  final String title;
  final Color? backgroundColor;

  const AppBarWidget(
      {super.key,
        required this.title,
        this.backgroundColor = const Color(0xFF65462D)});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class MoreContentWidget extends StatefulWidget {
  const MoreContentWidget({super.key});

  @override
  State<MoreContentWidget> createState() => _MoreContentWidgetState();
}

class _MoreContentWidgetState extends State<MoreContentWidget> {
  List<String> userRoles = [];

  @override
  void initState() {
    super.initState();
    loadUserRoles();
  }

  Future<void> loadUserRoles() async {
    final prefs = await SharedPreferences.getInstance();
    final roles = prefs.getStringList('user_roles') ?? [];
    setState(() {
      userRoles = roles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FirstMoreItem(
                      imagePath: "assets/icons/icon_profile.svg",
                      title: "Tài khoản",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserInfoScreen()),
                        );
                      },
                    ),
                    const SizedBox(width: 26),
                    FirstMoreItem(
                      imagePath: "assets/icons/icon_booking.svg",
                      title: "Đơn đặt phòng",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingListUserScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
              Column(
                spacing: 24,
                children: [
                  const RemainingMoreItem(
                      imagePath: "assets/icons/icon_setting.svg",
                      title: 'Cài đặt'),
                  RemainingMoreItem(
                      imagePath: "assets/icons/icon_support.svg",
                      title: 'Hỗ trợ',
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MapScreen()))),
                  RemainingMoreItem(
                    imagePath: "assets/icons/icon_admin.svg",
                    title: 'Trang admin',
                    disable: false,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminSystemHome())),
                  ),
                  RemainingMoreItem(
                    imagePath: "assets/icons/icon_hotel_owner.svg",
                    title: 'Trang chủ khách sạn',
                    disable: false,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HotelOwnerSystemHome())),
                  ),

                  RemainingMoreItem(
                    imagePath: "assets/icons/icon_hotel_owner.svg",
                    title: 'Trang chủ khách sạn2',
                    disable: false,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HotelOwnerScreen())),
                  ),
                  // if (userRoles.contains('ROLE_ADMIN'))
                  //   RemainingMoreItem(
                  //     imagePath: "assets/icons/icon_admin.svg",
                  //     title: 'Trang admin',
                  //     disable: false,
                  //     onTap: () => Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => const AdminSystemHome())),
                  //   ),
                  // if (userRoles.contains('ROLE_HOTEL_OWNER'))
                  //   RemainingMoreItem(
                  //     imagePath: "assets/icons/icon_hotel_owner.svg",
                  //     title: 'Trang chủ khách sạn',
                  //     disable: false,
                  //     onTap: () => Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => const HotelOwnerSystemHome())),
                  //   ),


                ],
              ),
              const SizedBox(height: 80),
              CustomFilledButton(
                title: "Đăng xuất",
                iconPath: "assets/icons/icon_logout.svg",
                backgroundColor: const Color(0xFFB3261E),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class FirstMoreItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final Function()? onTap;

  const FirstMoreItem({
    super.key,
    required this.imagePath,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: const Color(0xFFF2F2F3),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.black.withValues(alpha: 0.2),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 25,
              children: [
                SvgPicture.asset(imagePath),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RemainingMoreItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final Function()? onTap;
  final bool disable;

  const RemainingMoreItem({
    super.key,
    required this.imagePath,
    required this.title,
    this.onTap,
    this.disable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF2F2F3),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          print("Tapped");
          onTap?.call();
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.black.withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF000000).withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                  spreadRadius: 0),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20,
            children: [
              SvgPicture.asset(
                imagePath,
                width: 26,
                height: 26,
              ),

              Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: disable ? const Color(0xFF898181) : Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomFilledButton extends StatelessWidget {
  final String title;
  final String? iconPath;
  final Color? textColor;
  final Function()? onTap;
  final Color backgroundColor;

  const CustomFilledButton({
    super.key,
    required this.title,
    this.iconPath,
    this.onTap,
    this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => onTap?.call(),
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.black.withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              iconPath != null
                  ? SvgPicture.asset(iconPath!)
                  : const SizedBox.shrink(),
              Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor ?? Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
