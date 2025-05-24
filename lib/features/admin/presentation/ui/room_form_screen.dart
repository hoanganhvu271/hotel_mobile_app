import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/admin/model/create_room_request.dart';
import 'package:hotel_app/features/admin/presentation/provider/create_room_provider.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/add_more_image_widget.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/room_info_widget.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/service_selector_widget.dart';
import 'package:hotel_app/features/more/presentation/ui/more_screen.dart';
import '../../../../common/hotel_storage_provider.dart';
import '../../../../constants/app_colors.dart';
import '../provider/image_upload_provider.dart';

class RoomFormScreen extends ConsumerStatefulWidget {
  const RoomFormScreen({super.key});

  @override
  ConsumerState<RoomFormScreen> createState() => _RoomFormScreenState();
}

class _RoomFormScreenState extends ConsumerState<RoomFormScreen> {
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

  @override
  Widget build(BuildContext context) {
    final createRoomState = ref.watch(createRoomViewModel);
    // Get the current hotel ID from storage
    final currentHotelId = ref.watch(selectedHotelIdProvider);

    ref.listen(createRoomViewModel, (previous, current) {
      if (previous?.status != current.status) {
        if (current.status.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Tạo phòng thành công")),
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
                                  CustomTextArea(controller: bedNumberController, maxLine: 1, label: "Số giường", keyboardType: TextInputType.number),
                                  const SizedBox(height: 10),
                                  CustomTextArea(controller: standardOccupancyController, maxLine: 1, label: "SL Tiêu chuẩn", keyboardType: TextInputType.number),
                                  const SizedBox(height: 10),
                                  CustomTextArea(controller: extraAdultController, maxLine: 1, label: "Chi phí thêm người lớn", keyboardType: TextInputType.number),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Service Selector Widget
                          ServiceSelectorWidget(
                            selectedServiceIds: selectedServiceIds,
                            onServicesChanged: _onServicesChanged,
                          ),

                          const SizedBox(height: 24),
                          CustomFilledButton(
                            title: "Xác nhận",
                            backgroundColor: ColorsLib.primaryColor,
                            onTap: () {
                              // Show loading indicator
                              if (createRoomState.status.isLoading) return;

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

                              // Make sure a hotel is selected
                              if (currentHotelId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Vui lòng chọn khách sạn trước khi tạo phòng"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              // Create room request
                              ref.read(createRoomViewModel.notifier).createRoom(
                                  CreateRoomRequest(
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
                                    hotelId: currentHotelId,
                                    serviceIds: selectedServiceIds,
                                  )
                              );
                            },
                          ),
                          const SizedBox(height: 30), // Extra space at bottom
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Loading overlay
              if (createRoomState.status.isLoading)
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