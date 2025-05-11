import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/search_room/model/search_request.dart';
import 'package:hotel_app/features/search_room/presentation/state/search_request_state.dart';

extension SearchRequestRefExtension on WidgetRef {
  // Getter
  SearchRequest get searchRequest => watch(searchRequestState);

  // Setter cho từng trường
  void setKeyword(String value) {
    read(searchRequestState.notifier).state =
        searchRequest.copyWith(keyword: value);
  }

  void setCity(String value) {
    if (value == 'Tất cả') {
      value = '';
    }
    read(searchRequestState.notifier).state =
        searchRequest.copyWith(city: value);
  }

  void setDistrict(String value) {
    if (value == 'Tất cả') {
      value = '';
    }
    read(searchRequestState.notifier).state =
        searchRequest.copyWith(district: value);
  }

  void setNumOfAdult(int value) {
    read(searchRequestState.notifier).state =
        searchRequest.copyWith(numOfAdult: value);
  }

  void setNumOfBed(int value) {
    read(searchRequestState.notifier).state =
        searchRequest.copyWith(numOfBed: value);
  }

  void setNumOfChild(int value) {
    read(searchRequestState.notifier).state =
        searchRequest.copyWith(numOfChild: value);
  }

  void setServices(List<String> value) {
    read(searchRequestState.notifier).state =
        searchRequest.copyWith(services: value);
  }

  void resetSearchRequest() {
    read(searchRequestState.notifier).state = SearchRequest(
      keyword: ' ',
      city: '',
      district: '',
      numOfAdult: 0,
      numOfBed: 0,
      numOfChild: 0,
      services: [],
    );
  }

  void validateSearchRequest() {
    final currentRequest = read(searchRequestState.notifier).state;

    // Check for null values and set them to empty strings
    final String safeCity = currentRequest.city ?? '';
    final String safeDistrict = currentRequest.district ?? '';

    // Only update if a change was necessary
    if (currentRequest.city != safeCity ||
        currentRequest.district != safeDistrict) {
      read(searchRequestState.notifier).state = currentRequest.copyWith(
        city: safeCity,
        district: safeDistrict,
      );
    }
  }
}
