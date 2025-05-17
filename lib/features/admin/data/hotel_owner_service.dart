import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/constants/api_url.dart';
import 'package:hotel_app/features/admin/model/booking_details_dto.dart';
import 'package:hotel_app/features/admin/model/booking_dto.dart';
import 'package:hotel_app/features/admin/model/booking_stats_dto.dart';
import 'package:hotel_app/features/admin/model/hotel_response.dart';
import 'package:hotel_app/features/admin/model/review_stats_dto.dart';
import 'package:hotel_app/features/admin/model/room_response_dto.dart';
import 'package:hotel_app/models/room.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/network/dio_client.dart';
import '../../../core/base_response.dart';
import '../../../di/injector.dart';
import '../model/booking_status.dart';
import '../model/create_room_request.dart';
import '../model/put_room_request.dart';

final hotelOwnerService = Provider<HotelOwnerService>((ref) => HotelOwnerService());

class HotelOwnerService {
  Future<BaseResponse<Hotel>> getHotelById(int id) async {
    try {
      Response response = await injector<DioClient>().get("${ApiUrl.hotelOwner}/hotel/$id");

      // Parse the response data to a Hotel object
      Hotel hotel = Hotel.fromJson(response.data);

      return BaseResponse(isSuccessful: true, successfulData: hotel);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(
          isSuccessful: false,
          errorMessage: errorMessage,
          errorCode: e.response?.statusCode.toString()
      );
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }

  Future<BaseResponse<List<BookingStatsDto>>> getBookingStats(int id) async {
    try {
      Response data = await injector<DioClient>().get("${ApiUrl.baseURL}/api/hotel-owner/booking/stats/per-day/$id");

      // Check if the returned data is a List
      if (data.data is List) {
        final List<BookingStatsDto> stat = (data.data as List).map((json) {
          return BookingStatsDto.fromJson(json);
        }).toList();

        return BaseResponse(isSuccessful: true, successfulData: stat);
      } else {
        return BaseResponse(isSuccessful: false, errorMessage: "Dữ liệu trả về không phải là một danh sách.");
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(isSuccessful: false, errorMessage: errorMessage, errorCode: e.response?.statusCode.toString());
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }


  Future<BaseResponse<ReviewStatsDto>> getReviewStats(int id) async {
    try {
      Response data = await injector<DioClient>().get("${ApiUrl.hotelOwner}/review/stats/monthly/$id");
      final ReviewStatsDto stat = ReviewStatsDto.fromJson(data.data);
      return BaseResponse(isSuccessful: true, successfulData: stat);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(isSuccessful: false, errorMessage: errorMessage, errorCode: e.response?.statusCode.toString());
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }

  Future<BaseResponse<List<RoomResponseDto>>> getAllRooms({
    required int id,
    int offset = 0,
    int limit = 10,
    String order = "desc",
    String query = "",
  }) async {
    try {
      Response data = await injector<DioClient>().get("${ApiUrl.hotelOwner}/rooms/$id?offset=$offset&limit=$limit&order=$order&query=$query");
      List<dynamic> roomsData = data.data;

      final List<RoomResponseDto> rooms = roomsData
          .map((json) => RoomResponseDto.fromJson(json))
          .toList();

      return BaseResponse(isSuccessful: true, successfulData: rooms);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(isSuccessful: false, errorMessage: errorMessage, errorCode: e.response?.statusCode.toString());
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }

  Future<BaseResponse<List<BookingResponseDto>>> getAllBookings({
    required int id,
    int offset = 0,
    int limit = 10,
    String order = "desc",
    String query = "",
  }) async {
    try {
      Response data = await injector<DioClient>().get("${ApiUrl.hotelOwner}/bookings/$id?offset=$offset&limit=$limit&order=$order&query=$query");
      List<dynamic> bookingsData = data.data;

      final List<BookingResponseDto> bookings = bookingsData
          .map((json) => BookingResponseDto.fromJson(json))
          .toList();

      return BaseResponse(isSuccessful: true, successfulData: bookings);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(isSuccessful: false, errorMessage: errorMessage, errorCode: e.response?.statusCode.toString());
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }

  Future<BaseResponse<RoomResponseDto>> updateRoomWithImages({
    required PutRoomRequest request,
    required XFile? mainImage,
    List<XFile>? extraImages,
  }) async {
    try {
      final formData = FormData.fromMap({
        "roomInfo": jsonEncode(request.toJson()), // gửi thông tin phòng
        if (mainImage != null)
          "mainImage": await MultipartFile.fromFile(
            mainImage.path,
            filename: mainImage.name,
          ),
        if (extraImages != null && extraImages.isNotEmpty)
          "extraImages": await Future.wait(
            extraImages.map((image) async {
              return await MultipartFile.fromFile(
                image.path,
                filename: image.name,
              );
            }),
          ),
      });

      final response = await injector<DioClient>().put(
        "${ApiUrl.hotelOwner}/update-with-images",
        data: formData,
      );

      return BaseResponse(
        isSuccessful: true,
        successfulData: RoomResponseDto.fromJson(response.data),
      );
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(
        isSuccessful: false,
        errorMessage: errorMessage,
        errorCode: e.response?.statusCode.toString(),
      );
    } catch (e) {
      return BaseResponse(
        isSuccessful: false,
        errorMessage: e.toString(),
      );
    }
  }


  Future<BaseResponse<RoomResponseDto>> createRoomWithImages({
    required CreateRoomRequest request,
    required XFile mainImage,
    List<XFile>? extraImages,
  }) async {
    try {
      final formData = FormData.fromMap({
        "roomInfo": jsonEncode(request.toJson()), // Gửi JSON như backend yêu cầu
        "mainImage": await MultipartFile.fromFile(
          mainImage.path,
          filename: mainImage.name,
        ),
        if (extraImages != null)
          "extraImages": await Future.wait(extraImages.map((image) async {
            return await MultipartFile.fromFile(
              image.path,
              filename: image.name,
            );
          })),
      });

      final response = await injector<DioClient>().post(
        "${ApiUrl.hotelOwner}/create-with-images",
        data: formData,
      );

      return BaseResponse(isSuccessful: true, successfulData: RoomResponseDto.fromJson(response.data));

    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(
        isSuccessful: false,
        errorMessage: errorMessage,
        errorCode: e.response?.statusCode.toString(),
      );
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }

  Future<BaseResponse<BookingDetailsDto>> getBookingDetailsById({required int id}) async{
    try {
      Response data = await injector<DioClient>().get("${ApiUrl.hotelOwner}/booking/$id");
      // print(data.data);
      final details = BookingDetailsDto.fromJson(data.data);
      return BaseResponse(isSuccessful: true, successfulData: details);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(isSuccessful: false, errorMessage: errorMessage, errorCode: e.response?.statusCode.toString());
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }

  Future<BaseResponse<bool>> updateBookingStatus({
    required int bookingId,
    required BookingStatus status,
  }) async {
    try {
      final response = await injector<DioClient>().put(
        "${ApiUrl.hotelOwner}/booking/status/$bookingId",
        queryParameters: {
          "status": status.name,
        },
      );

      return BaseResponse(
        isSuccessful: true,
        successfulData: response.data['success'],
      );
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(
        isSuccessful: false,
        errorMessage: errorMessage,
        errorCode: e.response?.statusCode.toString(),
      );
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }

  Future<BaseResponse<int>> countRooms({
    required int hotelId,
  }) async {
    try {
      final response = await injector<DioClient>().get(
        "${ApiUrl.hotelOwner}/rooms/count/$hotelId",
      );

      return BaseResponse(
        isSuccessful: true,
        successfulData: response.data,
      );
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(
        isSuccessful: false,
        errorMessage: errorMessage,
        errorCode: e.response?.statusCode.toString(),
      );
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }

  Future<BaseResponse<int>> countBookings({
    required int hotelId,
  }) async {
    try {
      final response = await injector<DioClient>().get(
        "${ApiUrl.hotelOwner}/bookings/count/$hotelId",
      );

      return BaseResponse(
        isSuccessful: true,
        successfulData: response.data,
      );
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(
        isSuccessful: false,
        errorMessage: errorMessage,
        errorCode: e.response?.statusCode.toString(),
      );
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }
}
