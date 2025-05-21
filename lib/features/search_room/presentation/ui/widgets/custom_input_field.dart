import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String? initialValue;
  final Function(String) onChanged;

  const CustomInputField({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialValue,
  });

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    // Gọi onChanged ngay khi có initialValue
    if (widget.initialValue != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(widget.initialValue!);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
