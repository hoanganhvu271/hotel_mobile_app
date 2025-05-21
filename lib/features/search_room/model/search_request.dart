class SearchRequest {
  String? keyword;
  String? city;
  String? district;
  int? numOfAdult;
  int? numOfChild;
  int? numOfBed;
  List<String>? services;

  SearchRequest({
    this.keyword = " ",
    this.city = "",
    this.district = "",
    this.numOfAdult = 0,
    this.numOfChild = 0,
    this.numOfBed = 0,
    this.services,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'keyword': keyword,
        'city': city,
        'district': district,
        'numOfAdult': numOfAdult,
        'numOfChild': numOfChild,
        'numOfBed': numOfBed,
        'services': services,
      };

  // Create from JSON
  factory SearchRequest.fromJson(Map<String, dynamic> json) {
    return SearchRequest(
      keyword: json['keyword'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      numOfAdult: json['numOfAdult'] as int?,
      numOfChild: json['numOfChild'] as int?,
      numOfBed: json['numOfBed'] as int?,
      services: json['services'] != null
          ? List<String>.from(json['services'] as List)
          : null,
    );
  }

  // Create a copy with some fields changed
  SearchRequest copyWith({
    String? keyword,
    String? city,
    String? district,
    int? numOfAdult,
    int? numOfChild,
    int? numOfBed,
    List<String>? services,
  }) {
    return SearchRequest(
      keyword: keyword ?? this.keyword,
      city: city ?? this.city,
      district: district ?? this.district,
      numOfAdult: numOfAdult ?? this.numOfAdult,
      numOfChild: numOfChild ?? this.numOfChild,
      numOfBed: numOfBed ?? this.numOfBed,
      services: services ?? this.services,
    );
  }

  @override
  String toString() =>
      'SearchRequest(keyword: $keyword, city: $city, district: $district, '
      'numOfAdult: $numOfAdult, numOfChild: $numOfChild, numOfBed: $numOfBed, services: $services)';
}
