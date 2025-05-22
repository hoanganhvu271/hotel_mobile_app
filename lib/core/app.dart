import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/widgets/keep_alive_component.dart';
import 'package:hotel_app/features/home/home_screen.dart';
import 'package:hotel_app/features/login/login_screen.dart';
import 'package:hotel_app/features/main/presentation/provider/tab_provider.dart';
import 'package:hotel_app/features/main/presentation/ui/bottom_bar_navigation.dart';
import 'package:hotel_app/features/main/presentation/ui/tab_component.dart';
import 'package:hotel_app/features/order/orderscreen.dart';
import '../features/main/presentation/model/tab_model.dart';
import '../features/more/presentation/ui/more_screen.dart';
import '../features/noti/noti_screen.dart';
import 'firebase_messaging_service.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const SafeArea(
        child: Scaffold(
          body: LoginScreen()
        )
      ),
    );
  }
}
