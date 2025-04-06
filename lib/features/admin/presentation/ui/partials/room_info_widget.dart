import 'package:flutter/material.dart';

import '../../../../../constants/app_colors.dart';

class RoomInfoWidget extends StatelessWidget {
  const RoomInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 19,
      children: [
        Text(
          "Thông tin phòng",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        CustomTextArea(maxLine: 1, label: "Tên phòng", keyboardType: TextInputType.text),
        CustomTextArea(maxLine: 4, label: "Mô tả", keyboardType: TextInputType.multiline),
        CustomTextArea(maxLine: 1, label: "Diện tích (m2)", keyboardType: TextInputType.number),
        CustomTextArea(maxLine: 1, label: "Giá theo giờ", keyboardType: TextInputType.number),
        CustomTextArea(maxLine: 1, label: "Giá theo đêm", keyboardType: TextInputType.number),
        CustomTextArea(maxLine: 1, label: "Giá thêm giờ", keyboardType: TextInputType.number),
        Row(
          spacing: 16,
          children: [
            Expanded(child: CustomTextArea(maxLine: 1, label: "Số người tối đa", keyboardType: TextInputType.number)),
            Expanded(child: CustomTextArea(maxLine: 1, label: "Số trẻ em miễn phí", keyboardType: TextInputType.number)),
          ],
        ),
        Row(
          spacing: 16,
          children: [
            Expanded(child: CustomTextArea(maxLine: 1, label: "Số lượng phòng", keyboardType: TextInputType.number)),
            Expanded(child: CustomTextArea(maxLine: 1, label: "Số giường", keyboardType: TextInputType.number)),
          ],
        ),
      ],
    );
  }
}

class CustomTextArea extends StatelessWidget {
  final int maxLine;
  final String label;
  final TextInputType keyboardType;

  const CustomTextArea({
    super.key,
    required this.maxLine,
    required this.label,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TextFormField(
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
