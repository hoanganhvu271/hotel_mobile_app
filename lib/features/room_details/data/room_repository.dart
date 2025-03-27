import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/room_details/data/room_service.dart';

final roomRepository = Provider<RoomRepository>(
    (ref) => RoomRepositoryImpl(roomService: ref.watch(roomService)));

abstract class RoomRepository {
  Future<Either<String, Response>> getRoomById(String id);
}

class RoomRepositoryImpl implements RoomRepository {
  final RoomService roomService;

  RoomRepositoryImpl({required this.roomService});

  @override
  Future<Either<String, Response>> getRoomById(String id) async {
    return await roomService.getRoomById(id);
  }
}
