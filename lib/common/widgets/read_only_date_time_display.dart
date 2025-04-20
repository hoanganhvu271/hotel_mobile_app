import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//
// class ReadOnlyDateTimeDisplay extends StatelessWidget {
//   final String label;
//   final DateTime dateTime;
//
//   const ReadOnlyDateTimeDisplay({
//     super.key,
//     required this.label,
//     required this.dateTime,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final String displayDate = DateFormat('dd/MM/yyyy').format(dateTime);
//     final String displayTime = DateFormat('HH:mm').format(dateTime);
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               '$label:',
//               style: const TextStyle(
//                 color: Color(0xFF65462D),
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//           Container(
//             width: 80,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             margin: const EdgeInsets.only(right: 5),
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: const Color(0x1E787880),
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: Text(
//               displayTime,
//               style: const TextStyle(
//                 color: Color(0xFF65462D),
//                 fontSize: 16,
//               ),
//             ),
//           ),
//           Container(
//             width: 130,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: const Color(0x1E787880),
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: Text(
//               displayDate,
//               style: const TextStyle(
//                 color: Color(0xFF65462D),
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//
// class ReadOnlyDateTimeDisplay extends StatelessWidget {
//   final String dateTime;
//   final String label;
//
//   const ReadOnlyDateTimeDisplay({
//     super.key,
//     required this.dateTime,
//     required this.label,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
//         const SizedBox(height: 4),
//         Text(dateTime, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//       ],
//     );
//   }
// }

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
