import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_app/common/utils/time_util.dart';
import 'package:hotel_app/features/admin/model/booking_stats_dto.dart';
import 'package:hotel_app/features/admin/model/chart_data.dart';
import 'package:hotel_app/features/admin/presentation/provider/hotel_info_provider.dart';
import 'package:hotel_app/features/admin/presentation/provider/room_provider.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/top_app_bar.dart';
import 'package:hotel_app/features/admin/presentation/ui/report_screen.dart';
import 'package:hotel_app/features/admin/presentation/ui/reservation_manager_screen.dart';
import 'package:hotel_app/features/admin/presentation/ui/review_management_screen.dart';
import 'package:hotel_app/features/admin/presentation/ui/room_manager_screen.dart';
import 'package:hotel_app/features/admin/presentation/ui/select_hotel_screen.dart';
import '../../../../common/hotel_storage_provider.dart';
import '../../../../constants/app_colors.dart';
import '../provider/booking_provider.dart';
import '../provider/dashboard_provider.dart';

class HotelOwnerScreen extends ConsumerStatefulWidget {
  const HotelOwnerScreen({super.key});

  @override
  ConsumerState<HotelOwnerScreen> createState() => _HotelOwnerScreenState();
}

class _HotelOwnerScreenState extends ConsumerState<HotelOwnerScreen> {
  @override
  void initState() {
    super.initState();

    // Check if a hotel is selected on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkHotelSelection();
    });
  }

  void _checkHotelSelection() async {
    final hotelId = ref.read(hotelStorageProvider).getCurrentHotelId();

    if (hotelId == null) {
      // Navigate to hotel selection screen if no hotel is selected
      await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SelectHotelScreen())
      );

      // After returning, check if a hotel was selected, otherwise pop back
      final selectedHotelId = ref.read(hotelStorageProvider).getCurrentHotelId();
      if (selectedHotelId == null && mounted) {
        Navigator.pop(context);
        return;
      }
    }

    // Load hotel info and dashboard data once a hotel is selected
    _loadHotelData();
  }

  // Function to load all hotel-related data
  void _loadHotelData() {
    ref.read(hotelInfoViewModel.notifier).getHotelInfo();
    ref.read(bookingStatsViewModel.notifier).getData();
    ref.read(reviewStatsViewModel.notifier).getData();
    ref.read(roomCountViewModel.notifier).getRoomCount();
    ref.read(bookingCountViewModel.notifier).getBookingCount();
  }

  void _switchHotel() async {
    await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SelectHotelScreen())
    );

    // Reload data with the new hotel
    _loadHotelData();
  }

  @override
  Widget build(BuildContext context) {
    int roomQty = ref.watch(roomCountViewModel).when(
      success: (data) => data,
      error: (e) => 0,
      loading: () => 0,
      orElse: () => 0,
    );

    int bookingQty = ref.watch(bookingCountViewModel).when(
      success: (data) => data,
      error: (e) => 0,
      loading: () => 0,
      orElse: () => 0,
    );

    return SafeArea(
      child: ColoredBox(
        color: ColorsLib.greyBGColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TopAppBar(
              title: "Quản lý khách sạn",
              backgroundColor: ColorsLib.greyBGColor,
              actions: [
                IconButton(
                  icon: const Icon(Icons.swap_horiz, color: Colors.white),
                  onPressed: _switchHotel,
                  tooltip: "Switch Hotel",
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    spacing: 10,
                    children: [
                      const SizedBox(height: 5),
                      const StatusWidget(),
                      BookingChart(),
                      const StatisticWidget(),
                      IntrinsicHeight(
                        child: Row(
                          spacing: 15,
                          children: [
                            Expanded(child:
                            OptionItem(
                                title: "Quản lý phòng",
                                iconPath: "assets/icons/icon_door.svg",
                                value: roomQty,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RoomManagerScreen()))
                            )
                            ),
                            Expanded(
                                child: OptionItem(
                                    title: "Đặt phòng",
                                    iconPath: "assets/icons/icon_report.svg",
                                    value: bookingQty,
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const ReservationManagerScreen()))
                                )
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Rest of the widget implementations remain the same
class StatusWidget extends ConsumerWidget {
  final String logoPath;

  const StatusWidget({
    super.key,
    this.logoPath = "assets/images/logo.png",
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotelInfo = ref.watch(hotelInfoViewModel);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: hotelInfo.when(
          success: (hotel) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel.hotelName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hotel.address != null
                          ? "${hotel.address?.specificAddress}, ${hotel.address?.ward}, ${hotel.address?.district}, ${hotel.address?.city}"
                          : "No address available",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF667085),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportScreen())),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Xem báo cáo >",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                            color: Color(0xFF667085),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(logoPath, width: 60, height: 60, fit: BoxFit.cover),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error) => Center(child: Text("Error: $error")),
          orElse: () => const Center(child: Text("Please select a hotel")),
        ),
      ),
    );
  }
}


class BookingChart extends ConsumerWidget {
  const BookingChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          spacing: 26,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Thống kê lượt đặt",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF667085),
              ),
            ),
            ref.watch(bookingStatsViewModel).when(
              success: (data) {
                return BookingBarChart(bookings: data);
              },
              error: (e) => Center(
                child: Text(
                  e.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF667085),
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              orElse: () => const SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }
}


class BookingBarChart extends StatelessWidget {
  final List<BookingStatsDto> bookings;

  const BookingBarChart({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    // Check if the bookings list is empty
    if (bookings.isEmpty) {
      return const Center(
        child: Text(
          "Không có dữ liệu đặt phòng",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF667085),
          ),
        ),
      );
    }

    // Find maximum value safely
    final double maxY = bookings.isNotEmpty
        ? bookings.map((b) => b.count.toDouble()).reduce((a, b) => a > b ? a : b)
        : 10.0; // Default value if list is empty

    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          maxY: maxY > 0 ? maxY : 10.0, // Make sure maxY is at least 1.0
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) {
                return const Color(0xFF65462D); // ColorsLib.primaryBoldColor
              },
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.toInt()}',
                  const TextStyle(color: Colors.white, fontSize: 12),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Text("${value.toInt()}", style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
                  );
                },
                reservedSize: 30,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < bookings.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        TimeUtils.formatDateOnly(bookings[index].date),
                        style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
                      ),
                    );
                  } else {
                    return const SizedBox();  // Return an empty widget for invalid indices
                  }
                },
                reservedSize: 30,
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Color(0xFFF2F3F6),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return const FlLine(
                color: Color(0xFFF2F3F6),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: bookings.asMap().entries.map((entry) {
            final index = entry.key;
            final booking = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: booking.count.toDouble(),
                  width: 30,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                  color: const Color(0xFFA68367),
                )
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class StatisticWidget extends ConsumerWidget {
  const StatisticWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Navigate to Review Management Screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReviewManagementScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Đánh giá",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF667085),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              ref.watch(reviewStatsViewModel).when(
                success: (data) {
                  return Column(
                    spacing: 20,
                    children: [
                      RatingItem(
                        title: "Trung bình",
                        value: data.averageRating,
                        percent: data.averageRatingChangePercent,
                      ),
                      RatingItem(
                        title: "Số lượng",
                        value: data.totalReviews.toDouble(),
                        percent: data.reviewCountChangePercent,
                        borderColor: Color(0xFFC6D7FE),
                      ),
                    ],
                  );
                },
                error: (e) => Center(
                  child: Text(
                    e.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF667085),
                    ),
                  ),
                ),
                orElse: () => const SizedBox.shrink(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RatingItem extends StatelessWidget {
  final String title;
  final double value;
  final double percent;
  final Color borderColor;

  const RatingItem({
    super.key,
    required this.title,
    this.value = 0,
    this.percent = 0,
    this.borderColor = const Color(0xFFF570C7),
  });

  @override
  Widget build(BuildContext context) {
    String formattedPercent = percent > 0 ? "Tăng +$percent %" : "Giảm $percent %";
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 40),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(2),
          bottomLeft: Radius.circular(2),
        ),
        border: Border(
          left: BorderSide(
            color: borderColor,
            width: 3,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 21,
                height: 1.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D2939),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$value",
                style: const TextStyle(
                  fontSize: 24,
                  height: 1.33,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF65462D),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formattedPercent,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.33,
                  fontWeight: FontWeight.w500,
                  color: percent > 0 ? const Color(0xFF12B669) : const Color(0xFFF04437),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final String title;
  final String iconPath;
  final int value;
  final Function()? onTap;

  const OptionItem({
    super.key,
    required this.title,
    required this.iconPath,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => onTap?.call(),
        borderRadius: BorderRadius.circular(12),
        highlightColor: Colors.black.withValues(alpha: 0.2),
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF667085)
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(iconPath),
                  Text(
                    "$value",
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF65462D),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Chi tiết",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF667085),
                    ),
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset("assets/icons/icon_arrow_right.svg"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
