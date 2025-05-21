enum BookingStatus {
  PENDING,
  CONFIRMED,
  CANCELLED,
}

extension BookingStatusExtension on BookingStatus {
  String get description {
    switch (this) {
      case BookingStatus.PENDING:
        return "Chờ xác nhận";
      case BookingStatus.CONFIRMED:
        return "Đã xác nhận";
      case BookingStatus.CANCELLED:
        return "Đã hủy";
    }
  }
}
