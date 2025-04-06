import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_app/features/admin/model/chart_data.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/top_app_bar.dart';
import 'package:hotel_app/features/admin/presentation/ui/report_screen.dart';
import 'package:hotel_app/features/admin/presentation/ui/reservation_manager_screen.dart';
import 'package:hotel_app/features/admin/presentation/ui/room_manager_screen.dart';

import '../../../../constants/app_colors.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ColoredBox(
        color: ColorsLib.greyBGColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TopAppBar(title: "Quản lý khách sạn", backgroundColor: ColorsLib.greyBGColor),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    spacing: 10,
                    children: [
                      const SizedBox(height: 5),
                      StatusWidget(),
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
                                value: 50,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RoomManagerScreen()))
                              )
                            ),
                            Expanded(
                                child: OptionItem(
                                  title: "Đặt phòng",
                                  iconPath: "assets/icons/icon_report.svg",
                                  value: 29,
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

class StatusWidget extends StatelessWidget {
  final String hotelName;
  final String hotelAddress;
  final String logoPath;

  const StatusWidget({
    super.key,
    this.hotelName = "PTIT Hotel",
    this.hotelAddress = "Mo Lao, Ha Dong, Ha Noi",
    this.logoPath = "assets/images/logo.png",
  });

  @override
  Widget build(BuildContext context) {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotelName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hotelAddress,
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
        )
      ),
    );
  }
}


class BookingChart extends StatelessWidget {
  final List<ChartData> bookings = [
    ChartData(label: "Day 1", value: 20),
    ChartData(label: "Day 2", value: 30),
    ChartData(label: "Day 3", value: 25),
    ChartData(label: "Day 4", value: 40),
    ChartData(label: "Day 5", value: 35),
    ChartData(label: "Day 6", value: 50),
    ChartData(label: "Day 7", value: 45),
  ];

  BookingChart({super.key});

  @override
  Widget build(BuildContext context) {
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
            BookingBarChart(bookings: bookings),
          ],
        ),
      ),
    );
  }
}

class BookingBarChart extends StatelessWidget {
  final List<ChartData> bookings;

  const BookingBarChart({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          maxY: bookings.reduce((a, b) => a.value > b.value ? a : b).value.toDouble(),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) {
                return ColorsLib.primaryBoldColor;
              },
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY}',
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
                        bookings[index].label,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
                      ),
                    );
                  } else {
                    return const SizedBox();  // Trả về SizedBox nếu index không hợp lệ.
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
          barGroups: List.generate(bookings.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: bookings[index].value,
                  width: 30,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                  color: const Color(0xFFA68367),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}

class StatisticWidget extends StatelessWidget {
  const StatisticWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: const Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Đánh giá",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF667085),
              ),
            ),
            RatingItem(
              title: "Trung bình",
              value: 4.5,
              percent: -10,
            ),
            RatingItem(
              title: "Số lượng",
              value: 20,
              percent: 20,
              borderColor: Color(0xFFC6D7FE),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingItem extends StatelessWidget {
  final String title;
  final double value;
  final int percent;
  final Color borderColor;

  const RatingItem({
    super.key,
    required this.title,
    required this.value,
    required this.percent,
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
