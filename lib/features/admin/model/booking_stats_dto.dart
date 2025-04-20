class BookingStatsDto {
  final DateTime date;
  final int count;

  BookingStatsDto({
    required this.date,
    required this.count,
  });

  factory BookingStatsDto.fromJson(Map<String, dynamic> json) {
    return BookingStatsDto(
      date: DateTime.parse(json['date']),
      count: json['count'] is int ? json['count'] : int.parse(json['count'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'count': count,
    };
  }
}
