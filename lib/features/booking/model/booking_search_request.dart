class BookingSearchRequest {
  String infoSearch;
  String? city;
  String? district;
  String checkInDate;
  String checkOutDate;
  String checkInTime;
  String checkOutTime;
  int adults;
  int children;
  int bedNumber;
  double priceFrom;
  double priceTo;
  String sortBy;
  List<String> services;

  BookingSearchRequest({
    required this.infoSearch,
    required this.city,
    required this.district,
    required this.checkInDate,
    required this.checkOutDate,
    required this.checkInTime,
    required this.checkOutTime,
    required this.adults,
    required this.children,
    required this.bedNumber,
    required this.priceFrom,
    required this.priceTo,
    required this.sortBy,
    required this.services,
  });

  Map<String, dynamic> toJson() => {
    'infoSearch': infoSearch,
    'city': city,
    'district': district,
    'checkInDate': checkInDate,
    'checkOutDate': checkOutDate,
    'checkInTime': checkInTime,
    'checkOutTime': checkOutTime,
    'adults': adults,
    'children': children,
    'bedNumber': bedNumber,
    'priceFrom': priceFrom,
    'priceTo': priceTo,
    'sortBy': sortBy,
    'services': services,
  };
}
