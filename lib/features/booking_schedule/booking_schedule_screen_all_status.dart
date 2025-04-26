// import 'package:flutter/material.dart';
// import 'package:hotel_app/common/widgets/heading.dart';
// import 'package:hotel_app/features/booking_schedule/services/booking_schedule_service.dart';
// import 'package:intl/intl.dart';
// import 'dart:math' as math;
// import 'model/booking_schedule_models.dart';
//
// class BookingScheduleScreen extends StatefulWidget {
//   final int ownerUserId;
//
//   const BookingScheduleScreen({Key? key, required this.ownerUserId})
//       : super(key: key);
//
//   @override
//   _BookingScheduleScreenState createState() => _BookingScheduleScreenState();
// }
//
// class _BookingScheduleScreenState extends State<BookingScheduleScreen> {
//   Future<List<BookingDetail>>? _bookingsFuture;
//   final BookingScheduleService _bookingService = BookingScheduleService();
//   Map<int, List<BookingDetail>> _bookingsByRoom = {};
//   List<RoomDto> _uniqueRooms = [];
//   DateTime _startDate =
//       DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
//   int _numberOfDaysToShow = 14;
//   List<DateTime> _dateHeaders = [];
//   final double _roomHeaderWidth = 150.0;
//   final double _dateCellWidth = 100.0;
//   final double _rowHeight = 60.0;
//   final double _dateHeaderHeight = 50.0;
//   final ScrollController _horizontalController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _generateDateHeaders();
//     _fetchAndProcessBookings();
//   }
//
//   @override
//   void dispose() {
//     _horizontalController.dispose();
//     super.dispose();
//   }
//
//   void _generateDateHeaders() {
//     _startDate = DateTime(_startDate.year, _startDate.month, _startDate.day);
//     _dateHeaders = List.generate(
//       _numberOfDaysToShow,
//       (index) => _startDate.add(Duration(days: index)),
//     );
//   }
//
//   void _fetchAndProcessBookings() {
//     _bookingsFuture = _bookingService.fetchBookingsByOwner(widget.ownerUserId);
//     _bookingsFuture!.then((bookings) {
//       if (mounted) {
//         final grouped = <int, List<BookingDetail>>{};
//         final rooms = <int, RoomDto>{};
//         for (var booking in bookings) {
//           final roomId = booking.roomDto.roomId;
//           if (!grouped.containsKey(roomId)) grouped[roomId] = [];
//           grouped[roomId]!.add(booking);
//           if (!rooms.containsKey(roomId)) rooms[roomId] = booking.roomDto;
//         }
//         setState(() {
//           _bookingsByRoom = grouped;
//           _uniqueRooms = rooms.values.toList()
//             ..sort((a, b) => a.roomName.compareTo(b.roomName));
//         });
//       }
//     }).catchError((error, stackTrace) {
//       if (mounted) {
//         print("Error fetching/processing bookings: $error\n$stackTrace");
//         setState(() {});
//       }
//     });
//     if (_bookingsFuture != null && mounted) setState(() {});
//   }
//
//   Widget _buildFullDateHeaderRow() {
//     return SizedBox(
//       height: _dateHeaderHeight,
//       child: Row(
//         children: [
//           Container(
//             width: _roomHeaderWidth,
//             height: _dateHeaderHeight,
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               border: Border(
//                 bottom: BorderSide(color: Colors.grey[300]!),
//                 right: BorderSide(color: Colors.grey[300]!),
//               ),
//             ),
//           ),
//           Row(
//             children: _dateHeaders.map((date) {
//               final now = DateTime.now();
//               final isToday = date.year == now.year &&
//                   date.month == now.month &&
//                   date.day == now.day;
//               return Container(
//                 width: _dateCellWidth,
//                 height: _dateHeaderHeight,
//                 decoration: BoxDecoration(
//                   color: isToday ? Colors.blue[50] : Colors.grey[200],
//                   border: Border(
//                     bottom: BorderSide(color: Colors.grey[300]!),
//                     right: BorderSide(color: Colors.grey[300]!),
//                   ),
//                 ),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(DateFormat('d').format(date),
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                               color: isToday ? Colors.blue[800] : null)),
//                       Text(DateFormat('EEE').format(date),
//                           style: TextStyle(
//                               fontSize: 12,
//                               color: isToday
//                                   ? Colors.blue[700]
//                                   : Colors.grey[600])),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildIntegratedRoomRow(BuildContext context, RoomDto room) {
//     final bookingsForThisRoom = _bookingsByRoom[room.roomId] ?? [];
//     return SizedBox(
//       height: _rowHeight,
//       child: Row(
//         children: [
//           Container(
//             width: _roomHeaderWidth,
//             height: _rowHeight,
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               border: Border(
//                 bottom: BorderSide(color: Colors.grey[300]!),
//                 right: BorderSide(color: Colors.grey[300]!),
//               ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(room.roomName,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 13),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis),
//               ],
//             ),
//           ),
//           SizedBox(
//             width: _dateCellWidth * _numberOfDaysToShow,
//             height: _rowHeight,
//             child: Stack(
//               clipBehavior: Clip.hardEdge,
//               children: [
//                 _buildBackgroundDateCellsForRow(),
//                 ..._buildBookingBlocksForRow(context, bookingsForThisRoom),
//                 // Call the modified function
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBackgroundDateCellsForRow() {
//     return Row(
//       children: List.generate(_numberOfDaysToShow, (dayIndex) {
//         final cellDate = _startDate.add(Duration(days: dayIndex));
//         final now = DateTime.now();
//         final isToday = cellDate.year == now.year &&
//             cellDate.month == now.month &&
//             cellDate.day == now.day;
//         return Container(
//           width: _dateCellWidth,
//           height: _rowHeight,
//           decoration: BoxDecoration(
//             color: isToday ? Colors.blue[50]?.withOpacity(0.3) : null,
//             border: Border(
//               bottom: BorderSide(color: Colors.grey[300]!),
//               right: BorderSide(color: Colors.grey[300]!),
//             ),
//           ),
//         );
//       }),
//     );
//   }
//
//   List<Widget> _buildBookingBlocksForRow(
//       BuildContext context, List<BookingDetail> bookings) {
//     List<Widget> bookingWidgets = [];
//     DateTime timelineStart = _startDate;
//     DateTime timelineEnd = _startDate.add(Duration(days: _numberOfDaysToShow));
//     double pixelsPerHour = _dateCellWidth / 24.0;
//
//     final timeFormat = DateFormat('HH:mm');
//
//     for (var booking in bookings) {
//       if (booking.status.toUpperCase() == 'CANCELLED') continue;
//       DateTime checkIn = booking.checkIn;
//       DateTime checkOut = booking.checkOut;
//       if (checkOut.isBefore(timelineStart) || checkIn.isAfter(timelineEnd))
//         continue;
//
//       double startPixelOffset = checkIn.isBefore(timelineStart)
//           ? 0.0
//           : checkIn.difference(timelineStart).inMinutes *
//               (pixelsPerHour / 60.0);
//       double endPixelOffset = checkOut.isAfter(timelineEnd)
//           ? _numberOfDaysToShow * _dateCellWidth
//           : checkOut.difference(timelineStart).inMinutes *
//               (pixelsPerHour / 60.0);
//       double blockWidth = endPixelOffset - startPixelOffset;
//
//       if (blockWidth < 2.0) blockWidth = 2.0;
//       if (blockWidth <= 0) continue;
//
//       Color blockColor = booking.status.toUpperCase() == 'CONFIRMED'
//           ? Colors.teal.shade400
//           : Colors.orange.shade400;
//
//       String timeString =
//           "${timeFormat.format(checkIn)} - ${timeFormat.format(checkOut)}";
//       bookingWidgets.add(
//         Positioned(
//           left: startPixelOffset + 1.0,
//           top: 5.0,
//           height: _rowHeight - 10.0,
//           width: math.max(0, blockWidth - 2.0),
//           child: GestureDetector(
//             onTap: () => _showBookingDetailsDialog(context, booking),
//             child: Tooltip(
//               message:
//                   'ID: ${booking.bookingId}\nKhách: ${booking.userDto.fullName}\nNhận: ${DateFormat('dd/MM/yy HH:mm').format(booking.checkIn)}\nTrả: ${DateFormat('dd/MM/yy HH:mm').format(booking.checkOut)}\nStatus: ${booking.status}',
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: blockColor.withOpacity(0.85),
//                   borderRadius: BorderRadius.circular(4.0),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 2.0,
//                         offset: const Offset(0, 1))
//                   ],
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                 alignment: Alignment.center,
//                 child: Text(
//                   timeString,
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w500),
//                   textAlign: TextAlign.center,
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 1,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//     return bookingWidgets;
//   }
//
//   void _showBookingDetailsDialog(BuildContext context, BookingDetail booking) {
//     final dateFormat = DateFormat('HH:mm dd/MM/yyyy');
//     final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Chi tiết đặt phòng #${booking.bookingId}'),
//             content: SingleChildScrollView(
//                 child: ListBody(children: <Widget>[
//               _buildDetailRow('Trạng thái:', booking.status),
//               _buildDetailRow('Phòng:', booking.roomDto.roomName),
//               _buildDetailRow('Khách:', booking.userDto.fullName),
//               _buildDetailRow('Điện thoại:', booking.userDto.phone),
//               _buildDetailRow('Check In:', dateFormat.format(booking.checkIn)),
//               _buildDetailRow(
//                   'Check Out:', dateFormat.format(booking.checkOut)),
//               _buildDetailRow('Giá:', currencyFormat.format(booking.price)),
//               _buildDetailRow('Ngày đặt:',
//                   DateFormat('HH:mm dd/MM/yyyy').format(booking.createdAt)),
//             ])),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('Đóng'),
//                 onPressed: () => Navigator.of(context).pop(),
//               )
//             ],
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.0)),
//             contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
//           );
//         });
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('$label ',
//               style: const TextStyle(
//                   fontWeight: FontWeight.bold, color: Colors.black54)),
//           Expanded(
//               child:
//                   Text(value, style: const TextStyle(color: Colors.black87))),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           automaticallyImplyLeading: false,
//           titleSpacing: 0,
//           backgroundColor: Color(0xFF65462D),
//           elevation: 2,
//           title: Stack(alignment: Alignment.center, children: [
//             const Heading(title: 'LỊCH ĐẶT PHÒNG'),
//             Positioned(
//                 left: 0,
//                 top: 0,
//                 bottom: 0,
//                 child: IconButton(
//                     icon: const Icon(Icons.arrow_back, color: Colors.white),
//                     tooltip: 'Quay lại',
//                     onPressed: () => Navigator.pop(context))),
//             Positioned(
//                 right: 0,
//                 top: 0,
//                 bottom: 0,
//                 child: Row(mainAxisSize: MainAxisSize.min, children: [
//                   IconButton(
//                       icon: const Icon(Icons.chevron_left, color: Colors.white),
//                       tooltip: 'Trước ${_numberOfDaysToShow} ngày',
//                       onPressed: () => setState(() {
//                             _startDate = _startDate
//                                 .subtract(Duration(days: _numberOfDaysToShow));
//                             _generateDateHeaders();
//                           })),
//                   IconButton(
//                       icon: const Icon(
//                         Icons.today,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                       tooltip: 'Về hôm nay',
//                       onPressed: () => setState(() {
//                             _startDate = DateTime(DateTime.now().year,
//                                 DateTime.now().month, DateTime.now().day);
//                             _generateDateHeaders();
//                           })),
//                   IconButton(
//                       icon:
//                           const Icon(Icons.chevron_right, color: Colors.white),
//                       tooltip: 'Sau ${_numberOfDaysToShow} ngày',
//                       onPressed: () => setState(() {
//                             _startDate = _startDate
//                                 .add(Duration(days: _numberOfDaysToShow));
//                             _generateDateHeaders();
//                           })),
//                 ])),
//           ])),
//       body: FutureBuilder<List<BookingDetail>>(
//         future: _bookingsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting &&
//               _uniqueRooms.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(
//                 child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(mainAxisSize: MainAxisSize.min, children: [
//                       const Icon(Icons.error_outline,
//                           color: Colors.red, size: 40),
//                       const SizedBox(height: 15),
//                       Text('Lỗi tải lịch đặt phòng',
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleLarge
//                               ?.copyWith(color: Colors.red[700])),
//                       const SizedBox(height: 8),
//                       Text('${snapshot.error}',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(color: Colors.grey[600])),
//                       const SizedBox(height: 20),
//                       ElevatedButton.icon(
//                           icon: const Icon(Icons.refresh),
//                           label: const Text('Thử lại'),
//                           onPressed: _fetchAndProcessBookings)
//                     ])));
//           }
//           if (_uniqueRooms.isEmpty &&
//               snapshot.connectionState == ConnectionState.done) {
//             return Center(
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                   Icon(Icons.bed_outlined, size: 60, color: Colors.grey[400]),
//                   const SizedBox(height: 15),
//                   Text('Không có phòng nào được tìm thấy.',
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleLarge
//                           ?.copyWith(color: Colors.grey[600])),
//                   const SizedBox(height: 10),
//                   Text('Kiểm tra lại dữ liệu hoặc thử tải lại.',
//                       style: TextStyle(color: Colors.grey[500])),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                       icon: const Icon(Icons.refresh),
//                       label: const Text('Tải lại dữ liệu'),
//                       onPressed: _fetchAndProcessBookings)
//                 ]));
//           }
//
//           return SingleChildScrollView(
//             controller: _horizontalController,
//             scrollDirection: Axis.horizontal,
//             physics: const ClampingScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildFullDateHeaderRow(),
//                 Column(
//                   children: _uniqueRooms.map((room) {
//                     return _buildIntegratedRoomRow(context, room);
//                   }).toList(),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
