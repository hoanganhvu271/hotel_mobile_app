class BillResponseDto {
  final int billId;
  final double totalPrice;
  final bool paidStatus;

  BillResponseDto({
    required this.billId,
    required this.totalPrice,
    required this.paidStatus,
  });

  factory BillResponseDto.fromJson(Map<String, dynamic> json) {
    return BillResponseDto(
      billId: json['billId'],
      totalPrice: json['totalPrice'],
      paidStatus: json['paidStatus'],
    );
  }
}
