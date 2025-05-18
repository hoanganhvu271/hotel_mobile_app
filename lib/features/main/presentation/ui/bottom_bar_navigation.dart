import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/main/presentation/provider/tab_provider.dart';
import 'package:hotel_app/features/main/presentation/ui/bottom_navigation_item.dart';
import '../model/tab_model.dart';

class BottomBarNavigation extends ConsumerWidget {
  const BottomBarNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TabEnum tab = ref.watch(tabProvider);

    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BottomNavigationItem(
            tab: TabEnum.home,
            iconPath: 'assets/icons/icon_home.svg',
            isSelected: tab == TabEnum.home
          ),
          BottomNavigationItem(
              tab: TabEnum.map,
              iconPath: 'assets/icons/icon_map.svg',
              isSelected: tab == TabEnum.map
          ),
          BottomNavigationItem(
            tab: TabEnum.order,
            iconPath: 'assets/icons/icon_order.svg',
            isSelected: tab == TabEnum.order
          ),
          BottomNavigationItem(
              tab: TabEnum.noti,
              iconPath: 'assets/icons/icon_noti.svg',
              isSelected: tab == TabEnum.noti
          ),
          BottomNavigationItem(
            tab: TabEnum.more,
            iconPath: 'assets/icons/icon_more.svg',
            isSelected: tab == TabEnum.more
          ),
        ],
      ),
    );
  }
}
