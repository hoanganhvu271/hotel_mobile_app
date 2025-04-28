import 'package:flutter/material.dart';
import 'package:hotel_app/common/widgets/heading.dart';
import 'package:hotel_app/features/admin_system/admin_booking_list.dart';
import 'package:hotel_app/features/admin_system/model/revenue_model.dart';
import 'package:hotel_app/features/admin_system/services/revenue_service.dart';
import 'package:hotel_app/features/admin_system/widgets/revenue_line_chart.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;


class AdminRoomRevenueScreen extends StatefulWidget {
  final int roomId;
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
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();
  RevenueModel? _revenue;

  final RevenueService _revenueService = RevenueService();
  List<FlSpot> _revenueData = [];
  bool _isLoading = false;
  double _totalRevenueInRange = 0.0;

  FlSpot? _selectedSpot;
  double? _selectedPositionX;
  bool _showSelectedInfo = false;

  double _chartMinX = 0;
  double _chartMaxX = 0;
  double _chartMinY = 0;
  double _chartMaxY = 100;
  double _leftInterval = 100;
  double _chartWidth = 0;

  static const Color _brownColor = Color(0xFF65462D);

  @override
  void initState() {
    super.initState();
    _startDateController.text = DateFormat('yyyy-MM-dd').format(_startDate!);
    _endDateController.text = DateFormat('yyyy-MM-dd').format(_endDate!);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchRevenue());
    _setDateRange('thisMonth');
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (selectedDate != null && selectedDate != _startDate) {
      setState(() {
        _startDate = selectedDate;
        _startDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        _clearSelection();
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (selectedDate != null && selectedDate != _endDate) {
      setState(() {
        _endDate = selectedDate;
        _endDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        _clearSelection();
      });
    }
  }

  Future<void> _fetchRevenue() async {
    if (_startDate == null || _endDate == null || _endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text(_startDate == null || _endDate == null
              ? 'Vui lòng chọn ngày bắt đầu và kết thúc.'
              : 'Ngày kết thúc không được trước ngày bắt đầu.')));
      return;
    }

    setState(() {
      _isLoading = true;
      _revenueData = [];
      _revenue = null;
      _totalRevenueInRange = 0;
      _clearSelection();
    });

    final startDateFormatted = DateFormat("yyyy-MM-dd'T'00:00:00").format(_startDate!);
    final endDateAdjusted = _endDate!.add(const Duration(days: 1)).subtract(const Duration(microseconds: 1));
    final endDateFormatted = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(endDateAdjusted);

    try {
      RevenueModel revenue = await _revenueService.fetchRevenueData(startDateFormatted, endDateFormatted);
      _revenue = revenue;
      Map<String, double> revenueByDate = {};
      double currentRangeTotal = 0.0;

      for (var booking in revenue.bookingDetailList) {
        String checkInDate = booking.checkIn.substring(0, 10);
        revenueByDate[checkInDate] = (revenueByDate[checkInDate] ?? 0) + booking.price;
        currentRangeTotal += booking.price;
      }

      List<MapEntry<String, double>> sortedRevenue = revenueByDate.entries.toList()
        ..sort((a, b) => DateTime.parse(a.key).compareTo(DateTime.parse(b.key)));

      List<FlSpot> spots = sortedRevenue.map((entry) {
        DateTime parsedDate = DateTime.parse(entry.key);
        return FlSpot(parsedDate.millisecondsSinceEpoch.toDouble(), entry.value);
      }).toList();

      if (mounted) {
        setState(() {
          _revenueData = spots;
          _totalRevenueInRange = currentRangeTotal;
          _calculateChartBounds();
        });
        if (_revenueData.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Không có dữ liệu doanh thu cho khoảng thời gian đã chọn.')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi lấy dữ liệu: $e')));
      }
    } finally {
      if (mounted) { setState(() { _isLoading = false; }); }
    }
  }


  void _clearSelection() {
    if (_showSelectedInfo || _selectedSpot != null) {
      setState(() {
        _selectedSpot = null;
        _selectedPositionX = null;
        _showSelectedInfo = false;
      });
    }
  }

  void _calculateChartBounds() {
    double? calculatedMinX, calculatedMaxX, minY, maxY;
    double tempLeftInterval = 100;

    if (_revenueData.isNotEmpty) {
      calculatedMinX = _revenueData.map((spot) => spot.x).reduce(math.min);
      calculatedMaxX = _revenueData.map((spot) => spot.x).reduce(math.max);
      if (_revenueData.length == 1) {
        const oneDayInMillis = 24 * 60 * 60 * 1000;
        calculatedMinX = calculatedMinX! - oneDayInMillis;
        calculatedMaxX = calculatedMaxX! + oneDayInMillis;
      }
      minY = 0;
      maxY = _revenueData.map((spot) => spot.y).reduce(math.max);
      maxY = maxY == 0 ? 100 : maxY * 1.15;
      double rangeY = maxY - minY;
      if (rangeY > 0) {
        tempLeftInterval = (rangeY / 4).ceilToDouble();
        if (tempLeftInterval > 1000) tempLeftInterval = (tempLeftInterval / 500).ceil() * 500;
        else if (tempLeftInterval > 100) tempLeftInterval = (tempLeftInterval / 100).ceil() * 100;
        else if (tempLeftInterval > 10) tempLeftInterval = (tempLeftInterval / 10).ceil() * 10;
        else tempLeftInterval = math.max(10, tempLeftInterval);
      } else {
        tempLeftInterval = math.max(10, maxY / 2);
      }
      if (tempLeftInterval <= 0) tempLeftInterval = 100;
    } else {
      final now = DateTime.now();
      calculatedMinX = now.subtract(const Duration(days: 1)).millisecondsSinceEpoch.toDouble();
      calculatedMaxX = now.add(const Duration(days: 1)).millisecondsSinceEpoch.toDouble();
      minY = 0;
      maxY = 100;
      tempLeftInterval = 25;
    }


    _chartMinX = calculatedMinX!;
    _chartMaxX = calculatedMaxX!;
    _chartMinY = minY;
    _chartMaxY = maxY;
    _leftInterval = tempLeftInterval;
  }


  void _handleChartTap(FlTouchEvent event, LineTouchResponse? response) {
    if (event is FlTapUpEvent) {
      if (response != null && response.lineBarSpots != null &&
          response.lineBarSpots!.isNotEmpty && _chartWidth > 0)
      {
        final spot = response.lineBarSpots![0];
        final positionX = calculatePositionX(spot.x, _chartMinX, _chartMaxX, _chartWidth);

        setState(() {
          _selectedSpot = spot;
          _selectedPositionX = positionX;
          _showSelectedInfo = positionX != null;
        });
      } else {
        _clearSelection();
      }
    }
  }

  double? calculatePositionX(double dataX, double chartMinX, double chartMaxX, double chartWidth) {
    if (chartWidth <= 0) return null;
    if (chartMaxX == chartMinX) return chartWidth / 2;
    double proportion = (dataX - chartMinX) / (chartMaxX - chartMinX);
    return proportion * chartWidth;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle( color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10);
    String text;
    if (value == meta.max || value == meta.min) return Container();

    if (value >= 1000000) text = '${(value / 1000000).toStringAsFixed(1)}M';
    else if (value >= 1000) text = '${(value / 1000).toStringAsFixed(0)}k';
    else text = value.toStringAsFixed(0);

    return SideTitleWidget( axisSide: meta.axisSide, space: 6, child: Text(text, style: style, textAlign: TextAlign.center));
  }

  DateTime _getStartOfWeek(DateTime date) {
    int difference = date.weekday - DateTime.monday;
    return date.subtract(Duration(days: difference));
  }

  DateTime _getEndOfWeek(DateTime date) {
    int difference = DateTime.sunday - date.weekday;
    return date.add(Duration(days: difference));
  }

  DateTime _getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  DateTime _getEndOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  void _setDateRange(String range) {
    setState(() {
      DateTime now = DateTime.now();
      switch (range) {
        case 'today':
          _startDate = now;
          _endDate = now;
          break;
        case 'thisWeek':
          _startDate = _getStartOfWeek(now);
          _endDate = _getEndOfWeek(now);
          break;
        case 'lastWeek':
          DateTime lastWeekStart = _getStartOfWeek(now).subtract(Duration(days: 7));
          _startDate = lastWeekStart;
          _endDate = _getEndOfWeek(lastWeekStart);
          break;
        case 'thisMonth':
          _startDate = _getStartOfMonth(now);
          _endDate = _getEndOfMonth(now);
          break;
        case 'lastMonth':
          DateTime lastMonth = DateTime(now.year, now.month - 1, 1);
          _startDate = _getStartOfMonth(lastMonth);
          _endDate = _getEndOfMonth(lastMonth);
          break;
        default:
          _startDate = now;
          _endDate = now;
          break;
      }
      _startDateController.text = DateFormat('yyyy-MM-dd').format(_startDate!);
      _endDateController.text = DateFormat('yyyy-MM-dd').format(_endDate!);
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
              Heading(title: 'DOANH THU ${widget.roomName.toUpperCase()}'),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _setDateRange('today'),
                        child: const Text('Hôm nay'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _setDateRange('thisWeek'),
                        child: const Text('Tuần này'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _setDateRange('lastWeek'),
                        child: const Text('Tuần trước'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _setDateRange('thisMonth'),
                        child: const Text('Tháng này'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _setDateRange('lastMonth'),
                        child: const Text('Tháng trước'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _startDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Bắt đầu',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today, size: 20),
                            onPressed: () => _selectStartDate(context),
                          ),
                          border: const OutlineInputBorder(),
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                          ),
                          border: const OutlineInputBorder(),
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _fetchRevenue,
                  icon: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.bar_chart_rounded, color: Colors.white),
                  label: const Text('Xem Doanh Thu'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Color(0xFF65462D),
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: Text(
                    'Tổng doanh thu: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(_totalRevenueInRange)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 25),

                SizedBox(
                  height: 200.0,
                  child: _isLoading && _revenueData.isEmpty
                      ? const Center(child: CircularProgressIndicator(color: _brownColor))
                      : _revenueData.isEmpty && !_isLoading
                      ? const Center(
                    child: Text(
                      'Không có dữ liệu để hiển thị.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                      : LayoutBuilder(
                    builder: (context, constraints) {
                      _chartWidth = constraints.maxWidth;
                      if (_chartWidth <= 0) return const SizedBox.shrink();
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          RevenueLineChart(
                            revenueData: _revenueData,
                            selectedSpot: _selectedSpot,
                            showSelectedInfo: _showSelectedInfo,
                            chartMinX: _chartMinX,
                            chartMaxX: _chartMaxX,
                            chartMinY: _chartMinY,
                            chartMaxY: _chartMaxY,
                            leftInterval: _leftInterval,
                            leftTitleWidgets: leftTitleWidgets,
                            onTapSpot: _handleChartTap,
                          ),
                          if (_showSelectedInfo &&
                              _selectedPositionX != null &&
                              _selectedSpot != null)
                            Positioned(
                              left: _selectedPositionX,
                              top: -30,
                              child: FractionalTranslation(
                                translation: const Offset(-0.5, 0.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text(
                                    '${DateFormat('dd/MM/yy').format(DateTime.fromMillisecondsSinceEpoch(_selectedSpot!.x.toInt()))}\n${NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(_selectedSpot!.y)}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      height: 1.2,
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

                const SizedBox(height: 20),

                if (_revenue != null && _revenue!.bookingDetailList.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingPage(
                            bookingDetails: _revenue!.bookingDetailList,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Xem danh sách đặt phòng'),
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

}