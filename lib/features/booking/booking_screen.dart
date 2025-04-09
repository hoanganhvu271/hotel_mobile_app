// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hotel_app/features/booking/services/city_service.dart';
// import 'package:hotel_app/features/booking/services/district_service.dart';
// import '../../common/widgets/api_dropdown.dart';
// import '../../common/widgets/api_input_field.dart';
// import '../../common/widgets/booking_search.dart';
// import '../../common/widgets/date_time_picker.dart';
// import '../../common/widgets/heading.dart';
// import '../../common/widgets/home_booking_btn.dart';
// import '../../common/widgets/range_input_field.dart';
// import '../../common/widgets/service_checkbox_list.dart';
// import '../../common/widgets/static_dropdown.dart';
// import 'package:hotel_app/common/widgets/keep_alive_component.dart';
// import 'package:hotel_app/features/main/presentation/ui/bottom_bar_navigation.dart';
//
// class BookingScreen extends StatelessWidget {
//   const BookingScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             /// Phần header cố định
//             Transform.translate(
//               offset: const Offset(0, -25),
//               child: Stack(
//                 children: [
//                   const Heading(title: 'ĐẶT PHÒNG'),
//                   Positioned(
//                     left: 20,
//                     top: 22,
//                     child: IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Colors.white),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//
//             /// Phần nội dung scroll được
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.only(bottom: 80),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // const SizedBox(height: 15),
//                     Searchframetotal(),
//                     const SizedBox(height: 15),
//                     ApiDropdown(
//                       label: 'Thành phố',
//                       fetchData: fetchCities,
//                       onChanged: (value) {
//                         print('Selected city: $value');
//                       },
//                     ),
//                     ApiDropdown(
//                       label: 'Khu vực',
//                       fetchData: fetchDistricts,
//                       onChanged: (value) {
//                         print('Selected district: $value');
//                       },
//                     ),
//                     DateTimePickerDropdown(
//                       label: "Nhận phòng",
//                       onChanged: (date, time) {
//                         print({"date": date, "time": time});
//                       },
//                     ),
//                     DateTimePickerDropdown(
//                       label: "Trả phòng",
//                       onChanged: (date, time) {
//                         print({"date": date, "time": time});
//                       },
//                     ),
//                     ApiInputField(
//                       label: 'Người lớn',
//                       initialValue: '2',
//                       onChanged: (value) {
//                         print('Giá trị mới: $value');
//                       },
//                     ),
//                     ApiInputField(
//                       label: 'Trẻ em',
//                       initialValue: '0',
//                       onChanged: (value) {
//                         print('Giá trị mới: $value');
//                       },
//                     ),
//                     ApiInputField(
//                       label: 'Giường',
//                       initialValue: '1',
//                       onChanged: (value) {
//                         print('Giá trị mới: $value');
//                       },
//                     ),
//                     RangeInputField(
//                       label: 'Khoảng giá',
//                       initialFrom: '0',
//                       initialTo: '',
//                       onChanged: (from, to) {
//                         print('Từ: $from - Đến: $to');
//                       },
//                     ),
//                     StaticDropdown(
//                       label: 'Sắp xếp',
//                       initialValue: 'rating_desc',
//                       onChanged: (value) {
//                         print('Đã chọn: $value');
//                       },
//                     ),
//                     const SizedBox(height: 15),
//                     ServiceCheckboxList(),
//
//                     BookingBtn(
//                       label: 'TÌM PHÒNG TRỐNG',
//                       screen: const BookingScreen(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const KeepAliveComponent(child: BottomBarNavigation()),
//     );
//   }
// }

// features/booking/booking_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'model/booking_search_request.dart';
import 'services/city_service.dart';
import 'services/district_service.dart';
import '../../common/widgets/api_dropdown.dart';
import '../../common/widgets/api_input_field.dart';
import '../../common/widgets/booking_search.dart';
import '../../common/widgets/date_time_picker.dart';
import '../../common/widgets/heading.dart';
import '../../common/widgets/home_booking_btn.dart';
import '../../common/widgets/range_input_field.dart';
import '../../common/widgets/service_checkbox_list.dart';
import '../../common/widgets/static_dropdown.dart';
import 'package:hotel_app/common/widgets/keep_alive_component.dart';
import 'package:hotel_app/features/main/presentation/ui/bottom_bar_navigation.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final BookingSearchRequest _searchModel = BookingSearchRequest(
    infoSearch: '',
    city: '',
    district: '',
    checkInDate: '',
    checkOutDate: '',
    checkInTime: '',
    checkOutTime: '',
    adults: 2,
    children: 0,
    bedNumber: 1,
    priceFrom: 0,
    priceTo: 30000000,
    sortBy: 'rating_desc',
    services: [],
  );

  Future<void> submitBookingSearch() async {
    final url = Uri.parse('http://172.28.160.1:8080/api/booking/search');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(_searchModel.toJson()),
    );

    if (response.statusCode == 200) {
      print("Thành công: ${response.body}");
      // Chuyển đến màn hình kết quả nếu cần
    } else {
      print("Lỗi khi gửi yêu cầu: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Transform.translate(
              offset: const Offset(0, -25),
              child: Stack(
                children: [
                  const Heading(title: 'ĐẶT PHÒNG'),
                  Positioned(
                    left: 20,
                    top: 22,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Searchframetotal(
                    //   onChanged: (val) => _searchModel.infoSearch = val,
                    // ),
                    SearchFrameTotal(
                      onChanged: (val) => _searchModel.infoSearch = val,
                      onTapSearch: () async {
                        await submitBookingSearch();
                      },
                    ),

                    const SizedBox(height: 15),
                    ApiDropdown(
                      label: 'Thành phố',
                      fetchData: fetchCities,
                      onChanged: (value) => _searchModel.city = value,
                    ),

                    ApiDropdown(
                      label: 'Khu vực',
                      fetchData: fetchDistricts,
                      onChanged: (value) => _searchModel.district = value,
                    ),
                    // DateTimePickerDropdown(
                    //   label: "Nhận phòng",
                    //   onChanged: (date, time) {
                    //     _searchModel.checkInDate = date;
                    //     _searchModel.checkInTime = time;
                    //   },
                    // ),
                    // DateTimePickerDropdown(
                    //   label: "Trả phòng",
                    //   onChanged: (date, time) {
                    //     _searchModel.checkOutDate = date;
                    //     _searchModel.checkOutTime = time;
                    //   },
                    // ),
                    //

                    DateTimePickerDropdown(
                        label: "Nhận phòng",
                        initialDateTime: DateTime(now.year, now.month, now.day, 14, 0),
                        onChanged: (date, time) {
                          _searchModel.checkInDate = date;
                          _searchModel.checkInTime = time;
                        },
                    ),
                    DateTimePickerDropdown(
                        label: "Trả phòng",
                        initialDateTime: DateTime(now.year, now.month, now.day + 1, 11, 0),
                        onChanged: (date, time) {
                          _searchModel.checkOutDate = date;
                          _searchModel.checkOutTime = time;
                        },
                    ),



                    ApiInputField(
                      label: 'Người lớn',
                      initialValue: '2',
                      onChanged: (value) =>
                      _searchModel.adults = int.tryParse(value) ?? 2,
                    ),
                    ApiInputField(
                      label: 'Trẻ em',
                      initialValue: '0',
                      onChanged: (value) =>
                      _searchModel.children = int.tryParse(value) ?? 0,
                    ),
                    ApiInputField(
                      label: 'Giường',
                      initialValue: '1',
                      onChanged: (value) =>
                      _searchModel.bedNumber = int.tryParse(value) ?? 1,
                    ),
                    RangeInputField(
                      label: 'Khoảng giá',
                      initialFrom: '0',
                      initialTo: '30000000',
                      onChanged: (from, to) {
                        _searchModel.priceFrom = double.tryParse(from) ?? 0;
                        _searchModel.priceTo = double.tryParse(to) ?? 30000000;
                      },
                    ),
                    StaticDropdown(
                      label: 'Sắp xếp',
                      initialValue: 'rating_asc',
                      onChanged: (value) => _searchModel.sortBy = value,
                    ),
                    const SizedBox(height: 15),
                    // ServiceCheckboxList(
                    //   onChanged: (selected) =>
                    //   _searchModel.services = selected,
                    // ),
                    ServiceCheckboxList(
                      onChanged: (selected) => _searchModel.services = selected.map((e) => e.toString()).toList(),
                    ),
                    const SizedBox(height: 20),
                    // BookingBtn(
                    //   label: 'TÌM PHÒNG TRỐNG',
                    //   screen: const SizedBox.shrink(), // placeholder
                    //   onTap: () async {
                    //     await submitBookingSearch();
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const KeepAliveComponent(child: BottomBarNavigation()),
    );
  }
}
