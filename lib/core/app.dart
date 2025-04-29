import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/widgets/keep_alive_component.dart';
import 'package:hotel_app/features/home/home_screen.dart';
import 'package:hotel_app/features/main/presentation/provider/tab_provider.dart';
import 'package:hotel_app/features/main/presentation/ui/bottom_bar_navigation.dart';
import 'package:hotel_app/features/main/presentation/ui/tab_component.dart';
import 'package:hotel_app/features/map/map_screen.dart';
import 'package:hotel_app/features/more/more_screen.dart';
import 'package:hotel_app/features/order/orderscreen.dart';
import '../features/main/presentation/model/tab_model.dart';
import '../features/noti/noti_screen.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(tabProvider, (pre, next) => _tabController.animateTo(next.index));

    return MaterialApp(
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
              TabComponent(tabKey: listKey[TabEnum.home.index], child: HomeScreen()),
              TabComponent(tabKey: listKey[TabEnum.map.index], child: MapScreen()),
              TabComponent(tabKey: listKey[TabEnum.order.index], child: OrderScreen()),
              TabComponent(tabKey: listKey[TabEnum.noti.index], child: NotiScreen()),
              TabComponent(tabKey: listKey[TabEnum.more.index], child: MoreScreen()),
            ],
          ),
          bottomNavigationBar: const KeepAliveComponent(child: BottomBarNavigation()),
        ),
      ),
    );
  }
}