import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_app/features/booking/booking_screen.dart';

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
                          builder: (context) => BookingScreen(),
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
                      child: SvgPicture.string(
                        '''
                        <svg width="32" height="30" viewBox="0 0 32 30" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M30.5094 15.0162H10.8019M3.84566 15.0162H1M3.84566 15.0162C3.84566 14.0939 4.21202 13.2094 4.86415 12.5573C5.51627 11.9052 6.40074 11.5388 7.32298 11.5388C8.24523 11.5388 9.1297 11.9052 9.78182 12.5573C10.4339 13.2094 10.8003 14.0939 10.8003 15.0162C10.8003 15.9384 10.4339 16.8229 9.78182 17.475C9.1297 18.1271 8.24523 18.4935 7.32298 18.4935C6.40074 18.4935 5.51627 18.1271 4.86415 17.475C4.21202 16.8229 3.84566 15.9384 3.84566 15.0162ZM30.5094 25.555H21.3407M21.3407 25.555C21.3407 26.4775 20.9735 27.3629 20.3212 28.0152C19.6689 28.6675 18.7843 29.0339 17.8618 29.0339C16.9396 29.0339 16.0551 28.666 15.403 28.0138C14.7509 27.3617 14.3845 26.4772 14.3845 25.555M21.3407 25.555C21.3407 24.6325 20.9735 23.7487 20.3212 23.0964C19.6689 22.4441 18.7843 22.0777 17.8618 22.0777C16.9396 22.0777 16.0551 22.444 15.403 23.0962C14.7509 23.7483 14.3845 24.6328 14.3845 25.555M14.3845 25.555H1M30.5094 4.47732H25.5566M18.6004 4.47732H1M18.6004 4.47732C18.6004 3.55508 18.9667 2.67061 19.6188 2.01848C20.271 1.36636 21.1554 1 22.0777 1C22.5343 1 22.9865 1.08994 23.4084 1.2647C23.8303 1.43945 24.2136 1.69558 24.5365 2.01848C24.8594 2.34138 25.1155 2.72472 25.2903 3.14661C25.4651 3.5685 25.555 4.02067 25.555 4.47732C25.555 4.93397 25.4651 5.38615 25.2903 5.80804C25.1155 6.22992 24.8594 6.61326 24.5365 6.93616C24.2136 7.25906 23.8303 7.5152 23.4084 7.68995C22.9865 7.8647 22.5343 7.95464 22.0777 7.95464C21.1554 7.95464 20.271 7.58828 19.6188 6.93616C18.9667 6.28403 18.6004 5.39956 18.6004 4.47732Z" stroke="#D9D9D9" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round"/>
                        </svg>
                        ''',
                        width: 32,
                        height: 30,
                      ),
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
