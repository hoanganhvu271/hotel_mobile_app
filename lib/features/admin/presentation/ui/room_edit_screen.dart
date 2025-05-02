import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/constants/api_url.dart';
import 'package:hotel_app/features/admin/model/create_room_request.dart';
import 'package:hotel_app/features/admin/model/put_room_request.dart';
import 'package:hotel_app/features/admin/model/room_image_wrapper.dart';
import 'package:hotel_app/features/admin/model/room_response_dto.dart';
import 'package:hotel_app/features/admin/presentation/provider/create_room_provider.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/add_more_image_widget.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/room_info_widget.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/service_widget.dart';
import 'package:hotel_app/features/more/presentation/ui/more_screen.dart';
import '../../../../constants/app_colors.dart';
import '../provider/image_upload_provider.dart';

class RoomEditScreen extends ConsumerStatefulWidget {
  final RoomResponseDto room;

  const RoomEditScreen({super.key, required this.room});

  @override
  ConsumerState<RoomEditScreen> createState() => _RoomFormScreenState();
}

class _RoomFormScreenState extends ConsumerState<RoomEditScreen> {
  final roomNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final areaController = TextEditingController();
  final comboPriceController = TextEditingController();
  final nightPriceController = TextEditingController();
  final extraHourPriceController = TextEditingController();
  final maxOccupancyController = TextEditingController();
  final freeChildrenController = TextEditingController();
  final roomCountController = TextEditingController();
  final bedNumberController = TextEditingController();
  final standardOccupancyController = TextEditingController();
  final extraAdultController = TextEditingController();

  @override
  void initState() {
    final room = widget.room;

    roomNameController.text = room.roomName;
    descriptionController.text = room.description;
    areaController.text = room.area.toString();
    comboPriceController.text = room.comboPrice2h.toString();
    nightPriceController.text = room.pricePerNight.toString();
    extraHourPriceController.text = room.extraHourPrice.toString();
    maxOccupancyController.text = room.maxOccupancy.toString();
    freeChildrenController.text = room.numChildrenFree.toString();
    // Nếu có roomCount trong RoomResponseDto, thêm dòng sau:
    // roomCountController.text = room.roomCount.toString();
    bedNumberController.text = room.bedNumber.toString();
    standardOccupancyController.text = room.standardOccupancy.toString();
    extraAdultController.text = room.extraAdult.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(uploadImageProvider.notifier).addImage(RoomImageWrapper(
        url: '${ApiUrl.baseURL}${ApiUrl.uploadPath}/${room.roomImg}',
      ));
      for (var img in room.roomImageUrls) {
        ref.read(uploadImageProvider.notifier).addImage(RoomImageWrapper(
          url: '${ApiUrl.baseURL}${ApiUrl.uploadPath}/${img.url}',
        ));
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    roomNameController.dispose();
    descriptionController.dispose();
    areaController.dispose();
    comboPriceController.dispose();
    nightPriceController.dispose();
    extraHourPriceController.dispose();
    maxOccupancyController.dispose();
    freeChildrenController.dispose();
    roomCountController.dispose();
    bedNumberController.dispose();
    standardOccupancyController.dispose();
    extraAdultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Material(
          child: ColoredBox(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const BigImagePickerWidget(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      spacing: 19,
                      children: <Widget>[
                        const AddMoreImageWidget(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Thông tin phòng",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 19),
                            Column(
                              spacing: 10,
                              children: [
                                CustomTextArea(controller: roomNameController, maxLine: 1, label: "Tên phòng", keyboardType: TextInputType.text),
                                CustomTextArea(controller: descriptionController, maxLine: 4, label: "Mô tả", keyboardType: TextInputType.multiline),
                                CustomTextArea(controller: areaController, maxLine: 1, label: "Diện tích (m2)", keyboardType: TextInputType.number),
                                CustomTextArea(controller: comboPriceController, maxLine: 1, label: "Giá theo giờ", keyboardType: TextInputType.number),
                                CustomTextArea(controller: nightPriceController, maxLine: 1, label: "Giá theo đêm", keyboardType: TextInputType.number),
                                CustomTextArea(controller: extraHourPriceController, maxLine: 1, label: "Giá thêm giờ", keyboardType: TextInputType.number),
                                Row(
                                  children: [
                                    Expanded(child: CustomTextArea(controller: maxOccupancyController, maxLine: 1, label: "Số người tối đa", keyboardType: TextInputType.number)),
                                    const SizedBox(width: 16),
                                    Expanded(child: CustomTextArea(controller: freeChildrenController, maxLine: 1, label: "Số trẻ em miễn phí", keyboardType: TextInputType.number)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: CustomTextArea(controller: roomCountController, maxLine: 1, label: "Số lượng phòng", keyboardType: TextInputType.number)),
                                    const SizedBox(width: 16),
                                    Expanded(child: CustomTextArea(controller: bedNumberController, maxLine: 1, label: "Số giường", keyboardType: TextInputType.number)),
                                  ],
                                ),
                                CustomTextArea(controller: standardOccupancyController, maxLine: 1, label: "SL Tiêu chuẩn", keyboardType: TextInputType.number),
                                CustomTextArea(controller: extraAdultController, maxLine: 1, label: "SL Người lớn thêm", keyboardType: TextInputType.number),
                              ],
                            )
                          ],
                        ),
                        const ServiceWidget(),
                        const SizedBox(height: 10),
                        CustomFilledButton(
                          title: "Xác nhận",
                          backgroundColor: ColorsLib.primaryColor,
                          onTap: () {
                            ref.read(createRoomViewModel.notifier).updateRoom(
                                PutRoomRequest(
                                  roomName: roomNameController.text,
                                  area: double.parse(areaController.text),
                                  comboPrice2h: double.parse(comboPriceController.text),
                                  pricePerNight: double.parse(nightPriceController.text),
                                  extraHourPrice: double.parse(extraHourPriceController.text),
                                  standardOccupancy: int.parse(standardOccupancyController.text),
                                  maxOccupancy: int.parse(maxOccupancyController.text),
                                  numChildrenFree: int.parse(freeChildrenController.text),
                                  bedNumber: int.parse(bedNumberController.text),
                                  extraAdult: double.parse(extraAdultController.text),
                                  description: descriptionController.text,
                                  id: widget.room.id,
                                  serviceList: [],
                                  editImageIdList: ref.read(uploadImageProvider.notifier).getKeepImageIdList(),
                                )
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
