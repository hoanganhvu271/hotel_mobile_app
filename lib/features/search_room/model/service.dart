class Service {
  final int serviceId;
  final String serviceName;

  Service({
    required this.serviceId,
    required this.serviceName,
  });

  // Tạo từ JSON
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceId: json['serviceId'] as int,
      serviceName: json['serviceName'] as String,
    );
  }

  // Chuyển sang JSON
  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'serviceName': serviceName,
    };
  }

  // So sánh bình đẳng
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Service &&
          runtimeType == other.runtimeType &&
          serviceId == other.serviceId &&
          serviceName == other.serviceName;

  @override
  int get hashCode => serviceId.hashCode ^ serviceName.hashCode;

  // Tạo bản sao với một số trường thay đổi
  Service copyWith({
    int? serviceId,
    String? serviceName,
  }) {
    return Service(
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
    );
  }

  @override
  String toString() =>
      'Service{serviceId: $serviceId, serviceName: $serviceName}';
}
