import 'package:flutter/material.dart';

class ApiDropdown extends StatefulWidget {
  final String label;
  final Future<List<String>> Function() fetchData;
  final Function(String?) onChanged;
  final String? initialValue;

  const ApiDropdown({
    super.key,
    required this.label,
    required this.fetchData,
    required this.onChanged,
    this.initialValue,
  });

  @override
  _ApiDropdownState createState() => _ApiDropdownState();
}

class _ApiDropdownState extends State<ApiDropdown> {
  List<String> items = [];
  String? selected;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      List<String> data = await widget.fetchData();
      setState(() {
        items = ['Tất cả', ...data];
        selected = widget.initialValue ?? 'Tất cả';
        widget.onChanged(selected == 'Tất cả' ? null : selected!);
      });
    } catch (e) {
      print('Error fetching ${widget.label}: $e');
    }
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
