class ChartData {
  final String label;
  final double value;

  ChartData({
    required this.label,
    required this.value,
  });

  @override
  String toString() {
    return 'ChartData(label: $label, value: $value)';
  }
}