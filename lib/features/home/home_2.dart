import 'package:flutter/material.dart';

class Home2 extends StatelessWidget {
  const Home2({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text("Back"),
        ),
      ),
    );
  }
}
