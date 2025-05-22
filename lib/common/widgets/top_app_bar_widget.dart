import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_app/features/booking/booking_screen.dart';
import 'package:hotel_app/features/search_room/presentation/ui/search_room_screen.dart';

class TopAppBarWidget extends StatefulWidget {
  const TopAppBarWidget({super.key});

  @override
  State<TopAppBarWidget> createState() => _TopAppBarWidgetState();
}

class _TopAppBarWidgetState extends State<TopAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 412,
          height: 284,
          child: Transform.translate(
            offset: const Offset(0, -90),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 412,
                    height: 284,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/anh-phong-07.jpg"),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0,
                          color: Color(0xFFD9D9D9),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  top: 194,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchRoomScreen(isFiltered: 0),
                        ),
                      );
                    },
                    child: Container(
                      width: 306,
                      height: 62,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0,
                            color: Color(0xFFD9D9D9),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            SvgPicture.string(
                              '''
                              <svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
                              <path d="M34.2983 34.2983L28.0181 28.0181M27.1209 14.5604C27.1209 16.2099 26.796 17.8432 26.1648 19.3671C25.5336 20.891 24.6084 22.2757 23.442 23.442C22.2757 24.6084 20.891 25.5336 19.3671 26.1648C17.8432 26.796 16.2099 27.1209 14.5604 27.1209C12.911 27.1209 11.2777 26.796 9.75377 26.1648C8.22987 25.5336 6.84522 24.6084 5.67887 23.442C4.51252 22.2757 3.58733 20.891 2.95611 19.3671C2.32489 17.8432 2 16.2099 2 14.5604C2 11.2292 3.32333 8.03441 5.67887 5.67887C8.03441 3.32333 11.2292 2 14.5604 2C17.8917 2 21.0865 3.32333 23.442 5.67887C25.7976 8.03441 27.1209 11.2292 27.1209 14.5604Z" stroke="#65462D" stroke-width="3" stroke-linecap="round"/>
                              </svg>
                              ''',
                              width: 40,
                              height: 40,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Text(
                                  'Tìm kiếm',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Color(0xFF65462D),
                                    fontSize: 25,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 338,
                  top: 194,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchRoomScreen(isFiltered: 1),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 62,
                      height: 62.14,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: Color(0xFFD9D9D9),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          // child: SvgPicture.string(
                          //   '''
                          //   <svg width="32" height="30" viewBox="0 0 32 30" fill="none" xmlns="http://www.w3.org/2000/svg">
                          //   <path d="..." stroke="#D9D9D9" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round"/>
                          //   </svg>
                          //   ''',
                          //   width: 32,
                          //   height: 30,
                          // ),
                          child:
                              Icon(Icons.tune, size: 32, color: Colors.brown)),
                    ),
                  ),
                ),
                Positioned(
                  left: 80,
                  top: 131.61,
                  child: SizedBox(
                    width: 172,
                    height: 41.77,
                    child: Text(
                      'BOOKING_N15',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 13.73,
                  top: 123.74,
                  child: Container(
                    width: 58.54,
                    height: 58.54,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/logo_home.png"),
                        fit: BoxFit.cover,
                      ),
                      shape: OvalBorder(
                        side: BorderSide(
                          width: 1,
                          color: Color(0xFFD9D9D9),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
