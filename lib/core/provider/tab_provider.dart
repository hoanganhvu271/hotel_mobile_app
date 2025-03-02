import 'package:flutter_riverpod/flutter_riverpod.dart';

final tabIndexProvider = StateProvider<int>((ref) => 0);

const List<String> tabRoutes = [
  '/home',
  '/map',
  '/booking',
  '/notification',
  '/more',
];
