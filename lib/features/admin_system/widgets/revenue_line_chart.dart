import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
// No intl needed here unless formatting happens inside this widget

class RevenueLineChart extends StatelessWidget {
  final List<FlSpot> revenueData;
  final FlSpot? selectedSpot;
  final bool showSelectedInfo; // To control grid line visibility
  final double chartMinX;
  final double chartMaxX;
  final double chartMinY;
  final double chartMaxY;
  final double leftInterval;
  final Widget Function(double, TitleMeta) leftTitleWidgets; // Function for Y titles
  final Function(FlTouchEvent, LineTouchResponse?) onTapSpot; // Callback for touch

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
    // The build method now *only* returns the LineChart widget
    return LineChart(
      LineChartData(
        // Use passed min/max values
        minX: chartMinX,
        maxX: chartMaxX,
        minY: chartMinY,
        maxY: chartMaxY,

        // ----- Grid Data (Dynamic Vertical Line) -----
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: false,
          drawVerticalLine: true,
          // Use passed state to check if line should be shown
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

        // ----- Titles Data (Axis Labels) -----
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: const AxisTitles( sideTitles: SideTitles(showTitles: false)), // X Axis hidden
          leftTitles: AxisTitles( // Y Axis configured using passed function
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35, // Keep consistent
              getTitlesWidget: leftTitleWidgets, // Use passed function
              interval: leftInterval, // Use passed interval
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        // ----- Border Data -----
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),

        // ----- Line Bar Data -----
        lineBarsData: [
          LineChartBarData(
            spots: revenueData, // Use passed data
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

        // ----- Touch Interaction Data -----
        lineTouchData: LineTouchData(
          handleBuiltInTouches: false, // Manual handling
          touchCallback: onTapSpot, // Use passed callback function
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
      // Keep swap animation if desired, triggered by parent state changes
      // swapAnimationDuration: const Duration(milliseconds: 250),
      // swapAnimationCurve: Curves.linear,
    );
  }
}