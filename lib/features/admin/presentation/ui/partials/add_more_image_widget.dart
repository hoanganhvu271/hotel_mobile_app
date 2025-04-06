import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class AddMoreImageWidget extends StatelessWidget {
  final int numberOfImages;

  const AddMoreImageWidget({
    super.key,
    this.numberOfImages = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Thêm ảnh",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 20,
          children: [
            ...List.generate(numberOfImages, (_) => const SmallImageWidget()).toList(),
          ],
        ),
      ],
    );
  }
}

class BigImagePickerWidget extends StatefulWidget {
  final double width;
  final double height;

  const BigImagePickerWidget({
    super.key,
    this.width = double.infinity,
    this.height = 230,
  });

  @override
  BigImagePickerWidgetState createState() => BigImagePickerWidgetState();
}

class BigImagePickerWidgetState extends State<BigImagePickerWidget> {
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
      width: widget.width,
      height: widget.height,
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
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
              child: SvgPicture.asset("assets/icons/icon_camera.svg", colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
            ),
          ),
        ],
      ),
    );
  }
}

class SmallImageWidget extends StatefulWidget {
  const SmallImageWidget({super.key});

  @override
  State<SmallImageWidget> createState() => _SmallImageWidgetState();
}

class _SmallImageWidgetState extends State<SmallImageWidget> {
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

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
    return DottedBorder(
        color: const Color(0xFFD0D5DD),
        strokeWidth: 4,
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        dashPattern: const [4, 3],
        child: Container(
            color: Colors.white,
            width: 65,
            height: 65,
            child: Stack(
              children: [
                _imageFile == null ? Center(
                    child: InkWell(
                        onTap: () {
                          _pickImage();
                        },
                        highlightColor: const Color.fromRGBO(0, 0, 0, 0.2),
                        child: SvgPicture.asset(
                            "assets/icons/icon_camera.svg",
                            width: 30, height: 30,
                            colorFilter: const ColorFilter.mode(Color(0xFFD0D5DD), BlendMode.srcIn)
                        )
                    )
                ) : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _imageFile!,
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                    )
                ),

                if (_imageFile != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _imageFile = null;
                        });
                      },
                      highlightColor: const Color.fromRGBO(0, 0, 0, 0.2),
                      child: SvgPicture.asset(
                        "assets/icons/icon_close_filled.svg",
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  )
              ],
            )
        )
    );
  }
}
