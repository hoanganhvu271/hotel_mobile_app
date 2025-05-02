import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/admin/model/booking_dto.dart';

import '../../../../core/base_state.dart';
import '../../data/hotel_owner_repository.dart';
import '../../model/booking_stats_dto.dart';
import '../../model/room_response_dto.dart';
import '../../model/search_data.dart';


final roomViewModel = AutoDisposeNotifierProvider<RoomProvider, SearchData<RoomResponseDto>>(() => RoomProvider());

class RoomProvider extends AutoDisposeNotifier<SearchData<RoomResponseDto>> {
  @override
  SearchData<RoomResponseDto> build() {
    state = SearchData(status: BaseStatus.none);
    getData();
    return state;
  }

  Future<void> refresh() async {
    state = SearchData(status: BaseStatus.none);
    await getData();
  }

  Future<void> getData() async {
    try {
      if (state.page == 0) {
        state = state.copyWith(status: BaseStatus.loading, canLoadMore: true);
      }

      final response = await ref.read(hotelOwnerRepository).getAllRooms(
        offset: state.page * state.limit,
        limit: state.limit,
        order: state.order,
        query: state.query,
      );

      if (response.isSuccessful) {
        final List<RoomResponseDto> rooms = response.successfulData!;

        // print(alerts);
        if (rooms.length < state.limit) {
          state = state.copyWith(canLoadMore: false);
        }

        final currentList = state.listData;
        final resultList = state.page == 0 ? rooms : [...currentList, ...rooms];

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
  }) async {
    state = state.copyWith(
      query: query ?? state.query,
      order: order ?? state.order,
      startDate: startDate ?? state.startDate,
      endDate: endDate ?? state.endDate,
      page: page ?? state.page,
      limit: limit ?? state.limit,
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