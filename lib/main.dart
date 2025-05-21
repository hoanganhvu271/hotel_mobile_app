import 'dart:async';
import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/security_flatform.dart';
import 'core/app.dart';
import 'core/observers.dart';
import 'di/injector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> runMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  checkSecurity();

  await initSingletons();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Bắt lỗi trong UI thread
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  //Bắt lỗi toàn cục từ nền tảng (Flutter 3.7+)
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  //Noti:
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(ProviderScope(
    observers: [
      Observers(),
    ],
    child: MyApp(),
  ));
}

void checkSecurity() async {
  bool isRooted = await SecurityPlatform.isRooted();
  bool isEmulator = await SecurityPlatform.isEmulator();
  print("Device rooted? $isRooted, Emulator? $isEmulator");
}

void main() {
  runZonedGuarded(() {
    runMain();
  }, (error, stackTrace) {
    // Bắt lỗi async ngoài UI thread
    FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
  });
}

