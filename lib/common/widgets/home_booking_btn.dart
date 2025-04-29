import 'package:flutter/material.dart';

class BookingBtn extends StatelessWidget {
  final String label;
  final Widget screen;

  const BookingBtn({
    Key? key,
    required this.label,
    required this.screen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 412,
          height: 99,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screen),
                );
              },
              child: Container(
                width: 390,
                height: 55,
                decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.00, 0.50),
                    end: Alignment(1.00, 0.50),
                    colors: [Color(0xFFAE8463), Color(0xFF937054), Color(0xFF483729)],
                  ),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
