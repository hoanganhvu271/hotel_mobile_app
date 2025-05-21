class ServiceModel {
  final int serviceId;
  final String serviceName;
  final double price;

  ServiceModel({
    required this.serviceId,
    required this.serviceName,
    required this.price,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'serviceName': serviceName,
      'price': price,
    };
  }
}