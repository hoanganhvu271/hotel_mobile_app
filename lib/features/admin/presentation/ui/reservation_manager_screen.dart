import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/utils/time_util.dart';
import 'package:hotel_app/features/admin/model/booking_dto.dart';
import 'package:hotel_app/features/admin/presentation/provider/booking_provider.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/search_box_widget.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/top_app_bar.dart';
import 'package:hotel_app/constants/app_colors.dart';

import 'booking_details_screen.dart';


class ReservationManagerScreen extends ConsumerStatefulWidget {
  const ReservationManagerScreen({super.key});

  @override
  ConsumerState<ReservationManagerScreen> createState() => _ReservationManagerScreenState();
}

class _ReservationManagerScreenState extends ConsumerState<ReservationManagerScreen> {
  final ScrollController _scrollController = ScrollController();
  String _currentStatusFilter = "ALL"; // Mặc định hiển thị tất cả
  bool _isLoadingMore = false;

  void _onScroll() {
    final viewModel = ref.read(bookingViewModel);

    final isNearBottom = _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100;

    final canLoad = !_isLoadingMore && viewModel.canLoadMore;

    if (isNearBottom && canLoad) {
      _isLoadingMore = true;
      print('Loading more reservations...');

      ref.read(bookingViewModel.notifier).loadMore().then((_) {
        _isLoadingMore = false;
      }).catchError((error) {
        print('Failed to load reservations: $error');
        _isLoadingMore = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onStatusFilterChanged(String status) {
    print("Selected status: $status");
    setState(() {
      _currentStatusFilter = status;
    });

    ref.read(bookingViewModel.notifier).setSearchState(
      page: 0,
      filterStatus: status == "ALL" ? null : status,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(bookingViewModel);

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Material(
          child: Column(
            children: [
              const TopAppBar(title: "Danh sách đặt phòng"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: SearchBoxWidget(
                  onChange: (text) => ref.read(bookingViewModel.notifier).setSearchState(
                    query: text,
                    page: 0,
                    filterStatus: _currentStatusFilter == "ALL" ? null : _currentStatusFilter,
                  ),
                ),
              ),

              // Thêm bộ lọc trạng thái ở đây
              _buildStatusFilter(),

              Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => ref.read(bookingViewModel.notifier).refresh(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: viewModel.when(
                          emptyData: () => const Center(
                            child: Text(
                              "Không có dữ liệu",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFB1B1B1),
                              ),
                            ),
                          ),
                          success: (data) {
                            return ListView.separated(
                              controller: _scrollController,
                              itemBuilder: (_, index) {
                                if (index == viewModel.listData.length) {
                                  return viewModel.canLoadMore
                                      ? const Center(child: CircularProgressIndicator())
                                      : const SizedBox();
                                }
                                else {
                                  return ReservationItem(booking: viewModel.listData[index]);
                                }
                              },
                              itemCount: viewModel.listData.length + 1,
                              separatorBuilder: (_, index) => Container(
                                height: 3,
                                color: const Color(0xFFD9D9D9),
                              ),
                            );
                          },
                          error: (error) => Center(child: Text(error.toString())),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          orElse: () => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget cho bộ lọc trạng thái
  Widget _buildStatusFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Lọc theo trạng thái:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip("ALL", "Tất cả"),
                const SizedBox(width: 8),
                _buildFilterChip("CONFIRMED", "Đã duyệt"),
                const SizedBox(width: 8),
                _buildFilterChip("PENDING", "Chờ duyệt"),
                const SizedBox(width: 8),
                _buildFilterChip("CANCELLED", "Đã hủy"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final bool isSelected = _currentStatusFilter == value;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _onStatusFilterChanged(value),
      selectedColor: ColorsLib.primaryColor.withOpacity(0.2),
      checkmarkColor: ColorsLib.primaryBoldColor,
      labelStyle: TextStyle(
        color: isSelected ? ColorsLib.primaryBoldColor : Colors.grey[600],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

class ReservationItem extends StatelessWidget {
  final BookingResponseDto booking;

  const ReservationItem({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        highlightColor: const Color.fromRGBO(0, 0, 0, 0.2),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => BookingDetailsScreen(id: booking.bookingId!),
          ));
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(booking.roomName.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  Text("ID: ${booking.bookingId}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                ],
              ),
              Text(booking.user?.fullName ?? "", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              Text(booking.user?.phone ?? "", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              Wrap(
                spacing: 10,
                children: [
                  Text("Checkin: ${TimeUtils.formatDateTime(booking.checkIn!)}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                  Text("Checkout: ${TimeUtils.formatDateTime(booking.checkOut!)}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                ],
              ),

              // Hiển thị trạng thái với màu sắc khác nhau
              _buildStatusBadge(booking.status ?? ""),
            ],
          ),
        ),
      ),
    );
  }

  // Widget hiển thị trạng thái với màu sắc tương ứng
  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    String statusText;

    switch (status) {
      case 'CONFIRMED':
        badgeColor = Colors.green;
        statusText = "Đã duyệt";
        break;
      case 'PENDING':
        badgeColor = Colors.orange;
        statusText = "Chờ duyệt";
        break;
      case 'CANCELLED':
        badgeColor = Colors.red;
        statusText = "Đã hủy";
        break;
      default:
        badgeColor = Colors.grey;
        statusText = status;
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}