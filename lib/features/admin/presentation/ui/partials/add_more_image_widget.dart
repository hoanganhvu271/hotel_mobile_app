import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_app/features/admin/model/room_image_wrapper.dart';
import 'package:hotel_app/features/admin/presentation/provider/image_upload_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../provider/create_room_provider.dart';

class AddMoreImageWidget extends ConsumerWidget {
  final int numberOfImages;

  const AddMoreImageWidget({
    super.key,
    this.numberOfImages = 3,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadImageViewModel = ref.watch(uploadImageProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Thêm ảnh",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(
            numberOfImages,
                (index) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SmallImageWidget(index: index),
            ),
          ),
        ),
      ],
    );
  }
}

class BigImagePickerWidget extends ConsumerStatefulWidget {
  final double width;
  final double height;

  const BigImagePickerWidget({
    super.key,
    this.width = double.infinity,
    this.height = 230,
  });

  @override
  ConsumerState<BigImagePickerWidget> createState() => _BigImagePickerWidgetState();
}

class _BigImagePickerWidgetState extends ConsumerState<BigImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ref.read(uploadImageProvider.notifier).setMainImage(
        XFile(pickedFile.path),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageList = ref.watch(uploadImageProvider);
    final mainImage = imageList.isNotEmpty ? imageList[0] : null;

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
          if (mainImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: mainImage.url != null
                  ? CachedNetworkImage(
                imageUrl: mainImage.url!,
                height: widget.height,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : Image.file(
                File(mainImage.imageFile!.path),
                height: widget.height,
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
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
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
              child: SvgPicture.asset(
                "assets/icons/icon_camera.svg",
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SmallImageWidget extends ConsumerWidget {
  final int index;

  const SmallImageWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ref.watch(uploadImageProvider);
    final hasImage = index + 1 < image.length;

    Future<void> _pickImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        ref.read(uploadImageProvider.notifier).addImage(
          RoomImageWrapper(file: XFile(pickedFile.path)),
        );
      }
    }

    void _removeImage() {
      ref.read(uploadImageProvider.notifier).removeImage(index + 1);
    }

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
            if (!hasImage)
              Center(
                child: InkWell(
                  onTap: _pickImage,
                  highlightColor: const Color.fromRGBO(0, 0, 0, 0.2),
                  child: SvgPicture.asset(
                    "assets/icons/icon_camera.svg",
                    width: 30,
                    height: 30,
                    colorFilter: const ColorFilter.mode(Color(0xFFD0D5DD), BlendMode.srcIn),
                  ),
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: image[index + 1].url != null
                    ? CachedNetworkImage(
                  imageUrl: image[index + 1].url!,
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                )
                    : Image.file(
                  File(image[index + 1].imageFile!.path),
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                ),
              ),
            if (hasImage)
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: _removeImage,
                  highlightColor: const Color.fromRGBO(0, 0, 0, 0.2),
                  child: SvgPicture.asset(
                    "assets/icons/icon_close_filled.svg",
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
