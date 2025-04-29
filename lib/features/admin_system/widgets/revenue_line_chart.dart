import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RevenueLineChart extends StatelessWidget {
  final List<FlSpot> revenueData;
  final FlSpot? selectedSpot;
  final bool showSelectedInfo;
  final double chartMinX;
  final double chartMaxX;
  final double chartMinY;
  final double chartMaxY;
  final double leftInterval;
  final Widget Function(double, TitleMeta) leftTitleWidgets;
  final Function(FlTouchEvent, LineTouchResponse?) onTapSpot;

  const RevenueLineChart({
    Key? key,
    required this.revenueData,
    required this.selectedSpot,
    required this.showSelectedInfo,
    required this.chartMinX,
    required this.chartMaxX,
    required this.chartMinY,
    required this.chartMaxY,
    required this.leftInterval,
    required this.leftTitleWidgets,
    required this.onTapSpot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: chartMinX,
        maxX: chartMaxX,
        minY: chartMinY,
        maxY: chartMaxY,

        gridData: FlGridData(
          show: true,
          drawHorizontalLine: false,
          drawVerticalLine: true,
          checkToShowVerticalLine: (value) {
            const tolerance = 1.0;
            return showSelectedInfo && selectedSpot != null &&
                (value - selectedSpot!.x).abs() < tolerance;
          },
          getDrawingVerticalLine: (value) {
            return const FlLine(
              color: Colors.redAccent,
              strokeWidth: 1,
              dashArray: [4, 4],
            );
          },
        ),

        titlesData: FlTitlesData(
          show: true,
          bottomTitles: const AxisTitles( sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: leftTitleWidgets,
              interval: leftInterval,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),

        lineBarsData: [
          LineChartBarData(
            spots: revenueData,
            isCurved: true,
            gradient: const LinearGradient(
              colors: [Colors.cyanAccent, Colors.blueAccent],
              begin: Alignment.centerLeft, end: Alignment.centerRight,
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [ Colors.cyanAccent.withOpacity(0.3), Colors.blueAccent.withOpacity(0.0)],
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
              ),
            ),
            preventCurveOverShooting: true,
          ),
        ],

        lineTouchData: LineTouchData(
          handleBuiltInTouches: false,
          touchCallback: onTapSpot,
          getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                const FlLine(color: Colors.transparent),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, bar, index) =>
                      FlDotCirclePainter( radius: 6, color: Colors.redAccent, strokeWidth: 2, strokeColor: Colors.white),
                ),
              );
            }).toList();
          },
          touchSpotThreshold: 20,
        ),
      ),
    );
  }
}