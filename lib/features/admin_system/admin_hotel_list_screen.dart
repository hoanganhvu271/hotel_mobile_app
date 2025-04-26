import 'package:flutter/material.dart';
import 'package:hotel_app/features/admin_system/admin_room_list.dart';
import 'package:hotel_app/features/admin_system/model/hotel_owner_list.dart';
import 'package:hotel_app/features/admin_system/services/hotel_owner_service.dart';
import 'package:hotel_app/common/widgets/heading.dart';

//
//
//
// class HotelListScreen extends StatefulWidget {
//   final int userId;
//
//   const HotelListScreen({Key? key, required this.userId}) : super(key: key);
//
//   @override
//   _HotelListScreenState createState() => _HotelListScreenState();
// }
//
// class _HotelListScreenState extends State<HotelListScreen> {
//   late Future<List<Hotel>> hotels;
//   List<Hotel> filteredHotels = [];
//   String searchQuery = "";
//
//   @override
//   void initState() {
//     super.initState();
//     hotels = HotelService().fetchHotelsByUserId(widget.userId);
//   }
//
//   void filterHotels(List<Hotel> allHotels, String query) {
//     setState(() {
//       searchQuery = query;
//       filteredHotels = allHotels.where((hotel) {
//         return hotel.hotelId.toString().contains(query) ||
//             hotel.hotelName.toLowerCase().contains(query.toLowerCase()) ||
//             hotel.address.city.toLowerCase().contains(query.toLowerCase()) ||
//             hotel.address.district.toLowerCase().contains(query.toLowerCase()) ||
//             hotel.address.ward.toLowerCase().contains(query.toLowerCase()) ||
//             hotel.address.specificAddress.toLowerCase().contains(query.toLowerCase());
//       }).toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Stack(
//             children: [
//               const Heading(title: 'QUẢN LÝ KHÁCH SẠN'),
//               Positioned(
//                 left: 20,
//                 top: 22,
//                 child: IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: 'Tìm kiếm theo tên, ID, thành phố, quận, phường...',
//                 labelStyle: TextStyle(color: Colors.brown),
//                 prefixIcon: Icon(Icons.search, color: Colors.brown),
//                 fillColor: Colors.white,
//                 filled: true,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.brown, width: 1),
//                 ),
//               ),
//               onChanged: (value) {
//                 hotels.then((allHotels) {
//                   filterHotels(allHotels, value);
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Hotel>>(
//               future: hotels,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('Không có khách sạn nào'));
//                 } else {
//                   final allHotels = snapshot.data!;
//                   final displayHotels = searchQuery.isEmpty ? allHotels : filteredHotels;
//
//                   return ListView.builder(
//                     itemCount: displayHotels.length,
//                     itemBuilder: (context, index) {
//                       final hotel = displayHotels[index];
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                         child: ListTile(
//
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => RoomListScreen(hotelId: hotel.hotelId),
//                               ),
//                             );
//                           },
//
//                           title: Text(hotel.hotelName),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('ID: ${hotel.hotelId}'),
//                               Text('Thành phố: ${hotel.address.city}'),
//                               Text('Quận: ${hotel.address.district}'),
//                               Text('Phường: ${hotel.address.ward}'),
//                               Text('Địa chỉ cụ thể: ${hotel.address.specificAddress}'),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//
// // // --- The Main Screen Widget ---
// class HotelListScreen extends StatefulWidget {
//   final int userId; // The ID of the owner whose hotels we are listing
//
//   const HotelListScreen({Key? key, required this.userId}) : super(key: key);
//
//   @override
//   _HotelListScreenState createState() => _HotelListScreenState();
// }
//
// class _HotelListScreenState extends State<HotelListScreen> {
//   // State Variables
//   Future<List<Hotel>>? _hotelsFuture; // Nullable Future to avoid LateInitializationError
//   final HotelService _hotelService = HotelService();
//   List<Hotel> _allHotels = [];       // Store the complete list fetched
//   List<Hotel> _filteredHotels = [];  // Store the list filtered by search
//   final TextEditingController _searchController = TextEditingController();
//
//   // Define the desired brown color (as used in the search bar)
//   static const Color _brownColor = Colors.brown;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchAndSetHotels(); // Fetch data when the screen initializes
//   }
//
//   // Fetch hotels and update state variables
//   void _fetchAndSetHotels() {
//     // Assign the future immediately
//     _hotelsFuture = _hotelService.fetchHotelsByUserId(widget.userId);
//
//     // Use .then() to process the data *after* the future completes
//     _hotelsFuture!.then((hotels) {
//       if (mounted) { // Check if the widget is still in the tree
//         setState(() {
//           _allHotels = hotels;
//           // Apply current filter (if any) to the newly fetched data
//           _filterHotels(_searchController.text);
//         });
//       }
//     }).catchError((error) {
//       // Handle potential errors during fetching
//       if (mounted) {
//         print("Error fetching hotels for user ${widget.userId}: $error");
//         // Setting state here will cause FutureBuilder to show the error state
//         setState(() {});
//       }
//     });
//     // Optionally call setState here to immediately show loading in FutureBuilder
//     // if(_hotelsFuture != null) setState(() {});
//   }
//
//   // Filter the list of hotels based on the search query
//   void _filterHotels(String query) {
//     final lowerCaseQuery = query.toLowerCase();
//     List<Hotel> newlyFiltered;
//
//     if (query.isEmpty) {
//       newlyFiltered = _allHotels; // Show all if query is empty
//     } else {
//       newlyFiltered = _allHotels.where((hotel) {
//         // Check multiple fields for the query
//         return hotel.hotelId.toString().contains(lowerCaseQuery) ||
//             hotel.hotelName.toLowerCase().contains(lowerCaseQuery) ||
//             hotel.address.city.toLowerCase().contains(lowerCaseQuery) ||
//             hotel.address.district.toLowerCase().contains(lowerCaseQuery) ||
//             hotel.address.ward.toLowerCase().contains(lowerCaseQuery) ||
//             hotel.address.specificAddress.toLowerCase().contains(lowerCaseQuery);
//       }).toList();
//     }
//
//     // Only call setState if the filtered list has actually changed
//     if (!listEquals(_filteredHotels, newlyFiltered)) {
//       if(mounted){
//         setState(() {
//           _filteredHotels = newlyFiltered;
//         });
//       }
//     } else if (_filteredHotels.isEmpty && newlyFiltered.isEmpty && query.isNotEmpty && _searchController.text.isNotEmpty) {
//       // Force rebuild if search active and results are empty (for "No results" message)
//       if(mounted){
//         setState(() {});
//       }
//     }
//   }
//   // Helper function for list equality check
//   bool listEquals<T>(List<T>? a, List<T>? b) {
//     if (a == null) return b == null;
//     if (b == null || a.length != b.length) return false;
//     if (identical(a, b)) return true;
//     for (int index = 0; index < a.length; index += 1) {
//       if (a[index] != b[index]) return false;
//     }
//     return true;
//   }
//
//
//   @override
//   void dispose() {
//     _searchController.dispose(); // Clean up the controller
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final textTheme = theme.textTheme;
//
//     // --- Assume Heading background is this color, adjust if different ---
//     final appBarColor = Colors.blueGrey; // <<< ADJUST THIS to match Heading
//
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         titleSpacing: 0,
//         backgroundColor: appBarColor,
//         elevation: 2,
//         title: Stack(
//           alignment: Alignment.center,
//           children: [
//             // Your custom Heading widget
//             const Heading(title: 'DANH SÁCH KHÁCH SẠN'), // Updated title
//
//             // Positioned Back Button
//             Positioned(
//               left: 0, top: 0, bottom: 0,
//               child: IconButton(
//                 icon: const Icon(Icons.arrow_back, color: Colors.white),
//                 tooltip: 'Quay lại',
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ),
//           ],
//         ),
//         // toolbarHeight: 70, // Adjust if needed
//       ),
//       body: Column(
//         children: [
//           // --- Search Bar ---
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _searchController,
//               style: const TextStyle(color: _brownColor),
//               decoration: InputDecoration(
//                 hintText: 'Tìm kiếm tên, ID, thành phố, quận...',
//                 hintStyle: TextStyle(color: _brownColor.withOpacity(0.7)),
//                 prefixIcon: const Icon(Icons.search, color: _brownColor),
//                 suffixIcon: _searchController.text.isNotEmpty
//                     ? IconButton(
//                   icon: Icon(Icons.clear, color: _brownColor.withOpacity(0.8)),
//                   tooltip: 'Xóa tìm kiếm',
//                   onPressed: () {
//                     _searchController.clear();
//                     _filterHotels('');
//                   },
//                 )
//                     : null,
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: _brownColor, width: 1),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: _brownColor, width: 1.5),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
//               ),
//               onChanged: _filterHotels,
//             ),
//           ),
//
//           // --- Hotel List ---
//           Expanded(
//             child: FutureBuilder<List<Hotel>>(
//               future: _hotelsFuture, // Use the nullable future
//               builder: (context, snapshot) {
//                 // --- Loading State ---
//                 if (snapshot.connectionState == ConnectionState.waiting || (snapshot.connectionState == ConnectionState.none && _hotelsFuture != null)) {
//                   if (_allHotels.isEmpty){ // Show loading only if data hasn't loaded at all yet
//                     return const Center(child: CircularProgressIndicator(color: _brownColor));
//                   }
//                   // Otherwise, show stale data while loading new data in background
//                 }
//
//                 // --- Error State ---
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Icon(Icons.error_outline, color: Colors.red, size: 40),
//                           const SizedBox(height: 10),
//                           Text('Lỗi tải danh sách khách sạn: ${snapshot.error}', textAlign: TextAlign.center),
//                           const SizedBox(height: 10),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(backgroundColor: _brownColor),
//                             onPressed: _fetchAndSetHotels, // Retry button
//                             child: const Text('Thử lại', style: TextStyle(color: Colors.white)),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 }
//
//                 // --- Empty / No Results State ---
//                 if (_filteredHotels.isEmpty) {
//                   return Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
//                             const SizedBox(height: 12),
//                             Text(
//                               _searchController.text.isEmpty
//                                   ? 'Người dùng này chưa có khách sạn nào.' // List truly empty
//                                   : 'Không tìm thấy khách sạn khớp.',    // Search yielded no results
//                               style: textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
//                               textAlign: TextAlign.center,
//                             ),
//                           ]
//                       ),
//                     ),
//                   );
//                 }
//
//                 // --- Data Loaded State ---
//                 return ListView.separated(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                   itemCount: _filteredHotels.length,
//                   separatorBuilder: (context, index) => const SizedBox(height: 12),
//                   itemBuilder: (context, index) {
//                     final hotel = _filteredHotels[index];
//                     return Card(
//                       margin: EdgeInsets.zero,
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       clipBehavior: Clip.antiAlias,
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               // Navigate to the RoomListScreen for this hotel
//                               builder: (_) => RoomListScreen(hotelId: hotel.hotelId),
//                             ),
//                           );
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start, // Align top
//                             children: [
//                               // Leading Icon
//                               CircleAvatar(
//                                 backgroundColor: _brownColor.withOpacity(0.1),
//                                 foregroundColor: _brownColor,
//                                 child: const Icon(Icons.business_rounded), // Hotel/Business icon
//                               ),
//                               const SizedBox(width: 16),
//                               // Hotel Details Column
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       hotel.hotelName,
//                                       style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//                                       maxLines: 2, // Allow hotel name to wrap
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       'ID: ${hotel.hotelId}',
//                                       style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     // Address Details with Icon
//                                     Row(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
//                                         const SizedBox(width: 6),
//                                         Expanded(
//                                           child: Text(
//                                             hotel.address.specificAddress, // Use formatted full address
//                                             style: textTheme.bodyMedium,
//                                             maxLines: 3, // Allow address to wrap
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               // Trailing Chevron
//                               const SizedBox(width: 8),
//                               const Icon(Icons.chevron_right, color: Colors.grey),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


//
//
// import 'package:flutter/material.dart';
// import 'package:hotel_app/features/admin_system/admin_room_list.dart';
// import 'package:hotel_app/features/admin_system/model/hotel_owner_list.dart';
// import 'package:hotel_app/features/admin_system/services/hotel_owner_service.dart';
// import 'package:hotel_app/common/widgets/heading.dart';
// import 'package:flutter/material.dart';
// import 'package:hotel_app/features/admin_system/admin_room_list.dart';
// import 'package:hotel_app/features/admin_system/model/hotel_owner_list.dart';
// import 'package:hotel_app/features/admin_system/services/hotel_owner_service.dart';
// import 'package:hotel_app/common/widgets/heading.dart';
//
// class HotelListScreen extends StatefulWidget {
//   final int userId;
//
//   const HotelListScreen({Key? key, required this.userId}) : super(key: key);
//
//   @override
//   _HotelListScreenState createState() => _HotelListScreenState();
// }
//
// class _HotelListScreenState extends State<HotelListScreen> {
//   Future<List<Hotel>>? hotels;
//   List<Hotel> filteredHotels = [];
//   String searchQuery = "";
//
//   @override
//   void initState() {
//     super.initState();
//     hotels = HotelService().fetchHotelsByUserId(widget.userId);
//   }
//
//   void filterHotels(List<Hotel> allHotels, String query) {
//     setState(() {
//       searchQuery = query;
//       filteredHotels = allHotels.where((hotel) {
//         return hotel.hotelId.toString().contains(query) ||
//             hotel.hotelName.toLowerCase().contains(query.toLowerCase()) ||
//             hotel.address.city.toLowerCase().contains(query.toLowerCase()) ||
//             hotel.address.district.toLowerCase().contains(query.toLowerCase()) ||
//             hotel.address.ward.toLowerCase().contains(query.toLowerCase()) ||
//             hotel.address.specificAddress.toLowerCase().contains(query.toLowerCase());
//       }).toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Stack(
//             children: [
//               const Heading(title: 'QUẢN LÝ KHÁCH SẠN'),
//               Positioned(
//                 left: 20,
//                 top: 22,
//                 child: IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: 'Tìm kiếm theo tên, ID, thành phố, quận, phường...',
//                 prefixIcon: const Icon(Icons.search, color: Colors.brown),
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Colors.brown),
//                 ),
//               ),
//               onChanged: (value) {
//                 hotels?.then((allHotels) {
//                   filterHotels(allHotels, value);
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: hotels == null
//                 ? const Center(child: CircularProgressIndicator())
//                 : FutureBuilder<List<Hotel>>(
//               future: hotels,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Lỗi: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('Không có khách sạn nào'));
//                 } else {
//                   final allHotels = snapshot.data!;
//                   final displayHotels = searchQuery.isEmpty ? allHotels : filteredHotels;
//
//                   return ListView.builder(
//                     itemCount: displayHotels.length,
//                     itemBuilder: (context, index) {
//                       final hotel = displayHotels[index];
//                       return Card(
//                         elevation: 3,
//                         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.all(12),
//                           leading: const Icon(Icons.business_rounded, color: Colors.brown, size: 40),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => RoomListScreen(hotelId: hotel.hotelId),
//                               ),
//                             );
//                           },
//                           title: Text(
//                             hotel.hotelName,
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const SizedBox(height: 4),
//                               Text('ID: ${hotel.hotelId}'),
//                               Text('TP: ${hotel.address.city}, Q: ${hotel.address.district}, P: ${hotel.address.ward}'),
//                               Text('Địa chỉ: ${hotel.address.specificAddress}'),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'package:hotel_app/features/admin_system/widgets/hotel_card.dart';

class HotelListScreen extends StatefulWidget {
  final int userId;

  const HotelListScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _HotelListScreenState createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  Future<List<Hotel>>? hotels;
  List<Hotel> filteredHotels = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    hotels = HotelService().fetchHotelsByUserId(widget.userId);
  }

  void filterHotels(List<Hotel> allHotels, String query) {
    setState(() {
      searchQuery = query;
      filteredHotels = allHotels.where((hotel) {
        return hotel.hotelId.toString().contains(query) ||
            hotel.hotelName.toLowerCase().contains(query.toLowerCase()) ||
            hotel.address.city.toLowerCase().contains(query.toLowerCase()) ||
            hotel.address.district.toLowerCase().contains(query.toLowerCase()) ||
            hotel.address.ward.toLowerCase().contains(query.toLowerCase()) ||
            hotel.address.specificAddress.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              const Heading(title: 'QUẢN LÝ KHÁCH SẠN'),
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
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo tên, ID, thành phố, quận, phường...',
                prefixIcon: const Icon(Icons.search, color: Colors.brown),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.brown),
                ),
              ),
              onChanged: (value) {
                hotels?.then((allHotels) {
                  filterHotels(allHotels, value);
                });
              },
            ),
          ),
          Expanded(
            child: hotels == null
                ? const Center(child: CircularProgressIndicator())
                : FutureBuilder<List<Hotel>>(
              future: hotels,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có khách sạn nào'));
                } else {
                  final allHotels = snapshot.data!;
                  final displayHotels = searchQuery.isEmpty ? allHotels : filteredHotels;

                  return ListView.builder(
                    itemCount: displayHotels.length,
                    itemBuilder: (context, index) {
                      return HotelCard(hotel: displayHotels[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
