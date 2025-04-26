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
    // Define formatters once
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
          // Body contains the list of bookings
          Expanded(
            child: bookingDetails.isEmpty
                ? Center( // Show a message if the list is empty
              child: Text(
                'Không có đặt phòng nào.',
                style: textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              ),
            )
                : ListView.separated( // Use separated for dividers between cards
              padding: const EdgeInsets.all(12.0), // Padding around the entire list
              itemCount: bookingDetails.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10), // Space between cards
              itemBuilder: (context, index) {
                final booking = bookingDetails[index];

                return Card(
                  elevation: 3, // Softer shadow
                  margin: EdgeInsets.zero, // ListView.separated handles spacing
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Slightly more rounded corners
                  ),
                  clipBehavior: Clip.antiAlias, // Clips content to rounded corners
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Padding inside the card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Booking ID - Prominent
                        Text(
                          'Booking ID: ${booking.bookingId}',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF65462D)
                          ),
                        ),
                        const Divider(height: 20, thickness: 1), // Visual separator

                        // Use helper widget for info rows for consistency
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

  // Helper widget to create consistent info rows with icons
  Widget _buildInfoRow(IconData icon, String label, String value, TextTheme textTheme, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0), // Spacing between rows
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top if text wraps
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]), // Icon for the row
          const SizedBox(width: 10),
          Text(
            '$label ',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]), // Slightly bolder label
          ),
          Expanded( // Allows value text to wrap
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(color: valueColor ?? textTheme.bodyMedium?.color),
              // softWrap: true, // Ensures text wraps
            ),
          ),
        ],
      ),
    );
  }
}