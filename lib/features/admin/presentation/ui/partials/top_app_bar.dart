import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../constants/app_colors.dart';

class TopAppBar extends StatelessWidget {
  final String title;
  final Color backgroundColor;

  const TopAppBar({
    super.key,
    required this.title,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
        decoration: BoxDecoration(
          color: ColorsLib.primaryBoldColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Stack(
          children: [
            SizedBox(
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              left: -3,
              top: -3,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () => Navigator.pop(context),
                    splashColor: Colors.black.withValues(alpha: 0.2),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    )),
                ),
              ),
          ],
        ),
      ),
    );
  }
}