import 'package:flutter/material.dart';
import 'package:hotel_app/features/main/presentation/ui/tab_component.dart';

import '../../../../common/widgets/keep_alive_component.dart';
import '../../../../core/firebase_messaging_service.dart';
import '../../../home/home_screen.dart';
import '../../../more/presentation/ui/more_screen.dart';
import '../../../noti/noti_screen.dart';
import '../../../order/orderscreen.dart';
import '../model/tab_model.dart';
import '../provider/tab_provider.dart';
import 'bottom_bar_navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<GlobalKey<NavigatorState>> listKey =
  List.generate(TabEnum.values.length, (index) => GlobalKey<NavigatorState>());


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: TabEnum.values.length, vsync: this);
    // Initialize Firebase Messaging
    _initializeFirebaseMessaging();
  }

  Future<void> _initializeFirebaseMessaging() async {
    try {
      await ref.read(firebaseMessagingServiceProvider)
          .initializeFirebaseMessaging();
    } catch (e) {
      print('Error initializing Firebase Messaging: $e');
    }
  }

  DateTime? _lastBackPressed;

  @override
  Widget build(BuildContext context) {
    ref.listen(
        tabProvider, (pre, next) => _tabController.animateTo(next.index));

    return WillPopScope(
      onWillPop: () async {
        final currentTime = DateTime.now();
        if (_lastBackPressed == null ||
            currentTime.difference(_lastBackPressed!) > Duration(seconds: 2)) {
          _lastBackPressed = currentTime;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nhấn lần nữa để thoát'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        return true; // cho phép thoát
      },
      child: SafeArea(
        child: Scaffold(
          body: TabBarView(
            controller: _tabController,
            children: [
              TabComponent(
                  tabKey: listKey[TabEnum.home.index], child: HomeScreen()),
              TabComponent(
                  tabKey: listKey[TabEnum.order.index], child: OrderScreen()),
              TabComponent(
                  tabKey: listKey[TabEnum.noti.index], child: NotiScreen()),
              TabComponent(tabKey: listKey[TabEnum.more.index],
                  child: MoreScreen()),
            ],
          ),
          bottomNavigationBar: KeepAliveComponent(
              child: BottomBarNavigation()),
        ),
      ),
    );
  }
}
