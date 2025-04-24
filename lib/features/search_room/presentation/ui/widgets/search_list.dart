import 'package:flutter/material.dart';
import 'package:hotel_app/features/search_room/presentation/ui/widgets/search_item.dart';
import 'package:hotel_app/features/search_room/model/search.dart';

class SearchList extends StatelessWidget {
  final List<Search> list;

  const SearchList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (Search search in list)
          SearchItem(
            title: search.title,
            type: search.type,
          ),
      ],
    );
  }
}
