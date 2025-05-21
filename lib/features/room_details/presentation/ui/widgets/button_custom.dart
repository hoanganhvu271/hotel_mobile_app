import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  final String color; // 'white' hoặc 'brown'
  final double width;
  final double height;
  final VoidCallback onPressed;
  final String text;

  const ButtonCustom({
    super.key,
    required this.color,
    required this.width,
    required this.height,
    required this.onPressed,
    this.text = "Button",
  });

  @override
  Widget build(BuildContext context) {
    final bool isWhite = color == 'white';
    final backgroundColor = isWhite ? Colors.white : const Color(0xFFA68367);
    final textColor = isWhite ? const Color(0xFFA68367) : Colors.white;
    final borderColor = const Color(0xFFA68367);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(height / 2),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
