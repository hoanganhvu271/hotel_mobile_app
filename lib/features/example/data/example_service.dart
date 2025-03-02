import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/network/dio_client.dart';

import '../../../di/injector.dart';

final exampleService = Provider<ExampleService>((ref) => ExampleService());

class ExampleService {
  Future<Either<String, Response>> getExample() async {
    try {
      Response data = await injector<DioClient>().get('https://jsonplaceholder.typicode.com/posts');
      return Right(data);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return Left(errorMessage);
    } catch (e) {
      return Left("Lỗi không xác định: ${e.toString()}");
    }
  }
}
