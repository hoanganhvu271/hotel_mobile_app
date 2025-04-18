import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_response.dart';
import '../../../models/example_model.dart';
import 'example_service.dart';


final exampleRepository = Provider<ExampleRepository>(
      (ref) => ExampleRepositoryImpl(exampleService: ref.watch(exampleService)),
);

abstract class ExampleRepository {
  Future<BaseResponse<List<ExampleModel>>> getExample();
}

class ExampleRepositoryImpl implements ExampleRepository {
  final ExampleService exampleService;

  ExampleRepositoryImpl({required this.exampleService});

  @override
  Future<BaseResponse<List<ExampleModel>>> getExample() async {
    return await exampleService.getExample();
  }
}
