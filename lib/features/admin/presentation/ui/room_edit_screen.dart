import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/constants/api_url.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/admin/model/put_room_request.dart';
import 'package:hotel_app/features/admin/model/room_image_wrapper.dart';
import 'package:hotel_app/features/admin/model/room_response_dto.dart';
import 'package:hotel_app/features/admin/presentation/provider/create_room_provider.dart';
import 'package:hotel_app/features/admin/presentation/provider/delete_room_provider.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/add_more_image_widget.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/room_info_widget.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/service_selector_widget.dart';
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

  // List to track selected service IDs
  List<int> selectedServiceIds = [];

  @override
  void initState() {
    super.initState();
    final room = widget.room;

    // Set initial form values
    roomNameController.text = room.roomName;
    descriptionController.text = room.description;
    areaController.text = room.area.toString();
    comboPriceController.text = room.comboPrice2h.toString();
    nightPriceController.text = room.pricePerNight.toString();
    extraHourPriceController.text = room.extraHourPrice.toString();
    maxOccupancyController.text = room.maxOccupancy.toString();
    freeChildrenController.text = room.numChildrenFree.toString();
    bedNumberController.text = room.bedNumber.toString();
    standardOccupancyController.text = room.standardOccupancy.toString();
    extraAdultController.text = room.extraAdult.toString();

    // Set initial selected services
    selectedServiceIds = room.serviceDtoList.map((service) => service.serviceId).toList();

    // Set up images
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(uploadImageProvider.notifier).addImage(RoomImageWrapper(
        url: '${ApiUrl.baseURL}${ApiUrl.uploadPath}/${room.roomImg}',
      ));
      for (var img in room.roomImageUrls) {
        ref.read(uploadImageProvider.notifier).addImage(RoomImageWrapper(
          id: img.imgId,
          url: '${ApiUrl.baseURL}${ApiUrl.uploadPath}/${img.url}',
        ));
      }
    });
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

  // Handle service selection changes
  void _onServicesChanged(List<int> serviceIds) {
    setState(() {
      selectedServiceIds = serviceIds;
    });
  }

  // Show confirmation dialog for room deletion
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: const Text("Bạn có chắc chắn muốn xóa phòng này không? Hành động này không thể hoàn tác."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(deleteRoomProvider.notifier).deleteRoom(widget.room.id);
            },
            child: const Text("Xóa"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final updateRoomState = ref.watch(createRoomViewModel);
    final deleteRoomState = ref.watch(deleteRoomProvider);

    // Listen for delete room state changes
    ref.listen(deleteRoomProvider, (previous, current) {
      if (previous?.status != current.status) {
        if (current.status.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Xóa phòng thành công")),
          );
          Navigator.of(context).pop();
          Navigator.of(context).pop(); // Pop twice to go back to rooms list
        } else if (current.status.isError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Lỗi: ${current.message}")),
          );
        }
      }
    });

    // Listen for update room state changes
    ref.listen(createRoomViewModel, (previous, current) {
      if (previous?.status != current.status) {
        if (current.status.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Cập nhật phòng thành công")),
          );
          Navigator.of(context).pop();
        } else if (current.status.isError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Lỗi: ${current.message}")),
          );
        }
      }
    });

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const BigImagePickerWidget(),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const AddMoreImageWidget(),
                          const SizedBox(height: 20),
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
                              const SizedBox(height: 16),
                              Column(
                                children: [
                                  CustomTextArea(controller: roomNameController, maxLine: 1, label: "Tên phòng", keyboardType: TextInputType.text),
                                  const SizedBox(height: 10),
                                  CustomTextArea(controller: descriptionController, maxLine: 4, label: "Mô tả", keyboardType: TextInputType.multiline),
                                  const SizedBox(height: 10),
                                  CustomTextArea(controller: areaController, maxLine: 1, label: "Diện tích (m2)", keyboardType: TextInputType.number),
                                  const SizedBox(height: 10),
                                  CustomTextArea(controller: comboPriceController, maxLine: 1, label: "Giá theo giờ", keyboardType: TextInputType.number),
                                  const SizedBox(height: 10),
                                  CustomTextArea(controller: nightPriceController, maxLine: 1, label: "Giá theo đêm", keyboardType: TextInputType.number),
                                  const SizedBox(height: 10),
                                  CustomTextArea(controller: extraHourPriceController, maxLine: 1, label: "Giá thêm giờ", keyboardType: TextInputType.number),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: CustomTextArea(controller: maxOccupancyController, maxLine: 1, label: "Số người tối đa", keyboardType: TextInputType.number)),
                                      const SizedBox(width: 16),
                                      Expanded(child: CustomTextArea(controller: freeChildrenController, maxLine: 1, label: "Số trẻ em miễn phí", keyboardType: TextInputType.number)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: CustomTextArea(controller: roomCountController, maxLine: 1, label: "Số lượng phòng", keyboardType: TextInputType.number)),
                                      const SizedBox(width: 16),
                                      Expanded(child: CustomTextArea(controller: bedNumberController, maxLine: 1, label: "Số giường", keyboardType: TextInputType.number)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextArea(controller: standardOccupancyController, maxLine: 1, label: "SL Tiêu chuẩn", keyboardType: TextInputType.number),
                                  const SizedBox(height: 10),
                                  CustomTextArea(controller: extraAdultController, maxLine: 1, label: "SL Người lớn thêm", keyboardType: TextInputType.number),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Service Selector Widget with initial values
                          ServiceSelectorWidget(
                            selectedServiceIds: selectedServiceIds,
                            onServicesChanged: _onServicesChanged,
                          ),

                          const SizedBox(height: 24),
                          Row(
                            children: [
                              // Delete button
                              Expanded(
                                child: CustomFilledButton(
                                  title: "Xóa phòng",
                                  backgroundColor: Colors.red,
                                  onTap: _showDeleteConfirmation,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Update button
                              Expanded(
                                child: CustomFilledButton(
                                  title: "Cập nhật",
                                  backgroundColor: ColorsLib.primaryColor,
                                  onTap: () {
                                    // Show loading indicator
                                    if (updateRoomState.status.isLoading) return;

                                    // Validate inputs
                                    if (!_validateInputs()) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Vui lòng điền đầy đủ thông tin"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    // Update room
                                    ref.read(createRoomViewModel.notifier).updateRoom(
                                        PutRoomRequest(
                                          roomId: widget.room.id,
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
                                          serviceIds: selectedServiceIds, // Add selected service IDs
                                          editImageIdList: ref.read(uploadImageProvider.notifier).getKeepImageIdList(),
                                        )
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30), // Extra space at bottom
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Loading overlay
              if (updateRoomState.status.isLoading || deleteRoomState.status.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateInputs() {
    // Validate that all required fields are filled
    return roomNameController.text.isNotEmpty &&
        areaController.text.isNotEmpty &&
        comboPriceController.text.isNotEmpty &&
        nightPriceController.text.isNotEmpty &&
        extraHourPriceController.text.isNotEmpty &&
        maxOccupancyController.text.isNotEmpty &&
        freeChildrenController.text.isNotEmpty &&
        bedNumberController.text.isNotEmpty &&
        standardOccupancyController.text.isNotEmpty &&
        extraAdultController.text.isNotEmpty;
  }
}