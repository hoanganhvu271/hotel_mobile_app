import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_app/features/search_room/model/search_request.dart';
import 'package:hotel_app/features/search_room/presentation/provider/room_search_provider.dart';
import 'package:hotel_app/features/search_room/presentation/state/search_request_state.dart';
import 'package:hotel_app/features/search_room/presentation/ui/search_list_screen.dart';

class SearchItem extends ConsumerWidget {
  final String type;
  final String title;

  SearchRequest request = SearchRequest(
    keyword: "",
    city: "",
    district: "",
    numOfAdult: 0,
    numOfChild: 0,
    numOfBed: 0,
    services: [],
  );

  SearchItem({
    Key? key,
    required this.title,
    required this.type,
  })  : assert(type == "hot" || type == "history" || type == "none"),
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        ref.read(searchRequestState.notifier).state.keyword = title;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SearchListScreen(searchRequest: ref.watch(searchRequestState)),
          ),
        );
      },
      child: Container(
        width: screenWidth,
        height: 55,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFF65462D),
              width: 1,
            ),
            top: BorderSide(
              color: const Color(0xFF65462D),
              width: 1,
            ),
          ),
        ),
        child: Row(children: [
          SizedBox(width: 20),
          if (type == "hot")
            SvgPicture.asset(
              'assets/icons/hot.svg',
              width: 20,
              height: 20,
            ),
          if (type == "history")
            SvgPicture.asset(
              'assets/icons/history.svg',
              width: 20,
              height: 20,
            ),
          if (type == "none")
            SizedBox(
              width: 25,
            ),
          SizedBox(width: 20),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF65462D),
            ),
          ),
        ]),
      ),
    );
  }
}
