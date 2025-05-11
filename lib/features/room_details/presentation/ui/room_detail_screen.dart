import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_app/common/state/compare_room_state.dart';
import 'package:hotel_app/common/utils/service_text_util.dart';
import 'package:hotel_app/common/utils/text_util.dart';
import 'package:hotel_app/features/booking/model/booking_search_request.dart';
import 'package:hotel_app/features/main/presentation/ui/bottom_bar_navigation.dart';
import 'package:hotel_app/features/room_details/model/review.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool isScrolled = false;
  double _miniCardTop = 500;
  double _miniCardRight = 0;
  final double _miniCardWidthFraction = 0.45;
  final GlobalKey _miniCardKey = GlobalKey();

  double calculateRatingAvg(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    double totalRating = 0.0;
    for (var review in reviews) {
      totalRating += review.rating ?? 0.0;
    }
    return totalRating / reviews.length;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !isScrolled) {
        setState(() {
          isScrolled = true;
        });
      } else if (_scrollController.offset <= 200 && isScrolled) {
        setState(() {
          isScrolled = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roomDetailsState = ref.watch(roomDetailsViewModel);
    // double screenWidth = MediaQuery.of(context).size.width;

    // List<int> comparePrice = [];
    // List<String> getServicesNotInOther = [];

    final compareRoom = ref.watch(compareRoomProvider);
    print(compareRoom);

    Color getPriceColor(double price, double? comparePrice) {
      if (compareRoom.roomId == null || comparePrice == null)
        return Colors.black;
      if (price > comparePrice!) {
        return Colors.red;
      } else if (price < comparePrice!) {
        return Colors.green;
      }

      return Colors.black;
    }

    bool isServiceInCompareRoom(String service) {
      if (compareRoom.roomId == null) return true;
      if (compareRoom.services == null) return true;
      return compareRoom.services?.contains(service) ?? false;
    }

    if (!hasFetched) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(roomDetailsViewModel.notifier).getRoomDetails(widget.roomId);

        final context = _miniCardKey.currentContext;
        if (context != null) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final size = box.size;
          print('Chiều rộng: ${size.width}');
          print('Chiều cao: ${size.height}');
        }

        hasFetched = true;
      });
    }

    return roomDetailsState.when(
      orElse: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error) => Scaffold(
        body: Center(child: Text('Lỗi: $error')),
      ),
      success: (data) => Scaffold(
        bottomNavigationBar: BottomBarNavigation(),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 250,
                        child: PageView.builder(
                          itemCount: data.roomImgs?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Image.network(
                              data.roomImgs![index],
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.hotelName ?? "",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.roomName ?? "",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.brown, size: 20),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                data.address ?? "",
                                style: const TextStyle(color: Colors.brown),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data.description ?? "",
                          style: const TextStyle(color: Colors.brown),
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
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 12.0,
                          children: data.services!.map((service) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'icons/services/${serviceTextUtil(service)}.svg',
                                  width: 30,
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                      isServiceInCompareRoom(service)
                                          ? Colors.brown
                                          : Colors.green,
                                      BlendMode.srcIn),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  service,
                                  style: TextStyle(
                                    color: isServiceInCompareRoom(service)
                                        ? Colors.brown
                                        : Colors.green,
                                  ),
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
                              decoration:
                                  BoxDecoration(color: Color(0xFFF3E5AB)),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Loại',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Giá',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Combo 2h',
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${convertPriceToString(data.comboPrice2h!)} VNĐ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: getPriceColor(data.comboPrice2h!,
                                            compareRoom.comboPrice2h),
                                      ),
                                    )),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('1 đêm',
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${convertPriceToString(data.pricePerNight!)} VNĐ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: getPriceColor(data.pricePerNight!,
                                          compareRoom.pricePerNight),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Thêm giờ',
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${convertPriceToString(data.extraHourPrice!)} VNĐ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: getPriceColor(data.extraHourPrice!,
                                          compareRoom.extraHourPrice),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 10.0),
                          width: double
                              .infinity, // Chiếm toàn bộ chiều rộng có sẵn
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'Đặt phòng',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text(
                              'Đánh giá:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.brown,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.brown,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                calculateRatingAvg(data.reviews!)
                                    .toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${data.reviews!.length} đánh giá)',
                              style: const TextStyle(
                                  color: Colors.brown,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ReviewList(reviews: data.reviews!)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: _miniCardTop,
              right: _miniCardRight,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _miniCardTop += details.delta.dy;
                    _miniCardRight -= details.delta.dx;

                    final mediaQuery = MediaQuery.of(context);
                    final screenHeight =
                        mediaQuery.size.height - mediaQuery.padding.top - 180;
                    final screenWidth = mediaQuery.size.width;

                    final renderBox = _miniCardKey.currentContext
                        ?.findRenderObject() as RenderBox?;
                    final cardSize = renderBox?.size;

                    final cardHeight = cardSize?.height ?? 200.0; // fallback
                    final cardWidth = cardSize?.width ??
                        (screenWidth * _miniCardWidthFraction);

                    _miniCardTop =
                        _miniCardTop.clamp(0.0, screenHeight - cardHeight);
                    _miniCardRight =
                        _miniCardRight.clamp(0.0, screenWidth - cardWidth);
                  });
                },
                onPanEnd: (details) {
                  double screenWidth = MediaQuery.of(context).size.width;
                  double cardWidth = screenWidth * _miniCardWidthFraction;

                  setState(() {
                    // Nếu gần bên trái hơn => snap vào trái (right = screenWidth - cardWidth)
                    // Nếu gần bên phải hơn => snap vào phải (right = 0)
                    if (_miniCardRight < (screenWidth - cardWidth) / 2) {
                      _miniCardRight = 0; // Snap vào phải
                    } else {
                      _miniCardRight = screenWidth - cardWidth; // Snap vào trái
                    }
                  });
                },
                child: MiniRoomCard(
                  width: MediaQuery.of(context).size.width *
                      _miniCardWidthFraction,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBarCustom(
                roomId: widget.roomId,
                isScrolled: isScrolled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
