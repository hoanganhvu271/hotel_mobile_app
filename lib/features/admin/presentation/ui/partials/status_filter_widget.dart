import 'package:flutter/material.dart';
import 'package:hotel_app/constants/app_colors.dart';

class StatusFilterWidget extends StatelessWidget {
  final String currentFilter;
  final Function(String) onFilterChanged;

  const StatusFilterWidget({
    Key? key,
    required this.currentFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Lọc theo trạng thái:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip("ALL", "Tất cả"),
                const SizedBox(width: 8),
                _buildFilterChip("CONFIRMED", "Đã duyệt"),
                const SizedBox(width: 8),
                _buildFilterChip("PENDING", "Chờ duyệt"),
                const SizedBox(width: 8),
                _buildFilterChip("CANCELLED", "Đã hủy"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final bool isSelected = currentFilter == value;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onFilterChanged(value),
      selectedColor: ColorsLib.primaryColor.withOpacity(0.2),
      checkmarkColor: ColorsLib.primaryBoldColor,
      labelStyle: TextStyle(
        color: isSelected ? ColorsLib.primaryBoldColor : Colors.grey[600],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}