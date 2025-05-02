import 'package:intl/intl.dart';

class TimeUtils {
  /// Format mặc định: dd-MM-yyyy HH:mm
  static String formatDateTime(DateTime dateTime, {String format = 'dd-MM-yyyy HH:mm'}) {
    return DateFormat(format).format(dateTime);
  }

  /// Ví dụ: 30/04/2025
  static String formatDateOnly(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  /// Ví dụ: 14:30
  static String formatTimeOnly(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// ISO 8601 (dùng để gửi qua API): 2025-04-30T14:30:00
  static String toIsoString(DateTime dateTime) {
    return dateTime.toIso8601String();
  }
}
