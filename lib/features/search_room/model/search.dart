import 'package:hotel_app/features/search_room/model/search_entry.dart';

class Search {
  String title;
  String type;

  Search({
    required this.title,
    required this.type,
  }) : assert(type == "hot" || type == "history");

  Search.fromSearchEntry(SearchEntry searchEntry)
      : title = searchEntry.value,
        type = "history";
}
