import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String label;
  final List<String> fetchData;
  final Function(String?) onChanged;
  final String? initialValue;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.fetchData,
    required this.onChanged,
    this.initialValue,
  });

  @override
  _CustomDropdown createState() => _CustomDropdown();
}

class _CustomDropdown extends State<CustomDropdown> {
  List<String> items = [];
  String? selected;

  @override
  void initState() {
    super.initState();
  }

  void loadData() {
    try {
      List<String> data = widget.fetchData;
      setState(() {
        items = ['Tất cả', ...data];
        // Nếu initialValue là null thì hiển thị 'Tất cả'
        selected = widget.initialValue ?? 'Tất cả';
        // Gửi giá trị null nếu là 'Tất cả', ngược lại gửi selected
        widget.onChanged(selected == 'Tất cả' ? null : selected!);
      });
    } catch (e) {
      print('Error fetching ${widget.label}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: Row(
        children: [
          Expanded(
            // phần label tự chiếm không gian còn lại bên trái
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
                value: selected,
                isExpanded: true,
                underline: const SizedBox(),
                items: items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => selected = newValue);
                    widget.onChanged(newValue);
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
