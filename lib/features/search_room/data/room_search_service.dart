import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/network/dio_client.dart';
import 'package:hotel_app/core/base_response.dart';
import 'package:hotel_app/features/search_room/model/room_search_list.dart';
import 'package:hotel_app/di/injector.dart';
import 'package:hotel_app/features/search_room/model/search_request.dart';
import 'package:hotel_app/features/search_room/model/service.dart';

final roomSearchService =
    Provider<RoomSearchService>((ref) => RoomSearchService());

class RoomSearchService {
  Future<BaseResponse<List<RoomSearchList>>> getRoomsSearchList(
      SearchRequest request) async {
    try {
      Response data = await injector<DioClient>()
          .post('/room/search', data: request.toJson());
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
      final dataList = (data.data as List)
          .map((json) => RoomSearchList.fromJson(json))
          .toList();
      return BaseResponse(isSuccessful: true, successfulData: dataList);
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

  Future<BaseResponse<List<String>>> getCities() async {
    try {
      Response data = await injector<DioClient>().get('/address/city');
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
      final dataList =
          (data.data as List).map((json) => json.toString()).toList();
      return BaseResponse(isSuccessful: true, successfulData: dataList);
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

  Future<BaseResponse<List<String>>> getDistricts(String city) async {
    try {
      Response data = await injector<DioClient>()
          .get('/address/district', queryParameters: {'city': city});
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
      final dataList =
          (data.data as List).map((json) => json.toString()).toList();
      return BaseResponse(isSuccessful: true, successfulData: dataList);
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

  Future<BaseResponse<List<Service>>> getServices() async {
    try {
      Response data = await injector<DioClient>().get('/service');

      if (data.statusCode != 200) {
        return BaseResponse(
          isSuccessful: false,
          errorMessage: data.data['message'] ?? "Lỗi không xác định",
          errorCode: data.statusCode.toString(),
        );
      }

      if (data.data == null) {
        return BaseResponse(
          isSuccessful: false,
          errorMessage: "Không có dữ liệu",
          errorCode: data.statusCode.toString(),
        );
      }

      // ✅ Parse thẳng sang List<Service>
      final dataList = (data.data as List)
          .map((json) => Service.fromJson(json as Map<String, dynamic>))
          .toList();

      return BaseResponse(
        isSuccessful: true,
        successfulData: dataList,
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
