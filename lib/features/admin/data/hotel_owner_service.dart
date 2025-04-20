import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/constants/api_url.dart';
import 'package:hotel_app/features/admin/model/booking_dto.dart';
import 'package:hotel_app/features/admin/model/booking_stats_dto.dart';
import 'package:hotel_app/features/admin/model/hotel_response.dart';
import 'package:hotel_app/features/admin/model/review_stats_dto.dart';
import 'package:hotel_app/features/admin/model/room_response_dto.dart';
import 'package:hotel_app/models/room.dart';
import '../../../common/network/dio_client.dart';
import '../../../core/base_response.dart';
import '../../../di/injector.dart';

final hotelOwnerService = Provider<HotelOwnerService>((ref) => HotelOwnerService());

class HotelOwnerService {
  Future<BaseResponse<Hotel>> getHotelById(int id) async {
    try {
      Response data = await injector<DioClient>().get("${ApiUrl.baseURL}${ApiUrl.hotelOwner}/$id");
      final Hotel hotel = data.data
          .map((json) => Hotel.fromJson(json));
      return BaseResponse(isSuccessful: true, successfulData: hotel);

    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(isSuccessful: false, errorMessage: errorMessage, errorCode: e.response?.statusCode.toString());
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }

  Future<BaseResponse<List<BookingStatsDto>>> getBookingStats(int id) async {
    try {
      Response data = await injector<DioClient>().get("${ApiUrl.baseURL}${ApiUrl.hotelOwner}/booking/stats/per-day/$id");
      final List<BookingStatsDto> stat = data.data
          .map((json) => Hotel.fromJson(json)).toList();
      return BaseResponse(isSuccessful: true, successfulData: stat);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(isSuccessful: false, errorMessage: errorMessage, errorCode: e.response?.statusCode.toString());
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }

  Future<BaseResponse<ReviewStatsDto>> getReviewStats(int id) async {
    try {
      Response data = await injector<DioClient>().get("${ApiUrl.baseURL}${ApiUrl.hotelOwner}/review/stats/monthly/$id");
      final ReviewStatsDto stat = ReviewStatsDto.fromJson(data.data);
      return BaseResponse(isSuccessful: true, successfulData: stat);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(isSuccessful: false, errorMessage: errorMessage, errorCode: e.response?.statusCode.toString());
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }

  Future<BaseResponse<List<RoomResponseDto>>> getAllRooms(int id) async {
    try {
      Response data = await injector<DioClient>().get("${ApiUrl.baseURL}${ApiUrl.hotelOwner}/room/$id");
      final List<RoomResponseDto> rooms = data.data
          .map((json) => RoomResponseDto.fromJson(json)).toList();
      return BaseResponse(isSuccessful: true, successfulData: rooms);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(isSuccessful: false, errorMessage: errorMessage, errorCode: e.response?.statusCode.toString());
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }

  Future<BaseResponse<List<BookingResponseDto>>> getAllBookings(int id) async {
    try {
      Response data = await injector<DioClient>().get("${ApiUrl.baseURL}${ApiUrl.hotelOwner}/booking/$id");
      final List<BookingResponseDto> bookings = data.data
          .map((json) => BookingResponseDto.fromJson(json)).toList();
      return BaseResponse(isSuccessful: true, successfulData: bookings);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(isSuccessful: false, errorMessage: errorMessage, errorCode: e.response?.statusCode.toString());
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }
}
