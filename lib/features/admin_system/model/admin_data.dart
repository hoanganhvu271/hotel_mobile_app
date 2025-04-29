class AdminData {
  final int totalHotels;
  final int totalUsers;
  final int totalBookings;

  AdminData({
    required this.totalHotels,
    required this.totalUsers,
    required this.totalBookings,
  });

  factory AdminData.fromJson(Map<String, dynamic> json) {
    return AdminData(
      totalHotels: json['totalHotels'],
      totalUsers: json['totalUsers'],
      totalBookings: json['totalBookings'],
    );
  }
}
