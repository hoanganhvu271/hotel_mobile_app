import 'package:flutter/material.dart';

class StaticDropdown extends StatefulWidget {
  final String label;
  final Function(String) onChanged;
  final String? initialValue;

  const StaticDropdown({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<StaticDropdown> createState() => _StaticDropdownState();
}

class _StaticDropdownState extends State<StaticDropdown> {
  final Map<String, String> options = {
    'Giá thấp - cao': 'price_asc',
    'Giá cao - thấp': 'price_desc',
    'Đánh giá giảm dần': 'rating_desc',
    'Đánh giá tăng dần': 'rating_asc',
  };

  String? selectedLabel;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      selectedLabel = options.entries
          .firstWhere((entry) => entry.value == widget.initialValue,
              orElse: () => const MapEntry('Giá thấp - cao', 'price_asc'))
          .key;
    } else {
      selectedLabel = options.keys.first;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged(options[selectedLabel!]!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${widget.label}:',
              style: const TextStyle(
                color: Color(0xFF65462D),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 215,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFCAC4D0)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: selectedLabel,
                isExpanded: true,
                underline: const SizedBox(),
                items: options.keys.map((String label) {
                  return DropdownMenuItem<String>(
                    value: label,
                    child: Text(label),
                  );
                }).toList(),
                onChanged: (String? newLabel) {
                  if (newLabel != null) {
                    setState(() => selectedLabel = newLabel);
                    widget.onChanged(options[newLabel]!);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
