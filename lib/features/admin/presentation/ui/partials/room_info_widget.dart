import 'package:flutter/material.dart';

import '../../../../../constants/app_colors.dart';

class CustomTextArea extends StatelessWidget {

  final TextEditingController controller;
  final int maxLine;
  final String label;
  final TextInputType keyboardType;

  const CustomTextArea({
    super.key,
    required this.controller,
    required this.maxLine,
    required this.label,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TextFormField(
        controller: controller,
        maxLines: maxLine,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide(color: ColorsLib.primaryBoldColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          labelText: label,
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
