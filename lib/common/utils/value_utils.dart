import 'dart:math' as Math;

import 'package:intl/intl.dart';

class ValueUtils {
  /// Làm tròn số [value] đến [fractionDigits] chữ số thập phân (mặc định 2)
  static double roundDouble(double value, [int fractionDigits = 2]) {
    final factor = Math.pow(10, fractionDigits);
    return (value * factor).round() / factor;
  }

  static String formatCurrency(double value) {
    final format = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: ' VND',
      decimalDigits: 0,
    );
    return format.format(value).trim();
  }
}
