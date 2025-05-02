import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/utils/time_util.dart';
import 'package:hotel_app/features/admin/model/booking_dto.dart';
import 'package:hotel_app/features/admin/presentation/provider/booking_provider.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/search_box_widget.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/top_app_bar.dart';

import 'booking_details_screen.dart';


class ReservationManagerScreen extends ConsumerStatefulWidget {
  const ReservationManagerScreen({super.key});

  @override
  ConsumerState<ReservationManagerScreen> createState() => _ReservationManagerScreenState();
}

class _ReservationManagerScreenState extends ConsumerState<ReservationManagerScreen> {

  final ScrollController _scrollController = ScrollController();

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      ref.read(bookingViewModel.notifier).loadMore();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(bookingViewModel);
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Material(
          child: Column(
            children: [
              const TopAppBar(title: "Danh sách đặt phòng"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: SearchBoxWidget(
                  onChange: (text) => ref.read(bookingViewModel.notifier).setSearchState(query: text, page: 0),
                ),
              ),
              Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => ref.read(bookingViewModel.notifier).refresh(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: viewModel.when(
                          emptyData: () => const Center(
                            child: Text(
                              "Không có dữ liệu",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFB1B1B1),
                              ),
                            ),
                          ),
                          success: (data) {
                            return ListView.separated(
                              itemBuilder: (_, index) {
                                if (index == viewModel.listData.length) {

                                  return viewModel.canLoadMore ? const Center(child: CircularProgressIndicator()) : const SizedBox();
                                }
                                else {
                                  return ReservationItem(booking: viewModel.listData[index]);
                                }
                              },
                              itemCount: viewModel.listData.length + 1,
                              separatorBuilder: (_, index) => Container(
                                height: 3,
                                color: const Color(0xFFD9D9D9),
                              ),
                            );
                          },
                          error: (error) => Center(child: Text(error.toString())),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          orElse: () => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReservationItem extends StatelessWidget {
  final BookingResponseDto booking;

  const ReservationItem({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        highlightColor: const Color.fromRGBO(0, 0, 0, 0.2),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => BookingDetailsScreen(id: booking.bookingId!),
          ));
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 6,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(booking.roomName.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  Text("ID: ${booking.bookingId}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                ],
              ),
              Text(booking.user?.fullName ?? "", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              Text(booking.user?.phone ?? "", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              Wrap(
                children: [
                  Text("Checkin: ${TimeUtils.formatDateTime(booking.checkIn!)}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                  Text("Checkout: ${TimeUtils.formatDateTime(booking.checkOut!)}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                ],
              ),
              Text("Trạng thái: ${booking.status}"),
            ],
          ),
        ),
      ),
    );
  }
}
