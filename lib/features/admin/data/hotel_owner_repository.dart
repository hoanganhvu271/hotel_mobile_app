import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/admin/data/hotel_owner_service.dart';
import 'package:hotel_app/features/admin/model/booking_details_dto.dart';
import 'package:hotel_app/features/admin/model/booking_dto.dart';
import 'package:hotel_app/features/admin/model/put_room_request.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/base_response.dart';
import '../../../models/room.dart';
import '../model/booking_stats_dto.dart';
import '../model/booking_status.dart';
import '../model/create_room_request.dart';
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
  Future<BaseResponse<List<RoomResponseDto>>> getAllRooms({
    int offset = 0,
    int limit = 10,
    String order = "desc",
    String query = "",
  });
  Future<BaseResponse<List<BookingResponseDto>>> getAllBookings({
    int offset = 0,
    int limit = 10,
    String order = "desc",
    String query = "",
  });

  Future<BaseResponse<RoomResponseDto>> createRoomWithImages({
    required CreateRoomRequest request,
    required XFile mainImage,
    List<XFile>? extraImages});

  Future<BaseResponse<RoomResponseDto>> updateRoomWithImages({required PutRoomRequest request, required XFile? mainImage, List<XFile>? extraImages});

  Future<BaseResponse<BookingDetailsDto>> getBookingDetails(int id);
  Future<BaseResponse<bool>> updateBookingStatus(int id, BookingStatus status);
  Future<BaseResponse<int>> countRooms({required int hotelId});
  Future<BaseResponse<int>> countBookings({required int hotelId});
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
  Future<BaseResponse<List<RoomResponseDto>>> getAllRooms({
    int offset = 0,
    int limit = 10,
    String order = "desc",
    String query = "",
  }) async {
    return await hotelOwnerApi.getAllRooms(
      id: 1,
      offset: offset,
      limit: limit,
      order: order,
      query: query,
    );
  }

  @override
  Future<BaseResponse<List<BookingResponseDto>>> getAllBookings({
    int offset = 0,
    int limit = 10,
    String order = "desc",
    String query = ""
  }) async{

    return await hotelOwnerApi.getAllBookings(
      id: 1,
      offset: offset,
      limit: limit,
      order: order,
      query: query,
    );
  }

  @override
  Future<BaseResponse<RoomResponseDto>> createRoomWithImages({required CreateRoomRequest request, required XFile mainImage, List<XFile>? extraImages}) async{
    return await hotelOwnerApi.createRoomWithImages(request: request, mainImage: mainImage, extraImages: extraImages);
  }

  @override
  Future<BaseResponse<RoomResponseDto>> updateRoomWithImages({required PutRoomRequest request, required XFile? mainImage, List<XFile>? extraImages}) async{
    return await hotelOwnerApi.updateRoomWithImages(request: request, mainImage: mainImage, extraImages: extraImages);
  }

  @override
  Future<BaseResponse<BookingDetailsDto>> getBookingDetails(int id) async{
    return await hotelOwnerApi.getBookingDetailsById(id: id);
  }

  @override
  Future<BaseResponse<bool>> updateBookingStatus(int id, BookingStatus status) async{
    return await hotelOwnerApi.updateBookingStatus(bookingId: id, status: status);
  }

  @override
  Future<BaseResponse<int>> countRooms({required int hotelId}) async{
    return await hotelOwnerApi.countRooms(hotelId: hotelId);
  }

  @override
  Future<BaseResponse<int>> countBookings({required int hotelId}) async{
    return await hotelOwnerApi.countBookings(hotelId: hotelId);
  }
}