//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class Bookinginfo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//         mainAxisAlignment: MainAxisAlignment.center,  // Căn giữa theo chiều dọc
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Column(
//           // return Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             spacing: 8,
//             children: [
//               Container(
//                 width: double.infinity,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   spacing: 40,
//                   children: [
//                     SizedBox(
//                       width: 77,
//                       height: 32,
//                       child: Text(
//                         'Khu vực',
//                         style: TextStyle(
//                           color: const Color(0xFF65462D),
//                           fontSize: 18,
//                           fontFamily: 'Inter',
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 216,
//                       height: 32,
//                       clipBehavior: Clip.antiAlias,
//                       decoration: ShapeDecoration(
//                         shape: RoundedRectangleBorder(
//                           side: BorderSide(
//                             width: 1,
//                             color: const Color(0xFFCAC4D0) /* Schemes-Outline-Variant */,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               spacing: 8,
//                               children: [
//                                 Text(
//                                   'All',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: const Color(0xFF9A775C),
//                                     fontSize: 14,
//                                     fontFamily: 'Roboto',
//                                     fontWeight: FontWeight.w500,
//                                     height: 1.43,
//                                     letterSpacing: 0.10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   spacing: 9,
//                   children: [
//                     SizedBox(
//                       width: 107,
//                       height: 34,
//                       child: Text(
//                         'Nhận phòng',
//                         style: TextStyle(
//                           color: const Color(0xFF65462D),
//                           fontSize: 18,
//                           fontFamily: 'Inter',
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 215,
//                       decoration: ShapeDecoration(
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         spacing: 6,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
//                             decoration: ShapeDecoration(
//                               color: const Color(0x1E787880) /* Fills-Tertiary */,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               spacing: 5,
//                               children: [
//                                 Text(
//                                   'Jun 10,',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: const Color(0xFF65462D),
//                                     fontSize: 17,
//                                     fontFamily: 'SF Pro',
//                                     fontWeight: FontWeight.w400,
//                                     height: 1.29,
//                                     letterSpacing: -0.43,
//                                   ),
//                                 ),
//                                 Text(
//                                   '2024',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: const Color(0xFF65462D),
//                                     fontSize: 17,
//                                     fontFamily: 'SF Pro',
//                                     fontWeight: FontWeight.w400,
//                                     height: 1.29,
//                                     letterSpacing: -0.43,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
//                             decoration: ShapeDecoration(
//                               color: const Color(0x1E787880) /* Fills-Tertiary */,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               spacing: 10,
//                               children: [
//                                 Text(
//                                   '9:41 AM',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: const Color(0xFF65462D),
//                                     fontSize: 17,
//                                     fontFamily: 'SF Pro',
//                                     fontWeight: FontWeight.w400,
//                                     height: 1.29,
//                                     letterSpacing: -0.43,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   spacing: 26,
//                   children: [
//                     SizedBox(
//                       width: 89,
//                       height: 34,
//                       child: Text(
//                         'Trả phòng',
//                         style: TextStyle(
//                           color: const Color(0xFF65462D),
//                           fontSize: 18,
//                           fontFamily: 'Inter',
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 215,
//                       decoration: ShapeDecoration(
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         spacing: 6,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
//                             decoration: ShapeDecoration(
//                               color: const Color(0x1E787880) /* Fills-Tertiary */,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               spacing: 5,
//                               children: [
//                                 Text(
//                                   'Jun 10,',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: const Color(0xFF65462D),
//                                     fontSize: 17,
//                                     fontFamily: 'SF Pro',
//                                     fontWeight: FontWeight.w400,
//                                     height: 1.29,
//                                     letterSpacing: -0.43,
//                                   ),
//                                 ),
//                                 Text(
//                                   '2024',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: const Color(0xFF65462D),
//                                     fontSize: 17,
//                                     fontFamily: 'SF Pro',
//                                     fontWeight: FontWeight.w400,
//                                     height: 1.29,
//                                     letterSpacing: -0.43,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
//                             decoration: ShapeDecoration(
//                               color: const Color(0x1E787880) /* Fills-Tertiary */,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               spacing: 10,
//                               children: [
//                                 Text(
//                                   '9:41 AM',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: const Color(0xFF65462D),
//                                     fontSize: 17,
//                                     fontFamily: 'SF Pro',
//                                     fontWeight: FontWeight.w400,
//                                     height: 1.29,
//                                     letterSpacing: -0.43,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 width: 333,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   spacing: 30,
//                   children: [
//                     SizedBox(
//                       width: 86,
//                       height: 32,
//                       child: Text(
//                         'Người lớn',
//                         style: TextStyle(
//                           color: const Color(0xFF65462D),
//                           fontSize: 18,
//                           fontFamily: 'Inter',
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 216,
//                       height: 32,
//                       clipBehavior: Clip.antiAlias,
//                       decoration: ShapeDecoration(
//                         shape: RoundedRectangleBorder(
//                           side: BorderSide(
//                             width: 1,
//                             color: const Color(0xFFCAC4D0) /* Schemes-Outline-Variant */,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               spacing: 8,
//                               children: [
//                                 Text(
//                                   '2',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: const Color(0xFF9A775C),
//                                     fontSize: 14,
//                                     fontFamily: 'Roboto',
//                                     fontWeight: FontWeight.w500,
//                                     height: 1.43,
//                                     letterSpacing: 0.10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   spacing: 54,
//                   children: [
//                     SizedBox(
//                       width: 61,
//                       height: 32,
//                       child: Text(
//                         'Trẻ em',
//                         style: TextStyle(
//                           color: const Color(0xFF65462D),
//                           fontSize: 18,
//                           fontFamily: 'Inter',
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 218,
//                       height: 32,
//                       clipBehavior: Clip.antiAlias,
//                       decoration: ShapeDecoration(
//                         shape: RoundedRectangleBorder(
//                           side: BorderSide(
//                             width: 1,
//                             color: const Color(0xFFCAC4D0) /* Schemes-Outline-Variant */,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               spacing: 8,
//                               children: [
//                                 Text(
//                                   '0',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: const Color(0xFF9A775C),
//                                     fontSize: 14,
//                                     fontFamily: 'Roboto',
//                                     fontWeight: FontWeight.w500,
//                                     height: 1.43,
//                                     letterSpacing: 0.10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   spacing: 17,
//                   children: [
//                     SizedBox(
//                       width: 99,
//                       height: 32,
//                       child: Text(
//                         'Khoảng giá',
//                         style: TextStyle(
//                           color: const Color(0xFF65462D),
//                           fontSize: 18,
//                           fontFamily: 'Inter',
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 100,
//                       height: 32,
//                       clipBehavior: Clip.antiAlias,
//                       decoration: ShapeDecoration(
//                         shape: RoundedRectangleBorder(
//                           side: BorderSide(
//                             width: 1,
//                             color: const Color(0xFFCAC4D0) /* Schemes-Outline-Variant */,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               spacing: 8,
//                               children: [
//                                 Text(
//                                   'Từ',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: const Color(0xFF9A775C),
//                                     fontSize: 14,
//                                     fontFamily: 'Roboto',
//                                     fontWeight: FontWeight.w500,
//                                     height: 1.43,
//                                     letterSpacing: 0.10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       width: 98,
//                       height: 32,
//                       clipBehavior: Clip.antiAlias,
//                       decoration: ShapeDecoration(
//                         shape: RoundedRectangleBorder(
//                           side: BorderSide(
//                             width: 1,
//                             color: const Color(0xFFCAC4D0) /* Schemes-Outline-Variant */,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               spacing: 8,
//                               children: [
//                                 Text(
//                                   'Đến',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: const Color(0xFF9A775C),
//                                     fontSize: 14,
//                                     fontFamily: 'Roboto',
//                                     fontWeight: FontWeight.w500,
//                                     height: 1.43,
//                                     letterSpacing: 0.10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   spacing: 40,
//                   children: [
//                     SizedBox(
//                       width: 77,
//                       height: 32,
//                       child: Text(
//                         'Sắp xếp',
//                         style: TextStyle(
//                           color: const Color(0xFF65462D),
//                           fontSize: 18,
//                           fontFamily: 'Inter',
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 216,
//                       height: 32,
//                       clipBehavior: Clip.antiAlias,
//                       decoration: ShapeDecoration(
//                         shape: RoundedRectangleBorder(
//                           side: BorderSide(
//                             width: 1,
//                             color: const Color(0xFFCAC4D0) /* Schemes-Outline-Variant */,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               spacing: 8,
//                               children: [
//                                 Text(
//                                   'Giá thấp - cao',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: const Color(0xFF9A775C),
//                                     fontSize: 14,
//                                     fontFamily: 'Roboto',
//                                     fontWeight: FontWeight.w500,
//                                     height: 1.43,
//                                     letterSpacing: 0.10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: 333,
//                 child: Text(
//                   'Dịch vụ',
//                   style: TextStyle(
//                     color: const Color(0xFF65462D),
//                     fontSize: 18,
//                     fontFamily: 'Inter',
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 143,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 49,
//                             padding: const EdgeInsets.all(4),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(11),
//                                   decoration: ShapeDecoration(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(100),
//                                     ),
//                                   ),
//                                   child: Stack(
//                                     children: [
//                                       Container(
//                                         width: 18,
//                                         height: 18,
//                                         decoration: ShapeDecoration(
//                                           color: const Color(0xFF65462D),
//                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         left: 8,
//                                         top: 8,
//                                         child: Container(width: 24, height: 24, child: Stack()),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.all(10),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               spacing: 10,
//                               children: [
//                                 Text(
//                                   'Ti vi',
//                                   style: TextStyle(
//                                     color: const Color(0xFF65462D),
//                                     fontSize: 18,
//                                     fontFamily: 'Inter',
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 49,
//                           padding: const EdgeInsets.all(4),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(11),
//                                 decoration: ShapeDecoration(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(100),
//                                   ),
//                                 ),
//                                 child: Stack(
//                                   children: [
//                                     Container(
//                                       width: 18,
//                                       height: 18,
//                                       decoration: ShapeDecoration(
//                                         color: const Color(0xFF65462D),
//                                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       left: 8,
//                                       top: 8,
//                                       child: Container(width: 24, height: 24, child: Stack()),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(10),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             spacing: 10,
//                             children: [
//                               Text(
//                                 'Netflix',
//                                 style: TextStyle(
//                                   color: const Color(0xFF65462D),
//                                   fontSize: 18,
//                                   fontFamily: 'Inter',
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 49,
//                           padding: const EdgeInsets.all(4),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(11),
//                                 decoration: ShapeDecoration(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(100),
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       width: 18,
//                                       height: 18,
//                                       decoration: ShapeDecoration(
//                                         shape: RoundedRectangleBorder(
//                                           side: BorderSide(
//                                             width: 2,
//                                             color: const Color(0xFF49454F) /* Schemes-On-Surface-Variant */,
//                                           ),
//                                           borderRadius: BorderRadius.circular(2),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(10),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             spacing: 10,
//                             children: [
//                               Text(
//                                 'Bồn tắm',
//                                 style: TextStyle(
//                                   color: const Color(0xFF65462D),
//                                   fontSize: 18,
//                                   fontFamily: 'Inter',
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           )
//         ],
//       );
//     }
//   }
//
// //   }
// // }
