class Service {
  final int serviceId;
  final String serviceName;
  final double price;

  Service({
    required this.serviceId,
    required this.serviceName,
    required this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'serviceId': serviceId,
    'serviceName': serviceName,
    'price': price,
  };
}
