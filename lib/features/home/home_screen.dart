import 'package:flutter/material.dart';

import 'home_2.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Home2(),
          ),
        ),
        child: Container(
          child: Text("Hello"),
        ),
      ),
    );
  }
}
