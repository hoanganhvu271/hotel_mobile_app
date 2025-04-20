//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class Local extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: double.infinity,
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             spacing: 40,
//             children: [
//               SizedBox(
//                 width: 77,
//                 height: 32,
//                 child: Text(
//                   'Khu vực',
//                   style: TextStyle(
//                     color: const Color(0xFF65462D),
//                     fontSize: 18,
//                     fontFamily: 'Inter',
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 216,
//                 height: 32,
//                 clipBehavior: Clip.antiAlias,
//                 decoration: ShapeDecoration(
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(
//                       width: 1,
//                       color: const Color(0xFFCAC4D0) /* Schemes-Outline-Variant */,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         spacing: 8,
//                         children: [
//                           Text(
//                             'All',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: const Color(0xFF9A775C),
//                               fontSize: 14,
//                               fontFamily: 'Roboto',
//                               fontWeight: FontWeight.w500,
//                               height: 1.43,
//                               letterSpacing: 0.10,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }