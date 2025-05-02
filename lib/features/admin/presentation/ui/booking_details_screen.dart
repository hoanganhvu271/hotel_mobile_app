import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/utils/time_util.dart';
import 'package:hotel_app/constants/app_colors.dart';
import 'package:hotel_app/features/admin/model/booking_status.dart';
import 'package:hotel_app/features/admin/presentation/provider/update_booking_status.dart';
import '../provider/booking_details_provider.dart';

class BookingDetailsScreen extends ConsumerStatefulWidget {
  final int id;

  const BookingDetailsScreen({super.key, required this.id});

  @override
  ConsumerState<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends ConsumerState<BookingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingDetailsViewModel.notifier).getData(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingDetailsViewModel);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Chi tiết đặt phòng", style: TextStyle(color: Colors.white),),
        backgroundColor: ColorsLib.primaryBoldColor,
      ),
      body: state.when(
        orElse: () => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
        success: (data) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Mã đặt phòng: ${data.bookingId}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("Phòng: ${data.roomName}"),
                    Text("Nhận phòng: ${TimeUtils.formatDateTime(data.checkIn)}"),
                    Text("Trả phòng: ${TimeUtils.formatDateTime(data.checkOut)}"),
                    Text("Giá: \$${data.price.toStringAsFixed(2)}"),
                    Text("Trạng thái: ${data.status}"),

                    const Divider(height: 32),

                    const Text("Thông tin người dùng", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text("Họ tên: ${data.user.fullName ?? "Không có"}"),
                    Text("Email: ${data.user.email ?? "Không có"}"),
                    Text("Số điện thoại: ${data.user.phone ?? "Không có"}"),

                    const Divider(height: 32),

                    const Text("Thông tin hóa đơn", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    if (data.bill != null) ...[
                      Text("Mã hóa đơn: ${data.bill?.billId}"),
                      Text("Tổng tiền: \$${data.bill?.totalPrice.toStringAsFixed(2)}"),
                      Text("Đã thanh toán: ${data.bill!.paidStatus ? "Có" : "Chưa"}"),
                    ] else
                      const Text("Chưa có hóa đơn"),

                    const Divider(height: 32),

                    Text("Ngày tạo: ${TimeUtils.formatDateTime(data.createdAt)}"),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => ref.read(updateBookingStatusViewModel.notifier).update(BookingStatus.CANCELLED),
                          icon: const Icon(Icons.cancel),
                          label: const Text("Từ chối"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => ref.read(updateBookingStatusViewModel.notifier).update(BookingStatus.CONFIRMED),
                          icon: const Icon(Icons.check_circle),
                          label: const Text("Chấp nhận"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
