import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/widgets/keep_alive_component.dart';
import 'package:hotel_app/features/home/home_screen.dart';
import 'package:hotel_app/features/main/presentation/provider/tab_provider.dart';
import 'package:hotel_app/features/main/presentation/ui/bottom_bar_navigation.dart';
import 'package:hotel_app/features/main/presentation/ui/tab_component.dart';
import 'package:hotel_app/features/more_user/more_user_srceen.dart';
import 'package:hotel_app/features/order/orderscreen.dart';
import '../features/main/presentation/model/tab_model.dart';
import '../features/noti/noti_screen.dart';
import 'firebase_messaging_service.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with SingleTickerProviderStateMixin {
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: SafeArea(
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
                    child: MoreUserSrceen()),
              ],
            ),
            bottomNavigationBar: const KeepAliveComponent(
                child: BottomBarNavigation()),
          ),
        ),
      ),
    );
  }
}
