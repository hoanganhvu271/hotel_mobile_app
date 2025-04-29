// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hotel_app/common/widgets/heading.dart';
// import 'package:hotel_app/features/admin_system/model/revenue_model.dart';
// import 'package:hotel_app/features/admin_system/services/revenue_service.dart';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// class AdminRoomRevenueScreen extends StatefulWidget {
//   final int roomId;
//   final String roomName;
//
//   const AdminRoomRevenueScreen({super.key, required this.roomId, required this.roomName});
//
//   @override
//   _AdminRoomRevenueScreenState createState() => _AdminRoomRevenueScreenState();
// }
//
// class _AdminRoomRevenueScreenState extends State<AdminRoomRevenueScreen> {
//   TextEditingController _startDateController = TextEditingController();
//   TextEditingController _endDateController = TextEditingController();
//   DateTime? _startDate;
//   DateTime? _endDate;
//
//   final RevenueService _revenueService = RevenueService();
//   List<FlSpot> revenueData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _startDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     _endDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   }
//
//   Future<void> _selectStartDate(BuildContext context) async {
//     DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: _startDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (selectedDate != null && selectedDate != _startDate) {
//       setState(() {
//         _startDate = selectedDate;
//         _startDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
//       });
//     }
//   }
//
//   Future<void> _selectEndDate(BuildContext context) async {
//     DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: _endDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (selectedDate != null && selectedDate != _endDate) {
//       setState(() {
//         _endDate = selectedDate;
//         _endDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
//       });
//     }
//   }
//
//   // Hàm gọi API để lấy doanh thu
//   Future<void> _fetchRevenue() async {
//     if (_startDate == null || _endDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn cả ngày bắt đầu và ngày kết thúc!')));
//       return;
//     }
//
//     final startDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(_startDate!);
//     final endDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(_endDate!);
//
//     try {
//       // Gọi service API
//       RevenueModel revenue = await _revenueService.fetchRevenueData(startDate, endDate);
//
//       Map<String, double> revenueByDate = {};
//
//       for (var booking in revenue.bookingDetailList) {
//         // Lấy ngày check-in từ mỗi booking
//         String checkInDate = booking.checkIn.substring(0, 10);
//
//         // Kiểm tra xem ngày check-in có trong phạm vi không
//         if (_startDate != null && _endDate != null &&
//             DateTime.parse(checkInDate).isAfter(_startDate!) &&
//             DateTime.parse(checkInDate).isBefore(_endDate!)) {
//
//           if (revenueByDate.containsKey(checkInDate)) {
//             revenueByDate[checkInDate] = revenueByDate[checkInDate]! + booking.price;
//           } else {
//             revenueByDate[checkInDate] = booking.price;
//           }
//         }
//       }
//
//       // Sắp xếp danh sách revenueByDate theo checkInDate
//       List<MapEntry<String, double>> sortedRevenue = revenueByDate.entries.toList()
//         ..sort((a, b) => DateTime.parse(a.key).compareTo(DateTime.parse(b.key)));
//
//       // In ra kết quả
//       print("OK");
//       print(sortedRevenue);
//
//       List<FlSpot> spots = [];
//       sortedRevenue.forEach((entry) {
//         DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(entry.key);
//         spots.add(FlSpot(parsedDate.millisecondsSinceEpoch.toDouble(), entry.value));
//       });
//
//       setState(() {
//         revenueData = spots;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tổng doanh thu: ${revenue.totalRevenue}')));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Transform.translate(
//                   offset: const Offset(0, -25),
//                   child: const Heading(title: 'DANH SÁCH PHÒNG'),
//                 ),
//                 Positioned(
//                   left: 20,
//                   top: 0,
//                   child: IconButton(
//                     icon: const Icon(Icons.arrow_back, color: Colors.white),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 60),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                 children: [
//                   // Chọn ngày bắt đầu
//                   TextField(
//                     controller: _startDateController,
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       labelText: 'Ngày bắt đầu',
//                       suffixIcon: IconButton(
//                         icon: const Icon(Icons.calendar_today),
//                         onPressed: () => _selectStartDate(context),
//                       ),
//                       border: const OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // Chọn ngày kết thúc
//                   TextField(
//                     controller: _endDateController,
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       labelText: 'Ngày kết thúc',
//                       suffixIcon: IconButton(
//                         icon: const Icon(Icons.calendar_today),
//                         onPressed: () => _selectEndDate(context),
//                       ),
//                       border: const OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _fetchRevenue,
//                     child: const Text('Lấy doanh thu'),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: Text(
//                 'Thông tin chi tiết phòng ID: ${widget.roomId}, Tên phòng: ${widget.roomName}',
//                 style: const TextStyle(fontSize: 18),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Vẽ biểu đồ doanh thu
//             Expanded(
//               child: LineChart(
//                 LineChartData(
//                   gridData: FlGridData(show: true),
//                   titlesData: FlTitlesData(show: true),
//                   borderData: FlBorderData(show: true),
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: revenueData,
//                       isCurved: true,
//                       color: Colors.blue,
//                       barWidth: 4,
//                       isStrokeCapRound: true,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hotel_app/common/widgets/heading.dart';
// import 'package:hotel_app/features/admin_system/model/revenue_model.dart';
// import 'package:hotel_app/features/admin_system/services/revenue_service.dart';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// class AdminRoomRevenueScreen extends StatefulWidget {
//   final int roomId;
//   final String roomName;
//
//   const AdminRoomRevenueScreen({super.key, required this.roomId, required this.roomName});
//
//   @override
//   _AdminRoomRevenueScreenState createState() => _AdminRoomRevenueScreenState();
// }
//
// class _AdminRoomRevenueScreenState extends State<AdminRoomRevenueScreen> {
//   TextEditingController _startDateController = TextEditingController();
//   TextEditingController _endDateController = TextEditingController();
//   DateTime? _startDate;
//   DateTime? _endDate;
//
//   final RevenueService _revenueService = RevenueService();
//   List<FlSpot> revenueData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _startDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     _endDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   }
//
//   Future<void> _selectStartDate(BuildContext context) async {
//     DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: _startDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (selectedDate != null && selectedDate != _startDate) {
//       setState(() {
//         _startDate = selectedDate;
//         _startDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
//       });
//     }
//   }
//
//   Future<void> _selectEndDate(BuildContext context) async {
//     DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: _endDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (selectedDate != null && selectedDate != _endDate) {
//       setState(() {
//         _endDate = selectedDate;
//         _endDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
//       });
//     }
//   }
//
//   // Hàm gọi API để lấy doanh thu
//   Future<void> _fetchRevenue() async {
//     if (_startDate == null || _endDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn cả ngày bắt đầu và ngày kết thúc!')));
//       return;
//     }
//
//     final startDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(_startDate!);
//     final endDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(_endDate!);
//
//     try {
//       // Gọi service API
//       RevenueModel revenue = await _revenueService.fetchRevenueData(startDate, endDate);
//
//       Map<String, double> revenueByDate = {};
//
//       for (var booking in revenue.bookingDetailList) {
//         // Lấy ngày check-in từ mỗi booking
//         String checkInDate = booking.checkIn.substring(0, 10);
//
//         // Kiểm tra xem ngày check-in có trong phạm vi không
//         if (_startDate != null && _endDate != null &&
//             DateTime.parse(checkInDate).isAfter(_startDate!) &&
//             DateTime.parse(checkInDate).isBefore(_endDate!)) {
//
//           if (revenueByDate.containsKey(checkInDate)) {
//             revenueByDate[checkInDate] = revenueByDate[checkInDate]! + booking.price;
//           } else {
//             revenueByDate[checkInDate] = booking.price;
//           }
//         }
//       }
//
//       // Sắp xếp danh sách revenueByDate theo checkInDate
//       List<MapEntry<String, double>> sortedRevenue = revenueByDate.entries.toList()
//         ..sort((a, b) => DateTime.parse(a.key).compareTo(DateTime.parse(b.key)));
//
//       // In ra kết quả
//       print("OK");
//       print(sortedRevenue);
//
//       List<FlSpot> spots = [];
//       sortedRevenue.forEach((entry) {
//         DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(entry.key);
//         spots.add(FlSpot(parsedDate.millisecondsSinceEpoch.toDouble(), entry.value));
//       });
//
//       setState(() {
//         revenueData = spots;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tổng doanh thu: ${revenue.totalRevenue}')));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Transform.translate(
//                   offset: const Offset(0, -25),
//                   child: const Heading(title: 'DANH SÁCH PHÒNG'),
//                 ),
//                 Positioned(
//                   left: 20,
//                   top: 0,
//                   child: IconButton(
//                     icon: const Icon(Icons.arrow_back, color: Colors.white),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 60),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                 children: [
//                   // Chọn ngày bắt đầu
//                   TextField(
//                     controller: _startDateController,
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       labelText: 'Ngày bắt đầu',
//                       suffixIcon: IconButton(
//                         icon: const Icon(Icons.calendar_today),
//                         onPressed: () => _selectStartDate(context),
//                       ),
//                       border: const OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // Chọn ngày kết thúc
//                   TextField(
//                     controller: _endDateController,
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       labelText: 'Ngày kết thúc',
//                       suffixIcon: IconButton(
//                         icon: const Icon(Icons.calendar_today),
//                         onPressed: () => _selectEndDate(context),
//                       ),
//                       border: const OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _fetchRevenue,
//                     child: const Text('Lấy doanh thu'),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: Text(
//                 'Thông tin chi tiết phòng ID: ${widget.roomId}, Tên phòng: ${widget.roomName}',
//                 style: const TextStyle(fontSize: 18),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Hiển thị doanh thu to ở giữa màn hình
//             Center(
//               child: Text(
//                 'Doanh thu: ${revenueData.isNotEmpty ? revenueData.last.y.toStringAsFixed(2) : '0.00'}',
//                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Vẽ biểu đồ doanh thu
//             Expanded(
//               child:
//
//               LineChart(
//                 LineChartData(
//                   gridData: const FlGridData(show: false), // Tắt các cột ngang
//                   titlesData: const FlTitlesData(show: true), // Consider configuring left/bottom titles
//                   borderData: FlBorderData(show: true),
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: revenueData, // Make sure revenueData is defined and is List<FlSpot>
//                       isCurved: true,
//                       color: Colors.blue, // Use Theme.of(context).primaryColor for theme consistency
//                       barWidth: 4,
//                       isStrokeCapRound: true,
//                       dotData: const FlDotData(show: false), // Hide default dots if desired
//                       belowBarData: BarAreaData(show: false), // Hide area below line if desired
//                     ),
//                   ],
//                   lineTouchData: LineTouchData(
//                     touchTooltipData: LineTouchTooltipData(
//                       tooltipBgColor: Colors.blueAccent,
//                       getTooltipItems: (List<LineBarSpot> touchedSpots) {
//                         return touchedSpots.map((LineBarSpot touchedSpot) {
//                           final textStyle = TextStyle(
//                             color: touchedSpot.bar.gradient?.colors.first ??
//                                 touchedSpot.bar.color ?? // Use bar color
//                                 Colors.white, // Fallback color
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           );
//                           final date = DateFormat('yyyy-MM-dd').format(
//                               DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt()));
//                           return LineTooltipItem(
//                             '${touchedSpot.y.toStringAsFixed(2)}\n', // Value on first line
//                             textStyle,
//                             children: [
//                               TextSpan( // Date on second line, potentially different style
//                                 text: date,
//                                 style: TextStyle(
//                                   color: Colors.white.withOpacity(0.8), // Slightly dimmer color
//                                   fontWeight: FontWeight.normal,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ],
//                             textAlign: TextAlign.center, // Center align tooltip text
//                           );
//                         }).toList();
//                       },
//                     ),
//                     // Use handleBuiltInTouches: true if you want the default hover/tooltip behavior
//                     // handleBuiltInTouches: true,
//                     touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
//                       // Check if the event is a tap up event
//                       if (event is FlTapUpEvent) {
//                         // Check if the tap response is valid and hit a spot
//                         if (response != null && response.lineBarSpots != null && response.lineBarSpots!.isNotEmpty) {
//                           // Get the first spot that was touched
//                           final spot = response.lineBarSpots![0];
//                           // Format the date (X value is epoch milliseconds)
//                           final date = DateFormat('yyyy-MM-dd').format(
//                               DateTime.fromMillisecondsSinceEpoch(spot.x.toInt()));
//                           // Show the SnackBar
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text('Ngày: $date, Doanh thu: ${spot.y.toStringAsFixed(2)}'),
//                               duration: const Duration(seconds: 2), // Optional: Set duration
//                             ),
//                           );
//                         }
//                       }
//                     },
//                     // Optional: Increase the threshold for easier tapping on mobile
//                     touchSpotThreshold: 20,
//                   ),
//                 ),
//               )
//
//
//
//
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:hotel_app/common/widgets/heading.dart';
import 'package:hotel_app/features/admin_system/admin_booking_list.dart';
import 'package:hotel_app/features/admin_system/model/revenue_model.dart'; // Assuming this exists
import 'package:hotel_app/features/admin_system/services/revenue_service.dart'; // Assuming this exists
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math; // For min/max calculation

// Mock RevenueService and RevenueModel for standalone example (replace with your actual ones)
// class RevenueService {
//   Future<RevenueModel> fetchRevenueData(String start, String end) async {
//     await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
//     // Simulate some data based on dates
//     DateTime startDate = DateTime.parse(start.substring(0, 10));
//     DateTime endDate = DateTime.parse(end.substring(0, 10));
//     List<BookingDetail> details = [];
//     double total = 0;
//     for (DateTime d = startDate; d.isBefore(endDate.add(const Duration(days: 1))); d = d.add(const Duration(days: 1))) {
//       if (d.weekday < 6) { // More revenue on weekdays?
//         double dailyRevenue = 500 + math.Random().nextDouble() * 1000;
//         details.add(BookingDetail(checkIn: DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(d), price: dailyRevenue));
//         total += dailyRevenue;
//       }
//     }
//     return RevenueModel(bookingDetailList: details, totalRevenue: total);
//   }
// }
// class RevenueModel {
//   final List<BookingDetail> bookingDetailList;
//   final double totalRevenue;
//   RevenueModel({required this.bookingDetailList, required this.totalRevenue});
// }
// class BookingDetail {
//   final String checkIn;
//   final double price;
//   BookingDetail({required this.checkIn, required this.price});
// }
// --- End Mock Data ---




// okkk
// import 'package:flutter/material.dart';
// import 'package:hotel_app/common/widgets/heading.dart'; // Assuming exists
// import 'package:hotel_app/features/admin_system/model/revenue_model.dart'; // Assuming exists
// import 'package:hotel_app/features/admin_system/services/revenue_service.dart'; // Assuming exists
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'dart:math' as math;
//
// // --- Mock Data (Replace with your actual classes) ---
// class RevenueService {
//   Future<RevenueModel> fetchRevenueData(String start, String end) async {
//     await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
//     DateTime startDate = DateTime.parse(start.substring(0, 10));
//     DateTime endDate = DateTime.parse(end.substring(0, 10));
//     List<BookingDetail> details = [];
//     double total = 0;
//     final random = math.Random();
//     for (DateTime d = startDate; d.isBefore(endDate.add(const Duration(days: 1))); d = d.add(const Duration(days: 1))) {
//       double dailyRevenue = 500 + random.nextDouble() * 1500;
//       details.add(BookingDetail(checkIn: DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(d), price: dailyRevenue));
//       total += dailyRevenue;
//     }
//     // Add some gaps for realism
//     if (details.length > 5) {
//       details.removeAt(details.length ~/ 2);
//       details.removeAt(1);
//     }
//     details.sort((a,b) => a.checkIn.compareTo(b.checkIn)); // Ensure sorted
//     return RevenueModel(bookingDetailList: details, totalRevenue: total);
//   }
// }
// class RevenueModel {
//   final List<BookingDetail> bookingDetailList;
//   final double totalRevenue;
//   RevenueModel({required this.bookingDetailList, required this.totalRevenue});
// }
// class BookingDetail {
//   final String checkIn;
//   final double price;
//   BookingDetail({required this.checkIn, required this.price});
// }
// // --- End Mock Data ---
//
// class AdminRoomRevenueScreen extends StatefulWidget {
//   final int roomId;
//   final String roomName;
//
//   const AdminRoomRevenueScreen({super.key, required this.roomId, required this.roomName});
//
//   @override
//   _AdminRoomRevenueScreenState createState() => _AdminRoomRevenueScreenState();
// }
//
// class _AdminRoomRevenueScreenState extends State<AdminRoomRevenueScreen> {
//   final TextEditingController _startDateController = TextEditingController();
//   final TextEditingController _endDateController = TextEditingController();
//   DateTime? _startDate = DateTime.now();
//   DateTime? _endDate = DateTime.now();
//
//   final RevenueService _revenueService = RevenueService();
//   List<FlSpot> revenueData = [];
//   bool _isLoading = false;
//   double _totalRevenueInRange = 0.0;
//
//   // State variable to hold the X value of the tapped spot
//   double? _selectedSpotX;
//   String? _selectedDateStr; // Store formatted date for SnackBar
//
//   @override
//   void initState() {
//     super.initState();
//     _startDateController.text = DateFormat('yyyy-MM-dd').format(_startDate!);
//     _endDateController.text = DateFormat('yyyy-MM-dd').format(_endDate!);
//     // _fetchRevenue(); // Optional initial fetch
//   }
//
//   @override
//   void dispose() {
//     _startDateController.dispose();
//     _endDateController.dispose();
//     super.dispose();
//   }
//
//
//   Future<void> _selectStartDate(BuildContext context) async {
//     DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: _startDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (selectedDate != null && selectedDate != _startDate) {
//       setState(() {
//         _startDate = selectedDate;
//         _startDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
//         _selectedSpotX = null; // Clear selection when date changes
//         _selectedDateStr = null;
//       });
//     }
//   }
//
//   Future<void> _selectEndDate(BuildContext context) async {
//     DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: _endDate ?? DateTime.now(),
//       firstDate: _startDate ?? DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (selectedDate != null && selectedDate != _endDate) {
//       setState(() {
//         _endDate = selectedDate;
//         _endDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
//         _selectedSpotX = null; // Clear selection when date changes
//         _selectedDateStr = null;
//       });
//     }
//   }
//
//   Future<void> _fetchRevenue() async {
//     // ... (fetch logic remains the same as previous version) ...
//     if (_startDate == null || _endDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn cả ngày bắt đầu và ngày kết thúc!')));
//       return;
//     }
//     if (_endDate!.isBefore(_startDate!)) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ngày kết thúc không được trước ngày bắt đầu!')));
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//       revenueData = [];
//       _totalRevenueInRange = 0;
//       _selectedSpotX = null; // Clear selection on new fetch
//       _selectedDateStr = null;
//     });
//
//     final startDateFormatted = DateFormat("yyyy-MM-dd'T'00:00:00").format(_startDate!);
//     final endDateAdjusted = _endDate!.add(const Duration(days: 1)).subtract(const Duration(microseconds: 1));
//     final endDateFormatted = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(endDateAdjusted);
//
//     try {
//       RevenueModel revenue = await _revenueService.fetchRevenueData(startDateFormatted, endDateFormatted);
//       Map<String, double> revenueByDate = {};
//       double currentTotal = 0.0;
//
//       for (var booking in revenue.bookingDetailList) {
//         String checkInDate = booking.checkIn.substring(0, 10);
//         revenueByDate[checkInDate] = (revenueByDate[checkInDate] ?? 0) + booking.price;
//         currentTotal += booking.price;
//       }
//
//       List<MapEntry<String, double>> sortedRevenue = revenueByDate.entries.toList()
//         ..sort((a, b) => DateTime.parse(a.key).compareTo(DateTime.parse(b.key)));
//
//       List<FlSpot> spots = sortedRevenue.map((entry) {
//         DateTime parsedDate = DateTime.parse(entry.key);
//         return FlSpot(parsedDate.millisecondsSinceEpoch.toDouble(), entry.value);
//       }).toList();
//
//       // --- Ensure there's at least one day gap between points if dates are not consecutive ---
//       // This makes the line connect visually better when there are missing dates
//       List<FlSpot> spacedSpots = [];
//       if (spots.isNotEmpty) {
//         spacedSpots.add(spots[0]);
//         for (int i = 1; i < spots.length; i++) {
//           DateTime prevDate = DateTime.fromMillisecondsSinceEpoch(spots[i-1].x.toInt());
//           DateTime currDate = DateTime.fromMillisecondsSinceEpoch(spots[i].x.toInt());
//           // If not consecutive days, add intermediate points for visual connection (optional)
//           // Note: This adds visual connection but doesn't represent real data for the gap days.
//           // if (currDate.difference(prevDate).inDays > 1) {
//           //   // You could potentially add invisible spots or handle gaps differently
//           // }
//           spacedSpots.add(spots[i]);
//         }
//       }
//       // --- End gap handling ---
//
//
//       setState(() {
//         // revenueData = spots; // Use original spots
//         revenueData = spacedSpots; // Or use spots with potential gap handling
//         _totalRevenueInRange = currentTotal;
//       });
//
//       if (revenueData.isEmpty && mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không có dữ liệu doanh thu cho khoảng thời gian đã chọn.')));
//       }
//
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi lấy dữ liệu: $e')));
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   // Helper function for Y-axis titles (revenue)
//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11, ); // Smaller font
//     String text;
//     if (value == meta.max || value == meta.min) return Container(); // Hide min/max labels often
//
//     if (value >= 1000000) {
//       text = '${(value / 1000000).toStringAsFixed(1)}M';
//     } else if (value >= 1000) {
//       text = '${(value / 1000).toStringAsFixed(0)}k'; // No decimal for k
//     } else {
//       text = value.toStringAsFixed(0);
//     }
//     return SideTitleWidget(axisSide: meta.axisSide, space: 8, child: Text(text, style: style, textAlign: TextAlign.center));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Calculate min/max X/Y and intervals (similar to previous version)
//     double? minX, maxX, minY, maxY;
//     double leftInterval = 100;
//
//     if (revenueData.isNotEmpty) {
//       minX = revenueData.first.x;
//       maxX = revenueData.last.x;
//       // Add padding to X-axis if there's only one point
//       if (revenueData.length == 1) {
//         final oneDay = 24 * 60 * 60 * 1000;
//         minX = minX! - oneDay;
//         maxX = maxX! + oneDay;
//       }
//
//       // Find min/max Y, handling empty list gracefully
//       minY = revenueData.map((spot) => spot.y).reduce(math.min);
//       maxY = revenueData.map((spot) => spot.y).reduce(math.max);
//
//       // Add padding to Y-axis
//       maxY = maxY == 0 ? 100 : maxY * 1.15; // Ensure max isn't 0, add 15% padding
//       minY = 0; // Always start Y axis at 0 for revenue charts
//
//
//       // Calculate dynamic interval for Y axis
//       double rangeY = maxY - minY;
//       if (rangeY > 0) {
//         leftInterval = (rangeY / 5).ceilToDouble(); // Aim for ~5 labels, ceil for nicer intervals
//         // Optional: Round interval to nearest nice number (e.g., 50, 100, 500)
//         if (leftInterval > 1000) leftInterval = (leftInterval / 500).ceil() * 500;
//         else if (leftInterval > 100) leftInterval = (leftInterval / 50).ceil() * 50;
//         else if (leftInterval > 10) leftInterval = (leftInterval / 10).ceil() * 10;
//         else leftInterval = math.max(10, leftInterval); // Min interval of 10
//       } else {
//         leftInterval = math.max(10, maxY / 2); // Handle case with only one value or all zero
//       }
//       // Ensure leftInterval is not zero
//       if (leftInterval <= 0) leftInterval = 100;
//
//     } else {
//       // Default values if no data, to prevent errors
//       minX = DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch.toDouble();
//       maxX = DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch.toDouble();
//       minY = 0;
//       maxY = 100; // Default max Y if no data
//     }
//
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Doanh thu: ${widget.roomName}'),
//         centerTitle: true,
//         backgroundColor: Colors.blueGrey, // Example color
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // --- Date Selection Row and Button ---
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(controller: _startDateController, readOnly: true, decoration: InputDecoration(labelText: 'Bắt đầu', suffixIcon: IconButton(icon: const Icon(Icons.calendar_today, size: 20), onPressed: () => _selectStartDate(context)), border: const OutlineInputBorder(), contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12)), style: const TextStyle(fontSize: 14)),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: TextField(controller: _endDateController, readOnly: true, decoration: InputDecoration(labelText: 'Kết thúc', suffixIcon: IconButton(icon: const Icon(Icons.calendar_today, size: 20), onPressed: () => _selectEndDate(context)), border: const OutlineInputBorder(), contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12)), style: const TextStyle(fontSize: 14)),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: _fetchRevenue,
//               icon: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.bar_chart), // Changed icon
//               label: const Text('Xem Doanh Thu'),
//               style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: Colors.blueGrey),
//             ),
//             const SizedBox(height: 20),
//
//             // --- Total Revenue Display ---
//             Center(
//               child: Text(
//                 'Tổng doanh thu: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(_totalRevenueInRange)}',
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // --- Chart Area ---
//             Expanded(
//                 child: _isLoading && revenueData.isEmpty
//                     ? const Center(child: CircularProgressIndicator())
//                     : revenueData.isEmpty
//                     ? const Center(child: Text('Chọn ngày và nhấn "Xem Doanh Thu".', style: TextStyle(fontSize: 16, color: Colors.grey)))
//                     : LineChart(
//                   LineChartData(
//                     // ----- Min/Max Values -----
//                     minX: minX,
//                     maxX: maxX,
//                     minY: minY, // Always start Y at 0
//                     maxY: maxY, // Use calculated maxY with padding
//
//                     // ----- Grid Data (Dynamic Vertical Line) -----
//                     gridData: FlGridData(
//                       show: true, // SHOW GRID
//                       drawHorizontalLine: false, // HIDE horizontal lines
//                       drawVerticalLine: true,   // SHOW vertical lines (conditionally)
//                       // Function to decide WHERE to draw vertical lines
//                       checkToShowVerticalLine: (value) {
//                         // Only show the line if the value matches the selected X
//                         // Use a small tolerance for double comparison
//                         const tolerance = 1.0; // Adjust if needed (milliseconds are large)
//                         return _selectedSpotX != null && (value - _selectedSpotX!).abs() < tolerance;
//                       },
//                       // Function to style the vertical lines
//                       getDrawingVerticalLine: (value) {
//                         return const FlLine(
//                           color: Colors.blueAccent, // Line color
//                           strokeWidth: 1,       // Line thickness
//                           dashArray: [4, 4],    // Dashed pattern [dash, gap]
//                         );
//                       },
//                       // Optional: Style horizontal lines if shown
//                       // getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey, strokeWidth: 0.5),
//                       // horizontalInterval: leftInterval, // Match left titles interval
//                       // verticalInterval: // Usually not needed when checkToShowVerticalLine is used
//                     ),
//
//                     // ----- Titles (Axis Labels) -----
//                     titlesData: FlTitlesData(
//                       show: true,
//                       // --- HIDE Bottom (X Axis) ---
//                       bottomTitles: const AxisTitles(
//                         sideTitles: SideTitles(showTitles: false), // Set showTitles to false
//                       ),
//                       // --- Left (Y Axis - Revenue) ---
//                       leftTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           reservedSize: 40, // Adjust space as needed
//                           getTitlesWidget: leftTitleWidgets,
//                           interval: leftInterval,
//                         ),
//                       ),
//                       // --- Hide Top and Right Titles ---
//                       topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                       rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     ),
//
//                     // ----- Border -----
//                     borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300, width: 1)),
//
//                     // ----- Line Data -----
//                     lineBarsData: [
//                       LineChartBarData(
//                         spots: revenueData,
//                         isCurved: true,
//                         // Use a gradient for better visual appeal
//                         gradient: const LinearGradient(
//                           colors: [Colors.cyan, Colors.blueAccent],
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                         ),
//                         barWidth: 4,
//                         isStrokeCapRound: true,
//                         dotData: const FlDotData(show: false), // Hide static dots on the line
//                         belowBarData: BarAreaData( // Fill below line
//                           show: true,
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.cyan.withOpacity(0.3),
//                               Colors.blueAccent.withOpacity(0.0)
//                             ],
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                           ),
//                         ),
//                         // Prevent line from going below zero if minY is zero
//                         preventCurveOverShooting: true,
//                         preventCurveOvershootingThreshold: 1, // Small threshold
//                       ),
//                     ],
//
//                     // ----- Touch Interaction -----
//                     lineTouchData: LineTouchData(
//                       // Disable built-in tooltip/line as we use the grid line
//                       handleBuiltInTouches: false,
//                       // Tooltip customization is not needed here anymore
//                       // touchTooltipData: LineTouchTooltipData( ... ),
//
//                       // Custom behavior on touch
//                       touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
//                         // On Tap Down: Clear previous selection immediately for responsiveness
//                         if (event is FlTapDownEvent) {
//                           setState(() {
//                             // Only clear if tapping background or a different spot might be desired
//                             // For now, clear on any tap down, selection happens on tap up
//                             _selectedSpotX = null;
//                             _selectedDateStr = null;
//                           });
//                         }
//                         // On Tap Up: Set the selection or clear if background tapped
//                         else if (event is FlTapUpEvent) {
//                           if (response != null && response.lineBarSpots != null && response.lineBarSpots!.isNotEmpty) {
//                             final spot = response.lineBarSpots![0];
//                             final date = DateFormat('yyyy-MM-dd').format(
//                                 DateTime.fromMillisecondsSinceEpoch(spot.x.toInt()));
//                             final formattedRevenue = NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(spot.y);
//
//                             setState(() {
//                               // Update the selected X for the grid line
//                               _selectedSpotX = spot.x;
//                               // Store formatted date for potential use (e.g., SnackBar)
//                               _selectedDateStr = date;
//                             });
//
//                             // Show SnackBar with Date and Revenue
//                             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text('Ngày: $date, Doanh thu: $formattedRevenue'),
//                                 duration: const Duration(seconds: 3),
//                                 behavior: SnackBarBehavior.floating,
//                                 backgroundColor: Colors.blueAccent, // Match line color
//                               ),
//                             );
//                           } else {
//                             // Tapped on empty space, clear the selection
//                             setState(() {
//                               _selectedSpotX = null;
//                               _selectedDateStr = null;
//                             });
//                           }
//                         }
//                       },
//                       // Customize the dot that appears ON the line when touched
//                       getTouchedSpotIndicator:(barData, spotIndexes) {
//                         return spotIndexes.map((index) {
//                           return TouchedSpotIndicatorData(
//                             // Make the indicator line invisible or very subtle if using grid line
//                             const FlLine(color: Colors.transparent, strokeWidth: 0),
//                             FlDotData(
//                               show: true, // Show the dot on the line
//                               getDotPainter: (spot, percent, barData, index) =>
//                                   FlDotCirclePainter(
//                                     radius: 6, // Make dot prominent
//                                     // Use gradient colors if possible, else fallback
//                                     color: barData.gradient?.colors.last ?? barData.color ?? Colors.blueAccent,
//                                     strokeWidth: 2,
//                                     strokeColor: Colors.white, // White outline for visibility
//                                   ),
//                             ),
//                           );
//                         }).toList();
//                       },
//                       // Increase touch area around points
//                       touchSpotThreshold: 20,
//                     ),
//                   ),
//                   // Optional Animation
//                   // swapAnimationDuration: const Duration(milliseconds: 250),
//                   // swapAnimationCurve: Curves.linear,
//                 )
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


//
// // OKKK2
class AdminRoomRevenueScreen extends StatefulWidget {
  final int roomId; // Although not used in mock service, keep for real implementation
  final String roomName;

  const AdminRoomRevenueScreen({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  @override
  _AdminRoomRevenueScreenState createState() => _AdminRoomRevenueScreenState();
}

class _AdminRoomRevenueScreenState extends State<AdminRoomRevenueScreen> {
  // --- State Variables ---
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  DateTime? _startDate = DateTime.now(); // Default to today
  DateTime? _endDate = DateTime.now();   // Default to today
  RevenueModel? _revenue;

  final RevenueService _revenueService = RevenueService(); // Your actual service instance
  List<FlSpot> revenueData = []; // Data points for the chart
  bool _isLoading = false;       // To show loading indicator
  double _totalRevenueInRange = 0.0; // Total calculated for the selected range

  // State for touch interaction and positioning the info text
  FlSpot? _selectedSpot;        // Store the entire spot (X and Y) when touched
  double? _selectedPositionX;   // Store the calculated horizontal pixel position for the info text
  bool _showSelectedInfo = false; // Control visibility of the info text and vertical line

  // Chart properties needed for calculation (determined during build)
  double _chartMinX = 0;
  double _chartMaxX = 0;
  double _chartWidth = 0; // Will be set by LayoutBuilder

  @override
  void initState() {
    super.initState();
    // Initialize date text fields
    _startDateController.text = DateFormat('yyyy-MM-dd').format(_startDate!);
    _endDateController.text = DateFormat('yyyy-MM-dd').format(_endDate!);
    // Optional: Fetch data for the default date range on initial load
    // WidgetsBinding.instance.addPostFrameCallback((_) => _fetchRevenue());
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  // --- Date Selection ---
  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000), // Allow selection far back
      lastDate: DateTime(2101), // Allow selection into the future
    );
    if (selectedDate != null && selectedDate != _startDate) {
      setState(() {
        _startDate = selectedDate;
        _startDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        // Clear chart selection when date changes
        _clearSelection();
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      // Ensure end date is not before start date if start date is selected
      firstDate: _startDate ?? DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null && selectedDate != _endDate) {
      setState(() {
        _endDate = selectedDate;
        _endDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        // Clear chart selection when date changes
        _clearSelection();
      });
    }
  }

  // --- Data Fetching ---
  Future<void> _fetchRevenue() async {
    // Validate dates
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Vui lòng chọn ngày bắt đầu và kết thúc.')));
      return;
    }
    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ngày kết thúc không được trước ngày bắt đầu.')));
      return;
    }

    setState(() {
      _isLoading = true;
      revenueData = []; // Clear previous data
      _totalRevenueInRange = 0; // Reset total for the range
      _clearSelection(); // Clear any active chart selection
    });

    // Format dates for API (adjust format string if your API differs)
    // Use start of day for startDate and end of day for endDate for inclusive range
    final startDateFormatted = DateFormat("yyyy-MM-dd'T'00:00:00").format(_startDate!);
    // Add 1 day and subtract a microsecond to get the very end of the selected end date
    final endDateAdjusted = _endDate!.add(const Duration(days: 1)).subtract(const Duration(microseconds: 1));
    final endDateFormatted = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(endDateAdjusted);

    try {
      // Call your actual service method
      RevenueModel revenue = await _revenueService.fetchRevenueData(
          startDateFormatted, endDateFormatted);

      _revenue = revenue;

      // Process the returned data
      Map<String, double> revenueByDate = {};
      double currentRangeTotal = 0.0;

      for (var booking in revenue.bookingDetailList) {
        // Extract date part YYYY-MM-DD
        String checkInDate = booking.checkIn.substring(0, 10);
        // Aggregate revenue per day
        revenueByDate[checkInDate] = (revenueByDate[checkInDate] ?? 0) + booking.price;
        // Sum up total for the selected range
        currentRangeTotal += booking.price;
      }

      // Convert map to list of entries and sort by date
      List<MapEntry<String, double>> sortedRevenue = revenueByDate.entries.toList()
        ..sort((a, b) => DateTime.parse(a.key).compareTo(DateTime.parse(b.key)));

      // Convert sorted entries to FlSpot list for the chart
      List<FlSpot> spots = sortedRevenue.map((entry) {
        DateTime parsedDate = DateTime.parse(entry.key);
        // X value is millisecondsSinceEpoch, Y value is revenue
        return FlSpot(parsedDate.millisecondsSinceEpoch.toDouble(), entry.value);
      }).toList();

      // Update state with fetched data
      if (mounted) { // Check if the widget is still in the tree
        setState(() {
          revenueData = spots;
          _totalRevenueInRange = currentRangeTotal;
        });
        if (revenueData.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Không có dữ liệu doanh thu cho khoảng thời gian đã chọn.')));
        }
      }
    } catch (e) {
      // Handle errors
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Lỗi lấy dữ liệu: $e')));
      }
    } finally {
      // Ensure loading indicator is turned off
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --- Chart Helper Functions ---

  // Clears the selected spot info
  void _clearSelection() {
    setState(() {
      _selectedSpot = null;
      _selectedPositionX = null;
      _showSelectedInfo = false;
    });
  }

  // Formats labels for the Left (Y) axis
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 10, // Smaller font size for Y axis
    );
    String text;
    // Don't show labels at the very top or bottom - they often clash
    if (value == meta.max || value == meta.min) {
      return Container();
    }

    // Format large numbers with K (thousands) or M (millions)
    if (value >= 1000000) {
      text = '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      text = '${(value / 1000).toStringAsFixed(0)}k'; // No decimals for K
    } else {
      text = value.toStringAsFixed(0); // Show raw value for smaller numbers
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 6, // Adjust space between axis line and label
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }

  // Calculates the horizontal pixel position for a given data X value
  double? calculatePositionX(
      double dataX, double chartMinX, double chartMaxX, double chartWidth) {
    // Prevent division by zero or calculation with invalid width/range
    if (chartWidth <= 0) return null;
    if (chartMaxX == chartMinX) {
      // If only one point, position it in the middle
      return chartWidth / 2;
    }

    // Calculate the proportion of the data point within the chart's X-axis range
    double proportion = (dataX - chartMinX) / (chartMaxX - chartMinX);
    // Calculate the pixel offset from the left edge
    double position = proportion * chartWidth;

    // Clamp position to be within the chart bounds (optional but good practice)
    // position = position.clamp(0, chartWidth);

    return position;
  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    // --- Calculate Chart Min/Max (needed for chart bounds and positioning) ---
    double? calculatedMinX, calculatedMaxX, minY, maxY;
    double leftInterval = 100; // Default interval for Y axis

    if (revenueData.isNotEmpty) {
      // Find min/max X from the data
      calculatedMinX = revenueData.map((spot) => spot.x).reduce(math.min);
      calculatedMaxX = revenueData.map((spot) => spot.x).reduce(math.max);

      // Add padding to X-axis if there's only one data point for better display
      if (revenueData.length == 1) {
        const oneDayInMillis = 24 * 60 * 60 * 1000;
        calculatedMinX = calculatedMinX! - oneDayInMillis;
        calculatedMaxX = calculatedMaxX! + oneDayInMillis;
      }

      // Y axis always starts at 0 for revenue charts
      minY = 0;
      // Find max Y from data, ensure it's not 0, add padding
      maxY = revenueData.map((spot) => spot.y).reduce(math.max);
      maxY = maxY == 0 ? 100 : maxY * 1.15; // Add 15% padding, default max 100 if all zero

      // Calculate dynamic interval for Y axis labels based on the range
      double rangeY = maxY - minY;
      if (rangeY > 0) {
        leftInterval = (rangeY / 4).ceilToDouble(); // Aim for ~4 labels
        // Round interval to nicer numbers (e.g., 50, 100, 500) - adjust as needed
        if (leftInterval > 1000) leftInterval = (leftInterval / 500).ceil() * 500;
        else if (leftInterval > 100) leftInterval = (leftInterval / 100).ceil() * 100; // Round to 100s
        else if (leftInterval > 10) leftInterval = (leftInterval / 10).ceil() * 10;   // Round to 10s
        else leftInterval = math.max(10, leftInterval); // Minimum interval
      } else {
        leftInterval = math.max(10, maxY / 2); // Handle case with only one value or all zero
      }
      if (leftInterval <= 0) leftInterval = 100; // Fallback interval

    } else {
      // Default values if no data, to prevent errors during initial build
      final now = DateTime.now();
      calculatedMinX = now.subtract(const Duration(days: 1)).millisecondsSinceEpoch.toDouble();
      calculatedMaxX = now.add(const Duration(days: 1)).millisecondsSinceEpoch.toDouble();
      minY = 0;
      maxY = 100; // Default max Y if no data
    }
    // Store these calculated values for use in positioning later
    _chartMinX = calculatedMinX!;
    _chartMaxX = calculatedMaxX!;
    // Note: _chartWidth is determined by LayoutBuilder below

    return Scaffold(

      appBar: AppBar(
        title: Text('Doanh thu: ${widget.roomName}'),
        backgroundColor: Color(0xFF65462D),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),


      body: Padding(
        // Add padding, leave space at top for positioned text
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Date Selection Row ---
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startDateController,
                    readOnly: true, // Prevent manual editing
                    decoration: InputDecoration(
                      labelText: 'Bắt đầu',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today, size: 20),
                        onPressed: () => _selectStartDate(context),
                        tooltip: 'Chọn ngày bắt đầu',
                      ),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _endDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Kết thúc',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today, size: 20),
                        onPressed: () => _selectEndDate(context),
                        tooltip: 'Chọn ngày kết thúc',
                      ),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- Fetch Button ---
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _fetchRevenue,
              icon: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.bar_chart_rounded, color: Colors.white),
              label: const Text('Xem Doanh Thu'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Color(0xFF65462D),
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // --- Total Revenue Display ---
            Center(
              child: Text(
                'Tổng doanh thu: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(_totalRevenueInRange)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),



            // --- Chart Area (Fixed Height) ---
            SizedBox( // << FIXED HEIGHT CONTAINER for the chart area
              height: 200.0,
              child: _isLoading && revenueData.isEmpty
                  ? const Center(child: CircularProgressIndicator()) // Show loading only if no data is present yet
                  : revenueData.isEmpty && !_isLoading // Show message if no data after loading
                  ? const Center(child: Text( 'Không có dữ liệu để hiển thị.', style: TextStyle(fontSize: 16, color: Colors.grey)))
                  : LayoutBuilder( // Use LayoutBuilder to get the available width
                builder: (context, constraints) {
                  _chartWidth = constraints.maxWidth; // Store the actual width
                  if (_chartWidth <= 0) return const SizedBox.shrink(); // Avoid errors if width is invalid

                  // Stack allows layering the chart and the positioned info text
                  return Stack(
                    clipBehavior: Clip.none, // IMPORTANT: Allows text to draw outside the Stack bounds
                    children: [
                      // --- The Actual Line Chart ---
                      LineChart(
                        LineChartData(
                          // Use calculated min/max values for chart axes
                          minX: _chartMinX,
                          maxX: _chartMaxX,
                          minY: minY,
                          maxY: maxY,

                          // ----- Grid Data (Controls the vertical dashed line) -----
                          gridData: FlGridData(
                            show: true, // Enable grid lines
                            drawHorizontalLine: false, // Hide horizontal grid lines
                            drawVerticalLine: true, // Enable vertical grid lines (conditionally)
                            // Function to decide IF a vertical line should be drawn at a given X value
                            checkToShowVerticalLine: (value) {
                              const tolerance = 1.0; // Tolerance for double comparison (milliseconds)
                              // Show line ONLY if a spot is selected and its X matches the current value
                              return _showSelectedInfo && _selectedSpot != null &&
                                  (value - _selectedSpot!.x).abs() < tolerance;
                            },
                            // Function to define the style of the vertical line
                            getDrawingVerticalLine: (value) {
                              return const FlLine(
                                color: Colors.redAccent, // Match info text color
                                strokeWidth: 1,       // Line thickness
                                dashArray: [4, 4],    // Dashed pattern: 4 pixels drawn, 4 pixels gap
                              );
                            },
                          ),

                          // ----- Titles Data (Axis Labels) -----
                          titlesData: FlTitlesData(
                            show: true, // Show title areas
                            // Bottom (X) Axis Titles: Hidden
                            bottomTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            // Left (Y) Axis Titles: Shown with custom formatting
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 35, // Adjust space for labels
                                getTitlesWidget: leftTitleWidgets, // Use helper function
                                interval: leftInterval, // Use calculated interval
                              ),
                            ),
                            // Top and Right Axis Titles: Hidden
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),

                          // ----- Border Data -----
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.grey.shade300, width: 1), // Subtle border
                          ),

                          // ----- Line Bar Data (The actual line on the chart) -----
                          lineBarsData: [
                            LineChartBarData(
                              spots: revenueData, // The data points
                              isCurved: true, // Smooth curves
                              // Apply a gradient color to the line
                              gradient: const LinearGradient(
                                colors: [Colors.cyanAccent, Colors.blueAccent],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              barWidth: 3, // Line thickness
                              isStrokeCapRound: true, // Rounded line ends
                              dotData: const FlDotData(show: false), // Hide the small static dots along the line
                              // Area below the line with a gradient fill
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.cyanAccent.withOpacity(0.3),
                                    Colors.blueAccent.withOpacity(0.0) // Fade to transparent
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              // Prevent the curve from dipping below zero if minY is zero
                              preventCurveOverShooting: true,
                            ),
                          ],

                          // ----- Touch Interaction Data -----
                          lineTouchData: LineTouchData(
                            // IMPORTANT: Disable built-in tooltips and indicators
                            // We are handling the indicator (dashed line + text) manually
                            handleBuiltInTouches: false,
                            // Callback function when a touch event occurs on the chart
                            touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                              // Handle Tap Up event (finger lifted)
                              if (event is FlTapUpEvent) {
                                // Check if the tap hit a spot on the line
                                if (response != null && response.lineBarSpots != null &&
                                    response.lineBarSpots!.isNotEmpty && _chartWidth > 0)
                                {
                                  // Get the specific spot that was touched
                                  final spot = response.lineBarSpots![0];
                                  // Calculate the horizontal pixel position of the tapped spot
                                  final positionX = calculatePositionX(spot.x, _chartMinX, _chartMaxX, _chartWidth);

                                  // Update state to show the info text and vertical line
                                  setState(() {
                                    _selectedSpot = spot;
                                    _selectedPositionX = positionX;
                                    // Show info only if position calculation was successful
                                    _showSelectedInfo = positionX != null;
                                  });
                                } else {
                                  // Tap occurred on the background, not on a line spot
                                  // Clear the selection
                                  _clearSelection();
                                }
                              }
                              // Optional: Handle tap down to immediately clear selection (feels more responsive)
                              // else if (event is FlTapDownEvent) {
                              //   if (_showSelectedInfo) { // Only clear if something *is* selected
                              //     _clearSelection();
                              //   }
                              // }
                            },
                            // Customize the indicator (dot) that appears ON the line when touched
                            getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                              return spotIndexes.map((index) {
                                return TouchedSpotIndicatorData(
                                  // We don't need the default horizontal line indicator
                                  const FlLine(color: Colors.transparent),
                                  // Define the dot style when touched
                                  FlDotData(
                                    show: true, // Show the dot
                                    getDotPainter: (spot, percent, bar, index) =>
                                        FlDotCirclePainter(
                                          radius: 6, // Size of the dot
                                          color: Colors.redAccent, // Match line/text color
                                          strokeWidth: 2, // Border thickness
                                          strokeColor: Colors.white, // White border for contrast
                                        ),
                                  ),
                                );
                              }).toList();
                            },
                            touchSpotThreshold: 20, // Larger touch area around points
                          ),
                        ),
                        // Optional: Add animation when data changes
                        // swapAnimationDuration: const Duration(milliseconds: 250),
                        // swapAnimationCurve: Curves.linear,
                      ),

                      // --- Positioned Info Text (Displayed Above Chart) ---
                      // This widget is layered on top of the chart using the Stack
                      // It only builds when _showSelectedInfo is true and position is calculated
                      if (_showSelectedInfo && _selectedPositionX != null && _selectedSpot != null)
                        Positioned(
                          // Horizontal position calculated based on touch point
                          left: _selectedPositionX,
                          // Vertical position: Negative value places it ABOVE the Stack's top edge
                          top: -30, // Adjust this value for desired vertical distance from chart
                          // Use FractionalTranslation to center the text box horizontally
                          // It shifts the widget by a fraction of its own size.
                          // Offset(-0.5, 0.0) shifts it left by 50% of its width.
                          child: FractionalTranslation(
                            translation: const Offset(-0.5, 0.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                // Optional background for better readability if needed
                                // color: Colors.black.withOpacity(0.7),
                                // borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                // Display Date (dd/MM/yy) on first line
                                // Display Revenue (formatted currency) on second line
                                '${DateFormat('dd/MM/yy').format(DateTime.fromMillisecondsSinceEpoch(_selectedSpot!.x.toInt()))}\n${NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(_selectedSpot!.y)}',
                                textAlign: TextAlign.center, // Center the text lines
                                style: const TextStyle(
                                  color: Colors.redAccent, // Match line/dot color
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  height: 1.2, // Adjust line spacing if needed
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            // Add some space at the bottom if needed, or let the Column handle it
            const SizedBox(height: 20),



            // ElevatedButton(
            //   onPressed: () {
            //     // Điều hướng đến trang BookingPage với tham số ngày bắt đầu và kết thúc
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => BookingPage(
            //           startDate: _startDateController.text,
            //           endDate: _endDateController.text,
            //         ),
            //       ),
            //     );
            //   },
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(vertical: 12),
            //   ),
            //   child: const Text('Xem danh sách đặt phòng'),
            // ),

            ElevatedButton(
              onPressed: () {
                // Điều hướng đến trang BookingPage với danh sách các booking
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingPage(
                      bookingDetails: _revenue!.bookingDetailList, // Use _revenue
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Xem danh sách đặt phòng'),
            ),





          ],
        ),
      ),
    );
  }
}

