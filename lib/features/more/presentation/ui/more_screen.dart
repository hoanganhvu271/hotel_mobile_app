import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_app/common/widgets/disable_widget.dart';
import 'package:hotel_app/features/account/info.dart';
import 'package:hotel_app/features/admin_system/admin_system_home.dart';
import 'package:hotel_app/features/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/hotel_storage_provider.dart';
import '../../../../constants/app_colors.dart';
import '../../../../core/global.dart';
import '../../../admin/presentation/ui/hotel_owner_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

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

class MoreContentWidget extends ConsumerWidget {
  const MoreContentWidget({super.key});

  Future<(bool isAdmin, bool isOwner)> _getUserRoles() async {
    final prefs = await SharedPreferences.getInstance();
    final isAdmin = prefs.getBool('is_admin') ?? false;
    final isOwner = prefs.getBool('is_owner') ?? false;
    return (isAdmin, isOwner);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<(bool, bool)>(
      future: _getUserRoles(),
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        final isAdmin = snapshot.data?.$1 ?? false;
        final isOwner = snapshot.data?.$2 ?? false;
        final hasPermission = isAdmin && isOwner;

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
                      spacing: 26,
                      children: [
                        Expanded(
                          child: FirstMoreItem(
                            imagePath: "assets/icons/icon_profile.svg",
                            title: "Tài khoản",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => UserInfoScreen()),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: DisableWidget(
                            disable: !isOwner,
                            child: FirstMoreItem(
                              imagePath: "assets/icons/icon_hotel.svg",
                              title: "Quản lý Khách sạn",
                              onTap: () {
                                if (hasPermission) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => HotelOwnerScreen()),
                                  );
                                }
                              },
                            ),
                          ),
                        )
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
                        onTap: () {
                          FirebaseCrashlytics.instance.crash();
                        },
                      ),
                      DisableWidget(
                        disable: !isAdmin,
                        child: RemainingMoreItem(
                          imagePath: "assets/icons/icon_admin.svg",
                          title: 'Trang Admin',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AdminSystemHome()),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 80),
                  CustomFilledButton(
                    title: "Đăng xuất",
                    iconPath: "assets/icons/icon_logout.svg",
                    backgroundColor: const Color(0xFFB3261E),
                    onTap: () => _handleLogout(ref),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleLogout(WidgetRef ref) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');
      await prefs.remove('user_id');
      await prefs.remove('is_admin');
      await prefs.remove('is_owner');
      await ref.read(hotelStorageProvider).clearHotelId();

      globalNavigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    } catch (e) {
      print('Logout error: $e');
    }
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
    return Material(
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
                    color: ColorsLib.primaryBoldColor
                ),
              ),
            ],
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
              SvgPicture.asset(imagePath),
              Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: disable
                        ? const Color(0xFF898181)
                        : ColorsLib.primaryBoldColor),
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