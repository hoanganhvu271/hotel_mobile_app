import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/example/presentation/ui/example_screen.dart';
import 'package:hotel_app/features/more/presentation/ui/more_screen.dart';

import 'firebase_messaging_service.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize Firebase Messaging
    _initializeFirebaseMessaging();
  }

  Future<void> _initializeFirebaseMessaging() async {
    try {
      await ref.read(firebaseMessagingServiceProvider).initializeFirebaseMessaging();
    } catch (e) {
      print('Error initializing Firebase Messaging: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MoreScreen(),
    );
  }
}