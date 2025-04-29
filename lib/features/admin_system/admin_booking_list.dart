import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_app/common/widgets/heading.dart';
import 'package:hotel_app/features/admin_system/model/revenue_model.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatelessWidget {
  final List<BookingDetail> bookingDetails;

  const BookingPage({super.key, required this.bookingDetails});

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('hh:MM dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final appBarColor = Color(0xFF65462D);

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              const Heading(title: 'QUẢN LÝ KHÁCH SẠN'),
              Positioned(
                left: 20,
                top: 22,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          Expanded(
            child: bookingDetails.isEmpty
                ? Center(
              child: Text(
                'Không có đặt phòng nào.',
                style: textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.all(12.0),
              itemCount: bookingDetails.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final booking = bookingDetails[index];

                return Card(
                  elevation: 3,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking ID: ${booking.bookingId}',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF65462D)
                          ),
                        ),
                        const Divider(height: 20, thickness: 1),

                        _buildInfoRow(Icons.meeting_room_outlined, 'Phòng:', booking.roomName, textTheme),
                        _buildInfoRow(Icons.person_outline, 'Khách hàng:', booking.fullName, textTheme),
                        _buildInfoRow(Icons.phone_outlined, 'Điện thoại:', booking.phone, textTheme),
                        _buildInfoRow(Icons.calendar_today_outlined, 'Check-in:', _formatDate(booking.checkIn), textTheme),
                        _buildInfoRow(Icons.calendar_today_outlined, 'Check-out:', _formatDate(booking.checkOut), textTheme),
                        _buildInfoRow(Icons.payments_outlined, 'Giá:', currencyFormatter.format(booking.price), textTheme, valueColor: Colors.green[700]),
                        _buildInfoRow(Icons.access_time, 'Ngày tạo:', _formatDate(booking.createAt), textTheme),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, TextTheme textTheme, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Text(
            '$label ',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(color: valueColor ?? textTheme.bodyMedium?.color),
            ),
          ),
        ],
      ),
    );
  }
}