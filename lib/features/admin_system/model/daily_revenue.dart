class DailyRevenue {
  final String date;
  final double revenue;

  DailyRevenue({required this.date, required this.revenue});

  factory DailyRevenue.fromJsonEntry(MapEntry<String, dynamic> entry) {
    return DailyRevenue(
      date: entry.key,
      revenue: (entry.value as num).toDouble(),
    );
  }
}
