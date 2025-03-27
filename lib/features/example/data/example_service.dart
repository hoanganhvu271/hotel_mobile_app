import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/network/dio_client.dart';
import 'package:hotel_app/core/base_response.dart';
import 'package:hotel_app/models/example_model.dart';

import '../../../di/injector.dart';

final exampleService = Provider<ExampleService>((ref) => ExampleService());

class ExampleService {
  Future<BaseResponse<List<ExampleModel>>> getExample() async {
    try {
      Response data = await injector<DioClient>().get('https://jsonplaceholder.typicode.com/posts');
      final dataList = (data.data as List)
          .map((json) => ExampleModel.fromJson(json)).toList();
      return BaseResponse(isSuccessful: true, sucessfulData: dataList);

    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return BaseResponse(isSuccessful: false, errorMessage: errorMessage, errorCode: e.response?.statusCode.toString());
    } catch (e) {
      return BaseResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }
}
