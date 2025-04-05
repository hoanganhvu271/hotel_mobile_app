import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hotel_app/features/more/presentation/ui/more_screen.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants/app_colors.dart';

class RoomFormScreen extends StatelessWidget {
  const RoomFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: ColoredBox(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const ImagePickerWidget(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    spacing: 19,
                    children: <Widget>[
                      const CustomTextArea(maxLine: 1, label: "Tên phòng", keyboardType: TextInputType.text),
                      const CustomTextArea(maxLine: 4, label: "Mô tả", keyboardType: TextInputType.multiline),
                      const CustomTextArea(maxLine: 1, label: "Diện tích (m2)", keyboardType: TextInputType.number),
                      const CustomTextArea(maxLine: 1, label: "Giá theo giờ", keyboardType: TextInputType.number),
                      const CustomTextArea(maxLine: 1, label: "Giá theo đêm", keyboardType: TextInputType.number),
                      const CustomTextArea(maxLine: 1, label: "Giá thêm giờ", keyboardType: TextInputType.number),
                      const Row(
                        spacing: 16,
                        children: [
                          Expanded(child: CustomTextArea(maxLine: 1, label: "Số người tối đa", keyboardType: TextInputType.number)),
                          Expanded(child: CustomTextArea(maxLine: 1, label: "Số trẻ em miễn phí", keyboardType: TextInputType.number)),
                        ],
                      ),
                      const Row(
                        spacing: 16,
                        children: [
                          Expanded(child: CustomTextArea(maxLine: 1, label: "Số lượng phòng", keyboardType: TextInputType.number)),
                          Expanded(child: CustomTextArea(maxLine: 1, label: "Số giường", keyboardType: TextInputType.number)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomFilledButton(title: "Xác nhận", backgroundColor: ColorsLib.primaryColor)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;

  // Khởi tạo ImagePicker
  final ImagePicker _picker = ImagePicker();

  // Chức năng chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      decoration: BoxDecoration(
        color: const Color(0xB2F9DBDB),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        border: Border.all(
          color: const Color(0xFFD0D5DD),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          if (_imageFile != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                _imageFile!,
                height: 230,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          Positioned(
            top: 25,
            left: 16,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                highlightColor: const Color.fromRGBO(0, 0, 0, 0.2),
                child: SvgPicture.asset(
                  "assets/icons/icon_back.svg",
                  colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            right: 22,
            child: InkWell(
              onTap: _pickImage,
              highlightColor: const Color.fromRGBO(0, 0, 0, 0.2),
              child: SvgPicture.asset("assets/icons/icon_camera.svg"),
            ),
          ),
        ],
      ),
    );
  }
}

