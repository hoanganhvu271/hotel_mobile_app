import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/search_room/model/search_request.dart';

final searchRequestState = StateProvider((ref) => SearchRequest(
      keyword: ' ',
      city: '',
      district: '',
      numOfAdult: 0,
      numOfBed: 0,
      numOfChild: 0,
      services: [],
    ));
