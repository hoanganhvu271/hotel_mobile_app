import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_app/core/app.dart';

import '../features/splash/presentation/ui/splash_screen.dart';


enum Routes {
  splash,
  home,
  map,
  booking,
  notification,
  more,
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/',
      name: Routes.splash.name,
      builder: (context, state) => SplashScreen(key: state.pageKey),
    ),
    GoRoute(
      path: '/home',
      name: Routes.home.name,
      // builder: (context, state) => HomePage(key: state.pageKey),
    ),
    GoRoute(
      path: '/map',
      name: Routes.map.name,
      // builder: (context, state) => MapPage(key: state.pageKey),
    ),
    GoRoute(
      path: '/booking',
      name: Routes.booking.name,
      // builder: (context, state) => BookingPage(key: state.pageKey),
    ),
    GoRoute(
      path: '/notification',
      name: Routes.notification.name,
      // builder: (context, state) => NotificationPage(key: state.pageKey),
    ),
    GoRoute(
      path: '/more',
      name: Routes.more.name,
      // builder: (context, state) => MorePage(key: state.pageKey),
    ),
  ],
);