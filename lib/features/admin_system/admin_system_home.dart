import 'package:flutter/material.dart';
import 'package:hotel_app/common/widgets/heading.dart';
import 'package:hotel_app/features/admin_system/admin_system_hotels.dart';
import 'package:hotel_app/features/admin_system/admin_system_users.dart';
import 'package:hotel_app/features/admin_system/model/admin_data.dart';
import 'package:hotel_app/features/admin_system/model/daily_revenue.dart';
import 'package:hotel_app/features/admin_system/services/admin_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AdminSystemHome extends StatefulWidget {
  const AdminSystemHome({super.key});

  @override
  State<AdminSystemHome> createState() => _AdminSystemHomeState();
}


class _AdminSystemHomeState extends State<AdminSystemHome> {
  late Future<AdminData> _adminData;
  late Future<List<DailyRevenue>> _monthlyRevenue;

  @override
  void initState() {
    super.initState();
    _adminData = AdminService().fetchAdminData();
    _monthlyRevenue = AdminService().fetchMonthlyRevenue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              const Heading(title: 'TRANG QUẢN TRỊ'),
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
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    FutureBuilder<AdminData>(
                      future: _adminData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Lỗi: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          final data = snapshot.data!;
                          return Column(
                            children: [
                              _buildInfoCard("Số lượng khách sạn", data.totalHotels),
                              const SizedBox(height: 20),
                              _buildInfoCard("Số lượng khách hàng", data.totalUsers),
                              const SizedBox(height: 20),
                              _buildInfoCard("Số lượng đặt phòng", data.totalBookings),
                            ],
                          );
                        } else {
                          return const Center(child: Text('Không có dữ liệu'));
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    FutureBuilder<List<DailyRevenue>>(
                      future: _monthlyRevenue,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Lỗi biểu đồ: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          return _buildRevenueChart(snapshot.data!);
                        } else {
                          return const Center(child: Text('Không có dữ liệu doanh thu'));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, int value) {
    return GestureDetector(
      // onTap: () {
      //   if (title == "Số lượng khách hàng") {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const AdminSystemUsers()),
      //     );
      //   }
      // },

      onTap: () {
        if (title == "Số lượng khách sạn") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminSystemHotels()),
          );
        } else if (title == "Số lượng khách hàng") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminSystemUsers()),
          );
        }
      },

      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              Text(value.toString(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildRevenueChart(List<DailyRevenue> data) {
    data.sort((a, b) => a.date.compareTo(b.date));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Biểu đồ doanh thu tháng này",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            SizedBox(
              height: 240,
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.black87,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final index = spot.x.toInt();
                          final day = data[index].date.split('-').last;
                          final formattedRevenue = NumberFormat("#,###", "vi_VN").format(spot.y);
                          return LineTooltipItem(
                            // 'Ngày $day\n${spot.y.toStringAsFixed(0)} VNĐ',
                            'Ngày $day\n$formattedRevenue',
                            const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index >= 0 && index < data.length) {
                            final day = data[index].date.split('-').last;
                            return Text(day, style: const TextStyle(fontSize: 10));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        getTitlesWidget: (value, _) => Text(
                          '${value.toInt()}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value.revenue);
                      }).toList(),
                      isCurved: true,
                      color: Colors.orangeAccent,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.orangeAccent.withOpacity(0.3),
                      ),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.orange,
                            strokeWidth: 1.5,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
