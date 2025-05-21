class BillResponseDto {
  final int billId;
  final double totalPrice;
  final bool paidStatus;
  final int userId;

  BillResponseDto({
    required this.billId,
    required this.totalPrice,
    required this.paidStatus,
    required this.userId,
  });

  factory BillResponseDto.fromJson(Map<String, dynamic> json) {
    return BillResponseDto(
      billId: json['billId'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
      paidStatus: json['paidStatus'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'billId': billId,
      'totalPrice': totalPrice,
      'paidStatus': paidStatus,
      'userId': userId,
    };
  }
}
