import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/tab_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../provider/tab_provider.dart';

class BottomNavigationItem extends ConsumerWidget {
  final TabEnum tab;
  final String iconPath;
  final bool isSelected;

  const BottomNavigationItem({
    super.key,
    required this.tab,
    required this.iconPath,
    required this.isSelected
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref.read(tabProvider.notifier).setTab(tab),
      child: Container(
        height: 96,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: isSelected ? const Color(0xFF9A775C) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 6,
            children: [
              SvgPicture.asset(
                iconPath, color: isSelected ? const Color(0xFF9A775C) : Colors.black,
                width: 28,
                height: 28,
              ),
              Text(
                tab.enumToString,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF9A775C) : Colors.black,
                  fontSize: 12,
                  height: 14 / 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
