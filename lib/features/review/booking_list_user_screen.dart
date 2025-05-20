import 'package:flutter/material.dart';
import 'package:hotel_app/common/local/shared_prefs/get_user_login.dart';
import 'package:hotel_app/common/widgets/heading.dart';
import 'package:hotel_app/features/review/model/booking_with_room_info.dart';
import 'package:hotel_app/features/review/model/review_response_dto.dart';
import 'package:hotel_app/features/review/service/fetch_bookings_with_room_details.dart';
import 'package:hotel_app/features/review/service/get_reviews.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../common/utils/api_constants.dart';

enum SortOption {
  createdAtDesc,
  createdAtAsc,
  checkInDesc,
  checkInAsc,
}

class BookingListUserScreen extends StatefulWidget {
  const BookingListUserScreen({super.key});

  @override
  _BookingListUserScreenState createState() => _BookingListUserScreenState();
}

class _BookingListUserScreenState extends State<BookingListUserScreen> {
  Future<List<BookingWithRoomInfo>>? _bookingsFuture;
  List<BookingWithRoomInfo> _allBookings = [];
  List<BookingWithRoomInfo> _displayedBookings = [];


  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  SortOption _selectedSortOption = SortOption.createdAtDesc;

  static const Color _primaryColor = Color(0xFF65462D);
  static const Color _accentColor = Color(0xFFA68367);
  static const Color _lightTextColor = Colors.black54;
  static const Color _errorColor = Colors.redAccent;
  static const Color _successColor = Colors.green;
  static const Color _pendingColor = Colors.grey;
  static const double _cardElevation = 4.0;
  static final BorderRadius _cardBorderRadius = BorderRadius.circular(12.0);
  static final BorderRadius _buttonBorderRadius = BorderRadius.circular(50.0);

  final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  @override
  void initState() {
    super.initState();
    _loadBookings();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _applyFiltersAndSort();
    });
  }

  Future<void> _loadBookings() async {
    int? userId = await getUserId();
    if (userId != null) {
      _bookingsFuture = fetchBookingsWithRoomDetails(userId);
      setState(() {});
      _bookingsFuture!.then((data) {
        setState(() {
          _allBookings = data;
          _applyFiltersAndSort();
        });
      }).catchError((error) {
        setState(() {
          _allBookings = [];
          _displayedBookings = [];
        });
        print("Error loading bookings: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi tải danh sách đặt phòng: $error'),
            backgroundColor: _errorColor,
          ),
        );
      });
    } else {
      setState(() {
        _allBookings = [];
        _displayedBookings = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lỗi: Không thể tải thông tin người dùng.'),
          backgroundColor: _errorColor,
        ),
      );
    }
  }

  void _applyFiltersAndSort() {
    List<BookingWithRoomInfo> filteredList = _allBookings;
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredList = filteredList.where((item) {
        final bookingIdMatch = item.booking.bookingId.toString().contains(query);
        final roomNameMatch = item.roomDetail.roomName.toLowerCase().contains(query);
        return bookingIdMatch || roomNameMatch;
      }).toList();
    } else {

      filteredList = List.from(_allBookings);
    }

    filteredList.sort((a, b) {
      DateTime? dateA;
      DateTime? dateB;
      int comparison = 0;

      try {
        switch (_selectedSortOption) {
          case SortOption.createdAtAsc:
          case SortOption.createdAtDesc:
            dateA = DateTime.tryParse(a.booking.createdAt);
            dateB = DateTime.tryParse(b.booking.createdAt);
            if (dateA != null && dateB != null) {
              comparison = dateA.compareTo(dateB);
            }
            break;
          case SortOption.checkInAsc:
          case SortOption.checkInDesc:
            dateA = DateTime.tryParse(a.booking.checkIn);
            dateB = DateTime.tryParse(b.booking.checkIn);
            if (dateA != null && dateB != null) {
              comparison = dateA.compareTo(dateB);
            }
            break;
        }
      } catch (e) {
        print("Error parsing date during sort: $e");
        comparison = 0;
      }


      if (_selectedSortOption == SortOption.createdAtDesc ||
          _selectedSortOption == SortOption.checkInDesc) {
        return -comparison;
      }
      return comparison;
    });
    _displayedBookings = filteredList;
  }

  Future<void> _submitReview(
      String content, int rating, int bookingId) async {
    if (content.isEmpty || rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Vui lòng nhập đánh giá và chọn số sao.'),
        backgroundColor: _errorColor,
      ));
      return;
    }

    final url = Uri.parse('${ApiConstants.baseUrl}/api/review');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'content': content,
          'rating': rating,
          'bookingId': bookingId,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Đánh giá đã được gửi thành công!'),
          backgroundColor: _successColor,
        ));
        _loadBookings();
      } else {
        print(
            'Failed to submit review. Status: ${response.statusCode}, Body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Có lỗi xảy ra khi gửi đánh giá. Vui lòng thử lại.'),
          backgroundColor: _errorColor,
        ));
      }
    } catch (e) {
      print('Error submitting review: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Lỗi kết nối khi gửi đánh giá.'),
        backgroundColor: _errorColor,
      ));
    }
  }

  void _showReviewDialog(int bookingId) {
    TextEditingController reviewController = TextEditingController();
    int localSelectedStars = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: _cardBorderRadius),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: _cardBorderRadius,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Đánh giá phòng',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor),
                      ),
                      const SizedBox(height: 16),
                      const Text('Chất lượng dịch vụ:',
                          style: TextStyle(fontSize: 14, color: _lightTextColor)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < localSelectedStars
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: Colors.amber,
                              size: 30,
                            ),
                            onPressed: () {
                              setDialogState(() {
                                localSelectedStars = index + 1;
                              });
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                      const Text('Nhận xét của bạn:',
                          style: TextStyle(fontSize: 14, color: _lightTextColor)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: reviewController,
                        decoration: InputDecoration(
                          hintText: 'Nhập nhận xét...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: _primaryColor),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Hủy', style: TextStyle(color: _lightTextColor)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              _submitReview(reviewController.text.trim(),
                                  localSelectedStars, bookingId);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: _buttonBorderRadius,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            child: const Text('Gửi đánh giá'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showReviewListDialog(List<ReviewResponseDto> reviews) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: _cardBorderRadius),
          title: const Text(
            'Đánh giá của bạn',
            style: TextStyle(
                color: _primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: reviews.isEmpty
                ? const Center(child: Text("Chưa có đánh giá nào."))
                : ListView.separated(
              shrinkWrap: true,
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Đánh giá: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: List.generate(5, (starIndex) {
                              return Icon(
                                starIndex < review.rating
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: Colors.amber,
                                size: 18,
                              );
                            }),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        review.content.isNotEmpty ? review.content : '(Không có nhận xét)',
                        style: TextStyle(color: review.content.isNotEmpty ? Colors.black87 : _lightTextColor, fontStyle: review.content.isNotEmpty ? FontStyle.normal : FontStyle.italic),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Đóng',
                style: TextStyle(
                    color: _primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Stack(
          children: [
            const Heading(title: 'LỊCH SỬ ĐẶT PHÒNG'),
            Positioned(
              left: 10,
              top: MediaQuery.of(context).padding.top + 5,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24),
                onPressed: () => Navigator.pop(context),
                tooltip: 'Quay lại',
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Transform.translate(
          offset: const Offset(0, -25),
          child: Column(
            children: [
              _buildFilterSortControls(),
              Expanded(
                child: FutureBuilder<List<BookingWithRoomInfo>>(
                  future: _bookingsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting && _allBookings.isEmpty) {
                      return const Center(child: CircularProgressIndicator(color: _primaryColor));
                    } else if (snapshot.hasError && _allBookings.isEmpty) {
                      print("Error in FutureBuilder: ${snapshot.error}");
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Không thể tải danh sách đặt phòng.\nLỗi: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: _errorColor, fontSize: 16),
                          ),
                        ),
                      );
                    } else if (_allBookings.isEmpty && !snapshot.hasData) {
                      return const Center(
                        child: Text(
                          'Bạn chưa có đặt phòng nào.',
                          style: TextStyle(fontSize: 16, color: _lightTextColor),
                        ),
                      );
                    } else if (_displayedBookings.isEmpty && _searchQuery.isNotEmpty) {
                      return const Center(
                        child: Text(
                          'Không tìm thấy đặt phòng phù hợp.',
                          style: TextStyle(fontSize: 16, color: _lightTextColor),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                        itemCount: _displayedBookings.length,
                        itemBuilder: (context, index) {
                          final item = _displayedBookings[index];
                          final booking = item.booking;
                          final room = item.roomDetail;
                          final reviewIds = item.booking.reviewIdList ?? [];
                          bool hasReviews = reviewIds.isNotEmpty;

                          final DateFormat displayDateFormat = DateFormat('dd/MM/yyyy HH:mm');
                          final DateFormat displayCreatedFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
                          final String checkInDate = displayDateFormat.format(DateTime.parse(booking.checkIn).toLocal());
                          final String checkOutDate = displayDateFormat.format(DateTime.parse(booking.checkOut).toLocal());
                          final String createdAtDate = displayCreatedFormat.format(DateTime.parse(booking.createdAt).toLocal());
                          final priceFormatted = NumberFormat("#,###", "vi_VN").format(booking.price);

                          Color statusColor;
                          String statusText;
                          switch (booking.status) {
                            case 'PENDING': statusColor = _pendingColor; statusText = 'Đang chờ'; break;
                            case 'CONFIRMED': statusColor = _successColor; statusText = 'Đã xác nhận'; break;
                            case 'CANCELLED': statusColor = _errorColor; statusText = 'Đã hủy'; break;
                            default: statusColor = Colors.grey; statusText = 'Không rõ';
                          }

                          return Card(
                            elevation: _cardElevation,
                            shape: RoundedRectangleBorder(borderRadius: _cardBorderRadius),
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          '${ApiConstants.baseUrl}/api/files/${room.roomImg}',
                                          width: 90,
                                          height: 75,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            width: 90,
                                            height: 75,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.broken_image, color: Colors.grey),
                                          ),
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Container(
                                              width: 90,
                                              height: 75,
                                              color: Colors.grey[200],
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  valueColor: const AlwaysStoppedAnimation<Color>(_primaryColor),
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                      : null,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '#${booking.bookingId} - ${room.roomName}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: _primaryColor,
                                                  fontSize: 15),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              room.hotelName,
                                              style: const TextStyle(fontSize: 13, color: _lightTextColor),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: statusColor.withOpacity(0.15),
                                                borderRadius: BorderRadius.circular(50),
                                                border: Border.all(color: statusColor, width: 0.5),
                                              ),
                                              child: Text(
                                                statusText,
                                                style: TextStyle(
                                                  color: statusColor,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          '$priceFormatted VND',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: _primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildDetailRow(Icons.location_on_outlined, room.specificAddress),
                                  _buildDetailRow(Icons.calendar_today_outlined, 'Đặt ngày: $createdAtDate'),
                                  _buildDetailRow(Icons.login_outlined, 'Nhận phòng: $checkInDate'),
                                  _buildDetailRow(Icons.logout_outlined, 'Trả phòng: $checkOutDate'),
                                  const Divider(height: 20, thickness: 0.5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const SizedBox(width: 10),
                                      if (booking.status == 'CONFIRMED')
                                        ElevatedButton.icon(
                                          onPressed: () async {
                                            if (hasReviews) {
                                              try {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) => const Center(
                                                      child: CircularProgressIndicator(color: _primaryColor)),
                                                );
                                                List<ReviewResponseDto> reviews = await getReviews(reviewIds);
                                                Navigator.pop(context);
                                                _showReviewListDialog(reviews);
                                              } catch (e) {
                                                Navigator.pop(context);
                                                print('Lỗi khi lấy đánh giá: $e');
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                  content: Text('Không thể tải danh sách đánh giá.'),
                                                  backgroundColor: _errorColor,
                                                ));
                                              }
                                            } else {
                                              _showReviewDialog(booking.bookingId);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: hasReviews
                                                ? _accentColor.withOpacity(0.8)
                                                : _primaryColor,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: _buttonBorderRadius,
                                            ),
                                            elevation: 2,
                                          ),
                                          icon: Icon(
                                            hasReviews ? Icons.rate_review_outlined : Icons.edit_note_outlined,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          label: Text(
                                            hasReviews ? 'Xem đánh giá' : 'Viết đánh giá',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildFilterSortControls() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tìm theo ID đặt phòng hoặc tên phòng...',
              prefixIcon: const Icon(Icons.search, color: _lightTextColor),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear, color: _lightTextColor),
                onPressed: () {
                  _searchController.clear();
                },
              )
                  : null,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: _primaryColor, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Sắp xếp theo:", style: TextStyle(color: _lightTextColor)),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<SortOption>(
                      value: _selectedSortOption,
                      isExpanded: true,
                      icon: const Icon(Icons.sort, color: _primaryColor),
                      items: const [
                        DropdownMenuItem(
                          value: SortOption.createdAtDesc,
                          child: Text("Ngày tạo (Mới nhất)", style: TextStyle(fontSize: 14)),
                        ),
                        DropdownMenuItem(
                          value: SortOption.createdAtAsc,
                          child: Text("Ngày tạo (Cũ nhất)", style: TextStyle(fontSize: 14)),
                        ),
                        DropdownMenuItem(
                          value: SortOption.checkInAsc,
                          child: Text("Ngày nhận phòng (Gần nhất)", style: TextStyle(fontSize: 14)),
                        ),
                        DropdownMenuItem(
                          value: SortOption.checkInDesc,
                          child: Text("Ngày nhận phòng (Xa nhất)", style: TextStyle(fontSize: 14)),
                        ),
                      ],
                      onChanged: (SortOption? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedSortOption = newValue;
                            _applyFiltersAndSort();
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: _lightTextColor),
          const SizedBox(width: 8),
          Expanded( // Allows text to wrap
            child: Text(
              text,
              style: const TextStyle(fontSize: 12.5, color: _lightTextColor),
            ),
          ),
        ],
      ),
    );
  }
}