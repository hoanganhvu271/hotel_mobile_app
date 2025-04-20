import 'package:flutter/material.dart';

class RangeInputField extends StatefulWidget {
  final String label;
  final String? initialFrom;
  final String? initialTo;
  final Function(String from, String to) onChanged;

  const RangeInputField({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialFrom,
    this.initialTo,
  });

  @override
  State<RangeInputField> createState() => _RangeInputFieldState();
}

class _RangeInputFieldState extends State<RangeInputField> {
  late TextEditingController _fromController;
  late TextEditingController _toController;

  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController(text: widget.initialFrom ?? '');
    _toController = TextEditingController(text: widget.initialTo ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged(_fromController.text, _toController.text);
    });
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _onInputChange() {
    widget.onChanged(_fromController.text, _toController.text);
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
            width: 100,
            child: TextField(
              controller: _fromController,
              onChanged: (_) => _onInputChange(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Từ',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFCAC4D0)),
                ),
              ),
              style: const TextStyle(
                color: Color(0xFF65462D),
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: TextField(
              controller: _toController,
              onChanged: (_) => _onInputChange(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Đến',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFCAC4D0)),
                ),
              ),
              style: const TextStyle(
                color: Color(0xFF65462D),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
