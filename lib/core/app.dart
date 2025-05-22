import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/main/presentation/ui/main_screen.dart';
import '../security_flatform.dart';
import 'firebase_messaging_service.dart';
import 'global.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkSecurity(context); // context đảm bảo hợp lệ
    });
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

  Future<bool> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');
      int? userId = prefs.getInt('user_id');

      return token != null && token.isNotEmpty && userId != null;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: SafeArea(
        child: Scaffold(
          body: FutureBuilder<bool>(
            future: _checkLoginStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const LoginScreen();
              }

              final isLoggedIn = snapshot.data ?? false;

              if (isLoggedIn) {
                return const MainScreen();
              } else {
                return const LoginScreen();
              }
            },
          ),
        ),
      ),
    );
  }


  Future<void> checkSecurity(BuildContext context) async {
    bool isRooted = await SecurityPlatform.isRooted();
    bool isEmulator = await SecurityPlatform.isEmulator();
    print("Device rooted? $isRooted, Emulator? $isEmulator");

    if (isRooted || isEmulator) {
      print("Unauthorized device detected. Closing app...");

      // if (Platform.isAndroid) {
      //   SystemNavigator.pop();
      // } else {
      //   exit(0);
      // }

      await Future.delayed(const Duration(milliseconds: 500));
      exit(0);
    }
  }

}
