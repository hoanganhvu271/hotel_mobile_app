import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/network/dio_client.dart';
import 'package:hotel_app/core/base_response.dart';
import 'package:hotel_app/features/search_room/model/search_entry.dart';
import 'package:hotel_app/di/injector.dart';

final searchEntryService =
    Provider<SearchEntryService>((ref) => SearchEntryService());

class SearchEntryService {
  Future<BaseResponse<List<SearchEntry>>> getSearchEntries(String query) async {
    try {
      Response data = await injector<DioClient>()
          .get('/search-suggestions', queryParameters: {'query': query});
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
          .map((json) => SearchEntry.fromJson(json))
          .toList();
      return BaseResponse(isSuccessful: true, sucessfulData: dataList);
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
