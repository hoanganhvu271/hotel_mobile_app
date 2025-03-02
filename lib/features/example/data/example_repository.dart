import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/example_model.dart';
import 'example_service.dart';


final exampleRepository = Provider<ExampleRepository>(
      (ref) => ExampleRepositoryImpl(exampleService: ref.watch(exampleService)),
);

abstract class ExampleRepository {
  Future<Either<String, Response>> getExample();
}

class ExampleRepositoryImpl implements ExampleRepository {
  final ExampleService exampleService;

  ExampleRepositoryImpl({required this.exampleService});

  @override
  Future<Either<String, Response>> getExample() async {
    return await exampleService.getExample();
  }
}
