import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_state.dart';
import 'package:hotel_app/features/admin/data/hotel_owner_repository.dart';
import 'package:hotel_app/features/admin/model/hotel_response.dart';

import '../../../../models/address.dart';

final userHotelsProvider = AutoDisposeNotifierProvider<UserHotelsNotifier, BaseState<List<Hotel>>>(
        () => UserHotelsNotifier()
);

class UserHotelsNotifier extends AutoDisposeNotifier<BaseState<List<Hotel>>> {
  @override
  BaseState<List<Hotel>> build() {
    state = BaseState.none();
    return state;
  }

  Future<void> getUserHotels() async {
    state = BaseState.loading();
    try {
      // For now, we'll use a mock implementation that gets hotels by user ID
      // In a real implementation, you would make an API call to get the user's hotels
      // For example: final response = await ref.read(hotelOwnerRepository).getHotelsByUser(userId);

      // Temporarily hardcoded for demonstration - replace with actual API call
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay

      final List<Hotel> demoHotels = [
        Hotel(
          hotelId: 1,
          hotelName: "PTIT Hotel",
          address: Address(
              city: "Ha Noi",
              district: "Ha Dong",
              ward: "Mo Lao",
              specificAddress: "235 Nguyen Ngoc Vu"
          ),
        ),
        Hotel(
          hotelId: 2,
          hotelName: "Riverside Hotel",
          address: Address(
              city: "Ho Chi Minh",
              district: "District 1",
              ward: "Ben Nghe",
              specificAddress: "123 Le Loi Street"
          ),
        ),
        Hotel(
          hotelId: 3,
          hotelName: "Mountain View Resort",
          address: Address(
              city: "Da Lat",
              district: "Central",
              ward: "Ward 8",
              specificAddress: "45 Tran Hung Dao"
          ),
        ),
      ];

      state = BaseState.success(demoHotels);
    } catch (e) {
      state = BaseState.error(e.toString());
    }
  }
}