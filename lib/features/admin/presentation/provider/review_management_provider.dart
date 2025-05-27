import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/admin/data/hotel_owner_repository.dart';
import 'package:hotel_app/features/admin/model/review_response_dto.dart';
import 'package:hotel_app/features/admin/model/search_data.dart';

final reviewManagementProvider = AutoDisposeNotifierProvider<ReviewManagementNotifier, SearchData<ReviewResponseDto>>(() => ReviewManagementNotifier());

class ReviewManagementNotifier extends AutoDisposeNotifier<SearchData<ReviewResponseDto>> {
  @override
  SearchData<ReviewResponseDto> build() {
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

      int? rating = state.rating;
      if (rating == null || rating <= 0) {
        rating = null;
      }

      final response = await ref.read(hotelOwnerRepository).getAllReviews(
        offset: state.page,
        limit: state.limit,
        order: state.order,
        query: state.query,
        rating: rating,
      );

      if (response.isSuccessful) {
        final List<ReviewResponseDto> reviews = response.successfulData!;

        if (reviews.length < state.limit) {
          state = state.copyWith(canLoadMore: false);
        }

        final currentList = state.listData;
        final resultList = state.page == 0 ? reviews : [...currentList, ...reviews];

        if (resultList.isEmpty) {
          state = state.copyWith(status: BaseStatus.emptyData, listData: resultList);
        } else {
          state = state.copyWith(
            status: BaseStatus.success,
            listData: resultList,
            page: state.page + 1,
          );
        }
      } else {
        state = state.copyWith(status: BaseStatus.error);
      }
    } catch (e) {
      state = state.copyWith(status: BaseStatus.error);
    }
  }

  Future<void> setSearchState({
    String? query,
    String? order,
    int? startDate,
    int? endDate,
    int? page,
    int? limit,
    int? rating,
  }) async {
    state = state.copyWith(
      query: query ?? state.query,
      order: order ?? state.order,
      startDate: startDate ?? state.startDate,
      endDate: endDate ?? state.endDate,
      page: page ?? state.page,
      limit: limit ?? state.limit,
      rating: rating ?? state.rating,
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

  Future<void> replyToReview(int reviewId, String reply) async {
    try {
      final response = await ref.read(hotelOwnerRepository).replyToReview(reviewId, reply);

      if (response.isSuccessful) {
        // Refresh the reviews list to show the updated reply
        refresh();
      }
    } catch (e) {
      // Handle error - you might want to show a snackbar or toast
      print('Error replying to review: $e');
    }
  }
}