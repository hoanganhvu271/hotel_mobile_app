import 'package:flutter/material.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/search_box_widget.dart';
import 'package:hotel_app/features/admin/presentation/ui/partials/top_app_bar.dart';


class ReservationManagerScreen extends StatelessWidget {
  const ReservationManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Material(
          child: Column(
            children: [
              const TopAppBar(title: "Danh sách đặt phòng"),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: SearchBoxWidget(),
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.separated(
                        itemBuilder: (_, index) => const ReservationItem(),
                        itemCount: 10,
                        separatorBuilder: (_, index) => Container(
                          height: 3,
                          color: const Color(0xFFD9D9D9),
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
  final String roomName;
  final String reservationId;
  final String customerName;
  final String phoneNumber;
  final String checkInDate;
  final String checkOutDate;
  final String status;

  const ReservationItem({
    super.key,
    this.roomName = "Phòng 1",
    this.reservationId = "1",
    this.customerName = "Nguyễn Văn A",
    this.phoneNumber = "0123456789",
    this.checkInDate = "2023-10-01",
    this.checkOutDate = "2023-10-02",
    this.status = "Đã xác nhận",
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        highlightColor: const Color.fromRGBO(0, 0, 0, 0.2),
        onTap: () {
          // Handle item tap
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
                  Text(roomName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  Text("ID: $reservationId", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                ],
              ),
              Text(customerName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              Text(phoneNumber, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Checkin: $checkInDate", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                  Text("Checkout: $checkOutDate", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                ],
              ),
              Text("Trạng thái: $status"),
            ],
          ),
        ),
      ),
    );
  }
}
