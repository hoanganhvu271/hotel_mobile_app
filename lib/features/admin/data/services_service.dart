import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/constants/api_url.dart';
import 'package:hotel_app/core/base_response.dart';
import 'package:hotel_app/features/admin/model/service_model.dart';
import 'package:hotel_app/di/injector.dart';
import 'package:hotel_app/common/network/dio_client.dart';

final servicesService = Provider<ServicesService>((ref) => ServicesService());

class ServicesService {
  Future<BaseResponse<List<ServiceModel>>> getAllServices() async {
    try {
      Response data = await injector<DioClient>().get("${ApiUrl.baseURL}/api/service");
      List<dynamic> servicesData = data.data;

      final List<ServiceModel> services = servicesData
          .map((json) => ServiceModel.fromJson(json))
          .toList();

      return BaseResponse(isSuccessful: true, successfulData: services);
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
}