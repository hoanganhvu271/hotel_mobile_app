import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base_state.dart';
import '../../data/hotel_owner_repository.dart';
import '../../model/booking_dto.dart';
import '../../model/booking_stats_dto.dart';
import '../../model/search_data.dart';


final bookingViewModel = AutoDisposeNotifierProvider<BookingProvider, SearchData<BookingResponseDto>>(() => BookingProvider());

class BookingProvider extends AutoDisposeNotifier<SearchData<BookingResponseDto>> {
  @override
  SearchData<BookingResponseDto> build() {
    state = SearchData(status: BaseStatus.none);
    getData();
    return state;
  }

  Future<void> refresh() async {
    state = SearchData(status: BaseStatus.none);
    await getData();
  }

  Future<void> getData() async {
    print(state.filterStatus);
    try {
      if (state.page == 0) {
        state = state.copyWith(status: BaseStatus.loading, canLoadMore: true, filterStatus: state.filterStatus);
      }

      print("Fetching bookings with filter status: ${state.filterStatus}");

      final response = await ref.read(hotelOwnerRepository).getAllBookings(
        offset: state.page * state.limit,
        limit: state.limit,
        order: state.order,
        query: state.query,
        status: state.filterStatus,
      );

      if (response.isSuccessful) {
        final List<BookingResponseDto> bookings = response.successfulData!;

        if (bookings.length < state.limit) {
          state = state.copyWith(canLoadMore: false);
        }

        final currentList = state.listData;
        final resultList = state.page == 0 ? bookings : [...currentList, ...bookings];

        state = state.copyWith(
          status: BaseStatus.success,
          listData: resultList,
          page: state.page + 1,
        );

      } else {
        state = state.copyWith(status: BaseStatus.error);
      }
    } catch (e) {
      state = state.copyWith(
        status: BaseStatus.error,
      );
    }
  }

  Future<void> setSearchState({
    String? query,
    String? order,
    int? startDate,
    int? endDate,
    int? page,
    int? limit,
    String? filterStatus, // Thêm tham số filterStatus để lọc
  }) async {
    state = state.copyWith(
      query: query ?? state.query,
      order: order ?? state.order,
      startDate: startDate ?? state.startDate,
      endDate: endDate ?? state.endDate,
      page: page ?? 0,
      limit: limit ?? state.limit,
      filterStatus: filterStatus,
    );
    getData();
  }

  Future<void> loadMore() async {
    if (state.canLoadMore) {
      await getData();
    }
  }

  void changeSort() {
    if (state.order == "desc") {
      state = state.copyWith(order: "asc", page: 0);
    } else {
      state = state.copyWith(order: "desc", page: 0);
    }
    getData();
  }
}