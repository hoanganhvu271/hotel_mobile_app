import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app.dart';
import 'core/observers.dart';
import 'di/injector.dart';

void main() => runMain();

Future<void> runMain() async {
  //Đảm bảo tất cả các singleton được khởi tạo trước khi runApp.
  WidgetsFlutterBinding.ensureInitialized();
  await initSingletons();

  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  //status bar color
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
  //   statusBarColor: AppColors.white,
  //   statusBarBrightness: Brightness.light,
  // ));

  runApp(ProviderScope(
    observers: [
      Observers(),
    ],
    child: const MyApp(),
  ));
}
