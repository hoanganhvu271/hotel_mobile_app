import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReadOnlyDateTimeDisplay extends StatelessWidget {
  final String label;
  final String time;
  final String date;

  const ReadOnlyDateTimeDisplay({
    super.key,
    required this.label,
    required this.time,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Color(0xFF65462D),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            width: 80,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            margin: const EdgeInsets.only(right: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0x1E787880),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              time,
              style: const TextStyle(
                color: Color(0xFF65462D),
                fontSize: 16,
              ),
            ),
          ),
          Container(
            width: 130,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0x1E787880),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              date,
              style: const TextStyle(
                color: Color(0xFF65462D),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
