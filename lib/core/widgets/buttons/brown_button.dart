import 'package:flutter/material.dart';

class BrownButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;

  const BrownButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width = 131,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: screenWidth / 3,
        height: width / 2,
        decoration: ShapeDecoration(
          color: const Color(0xFFA68367),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(90),
          ),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
