import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/network/dio_client.dart';
import 'package:hotel_app/core/base_response.dart';
import 'package:hotel_app/di/injector.dart';
import 'package:hotel_app/features/room_details/model/room_details.dart';

final roomDetailsSerivce =
    Provider<RoomDetailsService>((ref) => RoomDetailsService());

class RoomDetailsService {
  Future<BaseResponse<RoomDetails>> getRoomDetails(int roomId) async {
    try {
      String id = roomId.toString();
      Response data = await injector<DioClient>().get('/api/room/$id');
      if (data.statusCode != 200) {
        return BaseResponse(
            isSuccessful: false,
            errorMessage: data.data['message'] ?? "Lỗi không xác định",
            errorCode: data.statusCode.toString());
      }
      if (data.data == null) {
        return BaseResponse(
            isSuccessful: false,
            errorMessage: "Không có dữ liệu",
            errorCode: data.statusCode.toString());
      }
      return BaseResponse(
        isSuccessful: true,
        successfulData: RoomDetails.fromJson(data.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(
          isSuccessful: false,
          errorMessage: errorMessage,
          errorCode: e.response?.statusCode.toString());
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }
}
