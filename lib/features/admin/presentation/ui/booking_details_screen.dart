import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/utils/time_util.dart';
import 'package:hotel_app/constants/app_colors.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/admin/model/booking_status.dart';
import 'package:hotel_app/features/admin/presentation/provider/update_booking_status.dart';
import '../../../../common/utils/value_utils.dart';
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

  // Hiển thị xác nhận trước khi gửi API
  void _showConfirmationDialog(BuildContext context, BookingStatus status, String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Xác nhận $action đặt phòng",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text("Bạn có chắc muốn $action đặt phòng này không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: status == BookingStatus.CONFIRMED
                    ? Colors.green
                    : Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(updateBookingStatusViewModel.notifier).update(widget.id, status);
              },
              child: Text("Đồng ý"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    IconData icon;

    switch (status) {
      case 'CONFIRMED':
        bgColor = Colors.green.shade100;
        icon = Icons.check_circle;
        break;
      case 'CANCELLED':
        bgColor = Colors.red.shade100;
        icon = Icons.cancel;
        break;
      default:
        bgColor = Colors.orange.shade100;
        icon = Icons.pending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: bgColor.withOpacity(0.8).computeLuminance() < 0.5 ? Colors.white : Colors.black87),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: bgColor.withOpacity(0.8).computeLuminance() < 0.5 ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingDetailsViewModel);
    final updateState = ref.watch(updateBookingStatusViewModel);

    // Hiển thị thông báo khi cập nhật trạng thái thành công
    ref.listen(updateBookingStatusViewModel, (previous, current) {
      if (previous?.status != current.status && current.status.isSuccess) {
        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cập nhật trạng thái thành công"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        );

        // Làm mới dữ liệu
        ref.read(bookingDetailsViewModel.notifier).getData(widget.id);
      } else if (previous?.status != current.status && current.status.isError) {
        // Hiển thị thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lỗi: ${current.message}"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Chi tiết đặt phòng",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ColorsLib.primaryBoldColor,
      ),
      body: state.when(
        orElse: () => const SizedBox.shrink(),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        success: (data) {
          final bool isCompleted = data.status == "CONFIRMED" || data.status == "CANCELLED";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Booking ID and Status
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ColorsLib.primaryColor, ColorsLib.primaryBoldColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsLib.primaryColor.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Mã đặt phòng",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          _buildStatusBadge(data.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "#${data.bookingId}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(
                              TimeUtils.formatDateOnly(data.createdAt),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Room Information
                _buildInfoSection(
                  "Thông tin phòng",
                  [
                    _buildInfoRow("Phòng:", data.roomName),
                    _buildInfoRow("Nhận phòng:", TimeUtils.formatDateTime(data.checkIn)),
                    _buildInfoRow("Trả phòng:", TimeUtils.formatDateTime(data.checkOut)),
                    _buildInfoRow("Giá:", "${ValueUtils.formatCurrency(data.price)}"),
                  ],
                ),

                // Customer Information
                _buildInfoSection(
                  "Thông tin khách hàng",
                  [
                    _buildInfoRow("Họ tên:", data.user.fullName ?? "Không có"),
                    _buildInfoRow("Email:", data.user.email ?? "Không có"),
                    _buildInfoRow("Số điện thoại:", data.user.phone ?? "Không có"),
                  ],
                ),

                // Bill Information
                _buildInfoSection(
                  "Thông tin hóa đơn",
                  [
                    if (data.bill != null) ...[
                      _buildInfoRow("Mã hóa đơn:", "#${data.bill?.billId}"),
                      _buildInfoRow("Tổng tiền:", "${ValueUtils.formatCurrency(data.bill?.totalPrice ?? 0)}"),
                      _buildInfoRow(
                        "Thanh toán:",
                        data.bill!.paidStatus ? "Đã thanh toán" : "Chưa thanh toán",
                      ),
                    ] else
                      const Text(
                        "Chưa có hóa đơn",
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                      ),
                  ],
                ),

                // Action Buttons
                if (!isCompleted && !updateState.status.isLoading)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _showConfirmationDialog(context, BookingStatus.CANCELLED, "từ chối"),
                            icon: const Icon(Icons.cancel),
                            label: const Text(
                              "Từ chối đặt phòng",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _showConfirmationDialog(context, BookingStatus.CONFIRMED, "chấp nhận"),
                            icon: const Icon(Icons.check_circle),
                            label: const Text(
                              "Chấp nhận đặt phòng",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Loading indicator
                if (updateState.status.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: CircularProgressIndicator(),
                    ),
                  ),

                // Status completed message
                if (isCompleted)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                      color: data.status == "CONFIRMED" ? Colors.green.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: data.status == "CONFIRMED" ? Colors.green.shade200 : Colors.red.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          data.status == "CONFIRMED" ? Icons.check_circle : Icons.cancel,
                          color: data.status == "CONFIRMED" ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            data.status == "CONFIRMED"
                                ? "Đặt phòng đã được xác nhận"
                                : "Đặt phòng đã bị từ chối",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: data.status == "CONFIRMED" ? Colors.green.shade700 : Colors.red.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
        error: (errorMessage) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                "Lỗi: $errorMessage",
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref.read(bookingDetailsViewModel.notifier).getData(widget.id);
                },
                child: const Text("Thử lại"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}