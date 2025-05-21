import 'package:intl/intl.dart';

String convertPriceToString(double price) {
  final formatter =
      NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);
  return formatter.format(price);
}
