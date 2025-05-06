import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_app/common/state/compare_room_state.dart';
import 'package:hotel_app/common/utils/service_text_util.dart';
import 'package:hotel_app/features/main/presentation/ui/bottom_bar_navigation.dart';
import 'package:hotel_app/features/room_details/presentation/provider/room_details_provider.dart';
import 'package:hotel_app/features/room_details/presentation/ui/widgets/app_bar_custom.dart';
import 'package:hotel_app/features/room_details/presentation/ui/widgets/mini_room_card.dart';
import 'package:hotel_app/features/room_details/presentation/ui/widgets/review_list.dart';

class RoomDetailsScreen extends ConsumerStatefulWidget {
  final roomId;
  const RoomDetailsScreen({super.key, required this.roomId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _RoomDetailsScreenState();
  }
}

class _RoomDetailsScreenState extends ConsumerState<RoomDetailsScreen> {
  bool hasFetched = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roomDetailsState = ref.watch(roomDetailsViewModel);
    double screenWidth = MediaQuery.of(context).size.width;

    if (!hasFetched) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(roomDetailsViewModel.notifier).getRoomDetails(widget.roomId);
      });
      hasFetched = true;
    }

    return Scaffold(
      bottomNavigationBar: BottomBarNavigation(),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                      height: 250,
                      child: roomDetailsState.when(
                        loading: () {
                          print("Loading...");
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        error: (error) {
                          print("Error: $error");
                          return Center(child: Text(error.toString()));
                        },
                        success: (data) {
                          return PageView.builder(
                            itemCount: data.roomImgs?.length ?? 0,
                            itemBuilder: (context, index) {
                              return Image.network(
                                data.roomImgs![index],
                                fit: BoxFit.cover,
                              );
                            },
                          );
                        },
                        orElse: () {
                          print("Other state");
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      )),
                  AppBarCustom(
                    roomId: widget.roomId,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: roomDetailsState.when(
                  orElse: () =>
                      const Center(child: CircularProgressIndicator()),
                  success: (data) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.hotelName ?? "",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data.roomName ?? "",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Colors.brown, size: 20),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              data.address ?? "",
                              style: TextStyle(color: Colors.brown),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        data.description ?? "",
                        style: TextStyle(color: Colors.brown),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Dịch vụ:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Replace Row with Wrap
                      Wrap(
                        spacing: 8.0, // Horizontal spacing between items
                        runSpacing: 12.0, // Vertical spacing between lines
                        children: data.services!.map((service) {
                          return Row(
                            mainAxisSize: MainAxisSize
                                .min, // Important! Makes each Row take minimum space
                            children: [
                              SvgPicture.asset(
                                'icons/services/${serviceTextUtil(service)}.svg',
                                width: 30,
                                height: 30,
                                colorFilter: const ColorFilter.mode(
                                    Colors.brown, BlendMode.srcIn),
                              ),
                              const SizedBox(
                                  width: 4), // Changed from height to width
                              Text(
                                service,
                                style: TextStyle(color: Colors.brown),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Bảng giá:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Table(
                        border: TableBorder.all(color: Colors.brown),
                        children: [
                          const TableRow(
                            decoration: BoxDecoration(color: Color(0xFFF3E5AB)),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Loại',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Giá',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Combo 2h',
                                    textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(data.comboPrice2h.toString(),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                    Text('1 đêm', textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(data.pricePerNight.toString(),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Thêm giờ',
                                    textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(data.extraHourPrice.toString(),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Đánh giá:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ReviewList(
                        reviews: data.reviews!,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Visibility(
          visible: ref.watch(compareRoomIdProvider) != 0 &&
              ref.watch(compareRoomIdProvider) != widget.roomId,
          child: Positioned(
            bottom: 20,
            right: 0,
            child: MiniRoomCard(
                roomId: ref.watch(compareRoomIdProvider),
                width: screenWidth * 0.45),
          ),
        ),
      ]),
    );
  }
}
