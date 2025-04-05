import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_app/features/admin/presentation/ui/admin_screen.dart';
import 'package:hotel_app/features/admin/presentation/ui/room_form_screen.dart';
import '../../../../models/room.dart';

class RoomManagerScreen extends StatelessWidget {
  const RoomManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Column(
          children: [
            const TopAppBar(title: "Danh sách phòng"),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
              child: SearchBoxWidget(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.separated(
                  itemBuilder: (_, index) => RoomItemWidget(
                    room: Room(
                      roomId: 1,
                      hotelId: 1,
                      roomName: "Phòng 1",
                      area: 20.0,
                      pricePerHour: 100000,
                      pricePerNight: 200000,
                      extraHourPrice: 50000,
                      standardOccupancy: 2,
                      maxOccupancy: 4,
                      numChildrenFree: 1,
                      availableRoom: 5,
                      roomImg: "assets/images/room_img.png",
                      bedNumber: 2,
                      timeCreated: DateTime.now(),
                    ),
                  ),
                  itemCount: 10,
                  separatorBuilder: (_, index) => const SizedBox(height: 14),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBoxWidget extends StatefulWidget {
  const SearchBoxWidget({super.key});

  @override
  State<SearchBoxWidget> createState() => _SearchBoxWidgetState();
}

class _SearchBoxWidgetState extends State<SearchBoxWidget> {
  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _isFocused ? Colors.blue : Colors.transparent,
          width: 2,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: "Tìm kiếm theo tên ...",
          hintStyle: const TextStyle(
            fontSize: 16,
            color: Color(0xFFD9D9D9),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10),
            child: ClipOval(
              child: SvgPicture.asset(
                "assets/icons/icon_search.svg",
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          suffixIcon: GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipOval(
                child: SvgPicture.asset(
                  "assets/icons/icon_filter.svg",
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      )
      ,
    );
  }
}

class RoomItemWidget extends StatelessWidget {
  final Room room;

  const RoomItemWidget({
    super.key,
    required this.room
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        highlightColor: const Color.fromRGBO(0, 0, 0, 0.2),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RoomFormScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // replace with CacheNetworkImage later ...
              Image.asset(
                room.roomImg,
                width: 130,
                height: 130,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 27),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.roomName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text("ID: #${room.roomId}"),
                    const SizedBox(height: 5),
                    Text("Giá: ${room.pricePerHour} đ/giờ"),
                    const SizedBox(height: 5),
                    Text("Diện tích: ${room.area} m2"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
