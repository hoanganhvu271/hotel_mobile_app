import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_response.dart';
import 'package:hotel_app/features/search_room/data/search_entry_service.dart';
import 'package:hotel_app/features/search_room/model/search_entry.dart';

final searchEntryRepository = Provider<SearchEntryRepository>(
  (ref) => SearchEntryRepositoryImpl(
      searchEntryService: ref.watch(searchEntryService)),
);

abstract class SearchEntryRepository {
  Future<BaseResponse<List<SearchEntry>>> getSearchEntries(String query);
}

class SearchEntryRepositoryImpl implements SearchEntryRepository {
  final SearchEntryService searchEntryService;

  SearchEntryRepositoryImpl({required this.searchEntryService});

  @override
  Future<BaseResponse<List<SearchEntry>>> getSearchEntries(String query) async {
    return await searchEntryService.getSearchEntries(query);
  }
}
