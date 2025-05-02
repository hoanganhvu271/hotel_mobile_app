import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/admin/model/booking_stats_dto.dart';
import '../../../../core/base_state.dart';
import '../../data/hotel_owner_repository.dart';
import '../../model/review_stats_dto.dart';

final bookingStatsViewModel = AutoDisposeNotifierProvider<BookingStatsNotifier, BaseState<List<BookingStatsDto>>>(() => BookingStatsNotifier());

class BookingStatsNotifier extends AutoDisposeNotifier<BaseState<List<BookingStatsDto>>> {
  @override
  BaseState<List<BookingStatsDto>> build() {
    state = BaseState.none();
    getData();
    return state;
  }

  void getData() async {
    state = BaseState.loading();
    try {
      final response = await ref.read(hotelOwnerRepository).getBookingStats(1);

      if(response.isSuccessful){
        final List<BookingStatsDto> data = response.successfulData!;
        state = BaseState.success(data);
      }
      else{
        state = BaseState.error(response.errorMessage ?? "");
      }
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }
}

final reviewStatsViewModel = AutoDisposeNotifierProvider<ReviewStatsNotifier, BaseState<ReviewStatsDto>>(() => ReviewStatsNotifier());

class ReviewStatsNotifier extends AutoDisposeNotifier<BaseState<ReviewStatsDto>> {
  @override
  BaseState<ReviewStatsDto> build() {
    state = BaseState.none();
    getExample();
    return state;
  }

  void getExample() async {
    state = BaseState.loading();
    try {
      final response = await ref.read(hotelOwnerRepository).getReviewStats(1);

      if(response.isSuccessful){
        final ReviewStatsDto data = response.successfulData!;
        state = BaseState.success(data);
      }
      else{
        state = BaseState.error(response.errorMessage ?? "");
      }
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }
}

final roomCountViewModel = AutoDisposeNotifierProvider<CountRoomNotifier, BaseState<int>>(() => CountRoomNotifier());

class CountRoomNotifier extends AutoDisposeNotifier<BaseState<int>> {
  @override
  BaseState<int> build() {
    state = BaseState.none();
    getRoomCount();
    return state;
  }

  void getRoomCount() async {
    state = BaseState.loading();
    try {
      final response = await ref.read(hotelOwnerRepository).countRooms(hotelId: 1);

      if(response.isSuccessful){
        final int data = response.successfulData!;
        state = BaseState.success(data);
        print("Room count: $data");
      }
      else{
        print("Error: ${response.errorMessage}");
        state = BaseState.error(response.errorMessage ?? "");
      }
    } catch (e) {
      print("Exception: $e");
      state = BaseState.error(e.toString());
    }
  }
}

final bookingCountViewModel = AutoDisposeNotifierProvider<CountBookingNotifier, BaseState<int>>(() => CountBookingNotifier());

class CountBookingNotifier extends AutoDisposeNotifier<BaseState<int>> {
  @override
  BaseState<int> build() {
    state = BaseState.none();
    getBookingCount();
    return state;
  }

  void getBookingCount() async {
    state = BaseState.loading();
    try {
      final response = await ref.read(hotelOwnerRepository).countBookings(hotelId: 1);

      if(response.isSuccessful){
        final int data = response.successfulData!;
        state = BaseState.success(data);
      }
      else{
        state = BaseState.error(response.errorMessage ?? "");
      }
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }
}
