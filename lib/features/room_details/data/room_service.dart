import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/network/dio_client.dart';
import 'package:hotel_app/di/injector.dart';

final roomService = Provider<RoomService>((ref) => RoomService());

class RoomService {
  Future<Either<String, Response>> getRoomById(String id) async {
    try {
      Response data = await injector<DioClient>().get('/rooms/$id');
      print("service");
      return Right(data);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Lỗi không xác định";
      return Left(errorMessage);
    } catch (e) {
      return Left("Lỗi không xác định: ${e.toString()}");
    }
  }
}
