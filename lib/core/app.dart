import 'package:flutter/material.dart';
import 'package:hotel_app/features/example/presentation/ui/example_screen.dart';
import 'package:hotel_app/features/more/presentation/ui/more_screen.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp.router(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
    //     useMaterial3: true,
    //   ),
    //   routerConfig: goRouter,
    // );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MoreScreen(),
    );
  }
}

