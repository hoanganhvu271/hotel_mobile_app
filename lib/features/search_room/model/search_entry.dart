class SearchEntry {
  final String type;
  final dynamic value;

  SearchEntry({
    required this.type,
    required this.value,
  });

  // Create from JSON
  factory SearchEntry.fromJson(Map<String, dynamic> json) {
    return SearchEntry(
      type: json['type'] as String,
      value: json['value'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
    };
  }

  // For equality comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchEntry &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          value == other.value;

  @override
  int get hashCode => type.hashCode ^ value.hashCode;

  @override
  String toString() => 'SearchEntry{type: $type, value: $value}';

  // Create a copy with some fields changed
  SearchEntry copyWith({
    String? type,
    dynamic value,
  }) {
    return SearchEntry(
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }
}
