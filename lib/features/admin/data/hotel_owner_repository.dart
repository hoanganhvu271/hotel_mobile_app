import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/admin/data/hotel_owner_service.dart';
import 'package:hotel_app/features/admin/model/booking_details_dto.dart';
import 'package:hotel_app/features/admin/model/booking_dto.dart';
import 'package:hotel_app/features/admin/model/put_room_request.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/hotel_storage_provider.dart';
import '../../../core/base_response.dart';
import '../model/booking_stats_dto.dart';
import '../model/booking_status.dart';
import '../model/create_room_request.dart';
import '../model/hotel_response.dart';
import '../model/review_response_dto.dart';
import '../model/review_stats_dto.dart';
import '../model/room_response_dto.dart';

final hotelOwnerRepository = Provider<HotelRepository>(
      (ref) => HotelRepositoryImpl(
    hotelOwnerApi: ref.watch(hotelOwnerService),
    hotelStorage: ref.watch(hotelStorageProvider),
  ),
);

abstract class HotelRepository {
  Future<BaseResponse<Hotel>> getHotelInfo();
  Future<BaseResponse<List<BookingStatsDto>>> getBookingStats();
  Future<BaseResponse<ReviewStatsDto>> getReviewStats();
  Future<BaseResponse<List<RoomResponseDto>>> getAllRooms({
    int offset = 0,
    int limit = 10,
    String order = "desc",
    String query = "",
  });

  Future<BaseResponse<bool>> createRoomWithImages({
    required CreateRoomRequest request,
    required XFile mainImage,
    List<XFile>? extraImages});

  Future<BaseResponse<bool>> updateRoomWithImages({
    required PutRoomRequest request,
    required XFile? mainImage,
    List<XFile>? extraImages
  });

  Future<BaseResponse<BookingDetailsDto>> getBookingDetails(int id);
  Future<BaseResponse<bool>> updateBookingStatus(int id, BookingStatus status);
  Future<BaseResponse<int>> countRooms();
  Future<BaseResponse<int>> countBookings();
  Future<BaseResponse<List<ReviewResponseDto>>> getAllReviews({
    int offset = 0,
    int limit = 10,
    String order = "desc",
    String query = "",
    int? rating
  });

  Future<BaseResponse<bool>> replyToReview(int reviewId, String reply);
  Future<BaseResponse<bool>> deleteRoom(int roomId);
  Future<BaseResponse<bool>> checkRoomHasBookings(int roomId);
  Future<BaseResponse<List<BookingResponseDto>>> getAllBookings({
    int offset = 0,
    int limit = 10,
    String order = "desc",
    String query = "",
    String? status,
  });
}

class HotelRepositoryImpl implements HotelRepository {
  final HotelOwnerService hotelOwnerApi;
  final HotelStorage hotelStorage;

  HotelRepositoryImpl({
    required this.hotelOwnerApi,
    required this.hotelStorage,
  });

  // Get the current hotel ID from storage
  int? _getCurrentHotelId() {
    final hotelId = hotelStorage.getCurrentHotelId();
    if (hotelId == null) {
      throw Exception("No hotel selected. Please select a hotel first.");
    }
    return hotelId;
  }

  @override
  Future<BaseResponse<Hotel>> getHotelInfo() async {
    final hotelId = _getCurrentHotelId();
    return await hotelOwnerApi.getHotelById(hotelId!);
  }

  @override
  Future<BaseResponse<List<BookingStatsDto>>> getBookingStats() async {
    final hotelId = _getCurrentHotelId();
    return await hotelOwnerApi.getBookingStats(hotelId!);
  }

  @override
  Future<BaseResponse<ReviewStatsDto>> getReviewStats() async {
    final hotelId = _getCurrentHotelId();
    return await hotelOwnerApi.getReviewStats(hotelId!);
  }

  @override
  Future<BaseResponse<List<RoomResponseDto>>> getAllRooms({
    int offset = 0,
    int limit = 10,
    String order = "desc",
    String query = "",
  }) async {
    final hotelId = _getCurrentHotelId();
    return await hotelOwnerApi.getAllRooms(
      id: hotelId!,
      offset: offset,
      limit: limit,
      order: order,
      query: query,
    );
  }

  @override
  Future<BaseResponse<bool>> createRoomWithImages({
    required CreateRoomRequest request,
    required XFile mainImage,
    List<XFile>? extraImages
  }) async {
    // Update the request to use the current hotel ID
    final hotelId = _getCurrentHotelId();
    final updatedRequest = CreateRoomRequest(
      roomName: request.roomName,
      area: request.area,
      comboPrice2h: request.comboPrice2h,
      pricePerNight: request.pricePerNight,
      extraHourPrice: request.extraHourPrice,
      standardOccupancy: request.standardOccupancy,
      maxOccupancy: request.maxOccupancy,
      numChildrenFree: request.numChildrenFree,
      bedNumber: request.bedNumber,
      extraAdult: request.extraAdult,
      description: request.description,
      hotelId: hotelId!,
      serviceIds: request.serviceIds,
    );

    return await hotelOwnerApi.createRoomWithImages(
        request: updatedRequest,
        mainImage: mainImage,
        extraImages: extraImages
    );
  }

  @override
  Future<BaseResponse<bool>> updateRoomWithImages({
    required PutRoomRequest request,
    required XFile? mainImage,
    List<XFile>? extraImages
  }) async {
    return await hotelOwnerApi.updateRoomWithImages(
        request: request,
        mainImage: mainImage,
        extraImages: extraImages
    );
  }

  @override
  Future<BaseResponse<BookingDetailsDto>> getBookingDetails(int id) async {
    return await hotelOwnerApi.getBookingDetailsById(id: id);
  }

  @override
  Future<BaseResponse<bool>> updateBookingStatus(int id, BookingStatus status) async {
    return await hotelOwnerApi.updateBookingStatus(bookingId: id, status: status);
  }

  @override
  Future<BaseResponse<int>> countRooms() async {
    final hotelId = _getCurrentHotelId();
    return await hotelOwnerApi.countRooms(hotelId: hotelId!);
  }

  @override
  Future<BaseResponse<int>> countBookings() async {
    final hotelId = _getCurrentHotelId();
    return await hotelOwnerApi.countBookings(hotelId: hotelId!);
  }

  @override
  Future<BaseResponse<List<ReviewResponseDto>>> getAllReviews({
    int offset = 0,
    int limit = 10,
    String order = "desc",
    String query = "",
    int? rating,
  }) async {
    final hotelId = _getCurrentHotelId();
    return await hotelOwnerApi.getAllReviews(
      id: hotelId!,
      offset: offset,
      limit: limit,
      order: order,
      query: query,
      rating: rating,
    );
  }

  Future<BaseResponse<bool>> replyToReview(int reviewId, String reply) async {
    return await hotelOwnerApi.replyToReview(reviewId, reply);
  }

  @override
  Future<BaseResponse<bool>> deleteRoom(int roomId) async {
    return await hotelOwnerApi.deleteRoom(roomId);
  }

  @override
  Future<BaseResponse<bool>> checkRoomHasBookings(int roomId) async {
    return await hotelOwnerApi.checkRoomHasBookings(roomId);
  }

  @override
  Future<BaseResponse<List<BookingResponseDto>>> getAllBookings({
    int offset = 0,
    int limit = 10,
    String order = "desc",
    String query = "",
    String? status
  }) async {
    print(status);
    final hotelId = _getCurrentHotelId();
    return await hotelOwnerApi.getAllBookings(
      id: hotelId!,
      offset: offset,
      limit: limit,
      order: order,
      query: query,
      status: status,
    );
  }
}