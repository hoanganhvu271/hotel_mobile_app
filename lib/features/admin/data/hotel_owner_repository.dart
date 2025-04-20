import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/admin/data/hotel_owner_service.dart';
import 'package:hotel_app/features/admin/model/booking_dto.dart';
import '../../../core/base_response.dart';
import '../../../models/room.dart';
import '../model/booking_stats_dto.dart';
import '../model/hotel_response.dart';
import '../model/review_stats_dto.dart';
import '../model/room_response_dto.dart';

final hotelOwnerRepository = Provider<HotelRepository>(
      (ref) => HotelRepositoryImpl(hotelOwnerApi: ref.watch(hotelOwnerService)),
);

abstract class HotelRepository {
  Future<BaseResponse<Hotel>> getHotelInfo(int id);
  Future<BaseResponse<List<BookingStatsDto>>> getBookingStats(int id);
  Future<BaseResponse<ReviewStatsDto>> getReviewStats(int id);
  Future<BaseResponse<List<RoomResponseDto>>> getAllRooms(int id);
  Future<BaseResponse<List<BookingResponseDto>>> getAllBookings(int id);
}

class HotelRepositoryImpl implements HotelRepository {
  final HotelOwnerService hotelOwnerApi;

  HotelRepositoryImpl({required this.hotelOwnerApi});

  @override
  Future<BaseResponse<Hotel>> getHotelInfo(int id) async {
    return await hotelOwnerApi.getHotelById(id);
  }

  @override
  Future<BaseResponse<List<BookingStatsDto>>> getBookingStats(int id) async {
    return await hotelOwnerApi.getBookingStats(id);
  }

  @override
  Future<BaseResponse<ReviewStatsDto>> getReviewStats(int id) async {
    return await hotelOwnerApi.getReviewStats(id);
  }

  @override
  Future<BaseResponse<List<RoomResponseDto>>> getAllRooms(int id) async {
    return await hotelOwnerApi.getAllRooms(id);
  }

  @override
  Future<BaseResponse<List<BookingResponseDto>>> getAllBookings(int id) async{
    return await hotelOwnerApi.getAllBookings(id);
  }
}
