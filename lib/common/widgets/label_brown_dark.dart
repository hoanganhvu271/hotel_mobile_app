import 'package:flutter/material.dart';

class LabelBrownDark extends StatelessWidget {
  final String? label;

  const LabelBrownDark({
    super.key,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (label == null || label!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: Text(
        label!,
        style: const TextStyle(
          color: Color(0xFF65462D),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
